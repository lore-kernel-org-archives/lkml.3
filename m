Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3JJLDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:03:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54958 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365Ab3JJLDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:03:14 -0400
Date: Thu, 10 Oct 2013 12:03:09 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Peng, Arthur" <Arthur.Peng@sonymobile.com>,
        "Zhang, Bojie" <Bojie.Zhang@sonymobile.com>
Subject: Re: BUG report about ipt_do_table( )
Message-ID: <20131010110309.GA6199@mudshark.cambridge.arm.com>
References: <35FD53F367049845BC99AC72306C23D1014D1A0971B1@CNBJMBX05.corpusers.net>
 <20131010094824.GF3817@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1014D1A0971B4@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D1014D1A0971B4@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 11:22:21AM +0100, Wang, Yalin wrote:
> Thanks for your reply .

No problem.

> I have compare our kernel with 3.12 ,  
> Ip_tables.c x_tables.c  is the same ,
> So the BUG should can also be reproduce on 3.12 (just my guess).

[...]

> /-----------------------------------------------------------------------/
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 8d987c3..2353bcc 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -819,6 +819,12 @@ xt_replace_table(struct xt_table *table,
>  		return NULL;
>  	}
>  
> +	/*
> +	 * make sure the change is write to the memory
> +	 * so that the other CPU can see the changes
> +	 */
> +	mb();
> +
>  	/* Do the substitution. */
>  	local_bh_disable();
>  	private = table->private;
> 
> /-----------------------------------------------------------------------/
> 
> 
> I add a memory barrier before update table->private .
> Make sure the other CPU can see the update memory correctly.
> When the BUG happened, the other CPU can get the new private (struct xt_table_info *),
> But sometimes it see private->jumpstack == NULL  , or sometimes it see private->jumpstack[cpu] == NULL ,

On one CPU, xt_replace_table is basically doing:

	newinfo->jumpstack = kzalloc(...);
	table->private = newinfo;

so this can be thought of as the `writer' thread.

Then, on another CPU (the `reader'), we run ipt_do_table:

	private = table->private;
	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];

The reader has an address dependency, so the loads are guaranteed to be
observed in order (on sane CPUs... this is probably broken for Alpha).

However, the two stores from the writer can be observed in any order by other
CPUs. To make this clearer, I think you actually want an smb_wmb() immediately
before the assignment to table->private (and that assignment to
newinfo->initial_entries probably needs moving above it). Then you want an
smb_read_barrier_depends on the read path immediately after reading
table->private.

> This is caused by CPU write buffer ? 
> It has written table->private , but has not update private-> members (still in write buffer)  ,
> This is really out of order write, will this happened on modern armv7 CPU?
> Especially like cortex-a15 , it can execute code out of order .

Well, stores aren't speculated and stores to the same location are always
observed in order (on ARM). This is more a consequence of the weakly ordered
memory model, which largely comes about due to speculative loads and write
buffering (including read forwarding). Things like cache coherence protocols
and buffers in the interconnect can also cause stores to be observed in
different orders, since there conceptually end up being multi copies of the
data being written.

Anyway, can you see if the patch below fixes your problem please?

Will

--->8

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index d23118d..cadda40 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -326,6 +326,7 @@ ipt_do_table(struct sk_buff *skb,
        local_bh_disable();
        addend = xt_write_recseq_begin();
        private = table->private;
+       smp_read_barrier_depends();
        cpu        = smp_processor_id();
        table_base = private->entries[cpu];
        jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8b03028..ee5e184 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -845,8 +845,9 @@ xt_replace_table(struct xt_table *table,
                return NULL;
        }
 
-       table->private = newinfo;
        newinfo->initial_entries = private->initial_entries;
+       smb_wmb();
+       table->private = newinfo;
 
        /*
         * Even though table entries have now been swapped, other CPU's

