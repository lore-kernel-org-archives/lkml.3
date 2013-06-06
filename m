Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3FFUzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:55:20 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44380 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3FFUzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:55:18 -0400
Date: Thu, 6 Jun 2013 13:55:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: stop_machine lockup issue in 3.9.y.
Message-ID: <20130606205514.GC5045@htj.dyndns.org>
References: <51AF6E54.3050108@candelatech.com>
 <20130605184807.GD10693@mtj.dyndns.org>
 <51AF8D4B.4090407@candelatech.com>
 <51AF91F5.6090801@candelatech.com>
 <51AFA677.9010605@candelatech.com>
 <20130605211157.GK10693@mtj.dyndns.org>
 <1370482492.24311.308.camel@edumazet-glaptop>
 <20130606031444.GA12335@mtj.dyndns.org>
 <1370489181.24311.318.camel@edumazet-glaptop>
 <51B004CD.6080007@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B004CD.6080007@candelatech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ben.

On Wed, Jun 05, 2013 at 08:41:01PM -0700, Ben Greear wrote:
> On 06/05/2013 08:26 PM, Eric Dumazet wrote:
> >On Wed, 2013-06-05 at 20:14 -0700, Tejun Heo wrote:
> >>Ah, so, that's why it's showing up now.  We probably have had the same
> >>issue all along but it used to be masked by the softirq limiting.  Do
> >>you care to revive the 10 iterations limit so that it's limited by
> >>both the count and timing?  We do wanna find out why softirq is
> >>spinning indefinitely tho.
> >
> >Yes, no problem, I can do that.
> 
> Limiting it to 5000 fixes my problem, so if you wanted it larger than 10, that would
> be fine by me.

First of all, kudos for tracking the issue down.  While the removal of
looping limit in softirq handling was the direct cause for making the
problem visible, it's very bothering that we have softirq runaway.
Finding out the perpetrator shouldn't be hard.  Something like the
following should work (untested).  Once we know which softirq (prolly
the network one), we can dig deeper.

Thanks.

diff --git a/kernel/softirq.c b/kernel/softirq.c
index b5197dc..5af3682 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -212,6 +212,7 @@ asmlinkage void __do_softirq(void)
 	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
 	int cpu;
 	unsigned long old_flags = current->flags;
+	int cnt = 0;
 
 	/*
 	 * Mask out PF_MEMALLOC s current task context is borrowed for the
@@ -244,6 +245,9 @@ restart:
 			kstat_incr_softirqs_this_cpu(vec_nr);
 
 			trace_softirq_entry(vec_nr);
+			if (++cnt >= 5000 && cnt < 5010)
+				printk("XXX __do_softirq: stuck handling softirqs, cnt=%d action=%pf\n",
+				       cnt, h->action);
 			h->action(h);
 			trace_softirq_exit(vec_nr);
 			if (unlikely(prev_count != preempt_count())) {


-- 
tejun
