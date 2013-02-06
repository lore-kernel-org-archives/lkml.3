Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab3BFEhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:37:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19252 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068Ab3BFEhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:37:00 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_Bp3_fu7e2UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wIfm1DkAj9kA:10 a=uYVGJH5IAAAA:8 a=ZVN5dE_08wqKVVRBcUYA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360125419.2621.39.camel@gandalf.local.home>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Tue, 05 Feb 2013 23:36:59 -0500
In-Reply-To: <5111CE60.4080403@candelatech.com>
References: <5111AD8D.1080005@candelatech.com>
	  <20130206015430.GA9161@home.goodmis.org>
	 <5111BF51.5010607@candelatech.com>
	 <1360119124.2621.37.camel@gandalf.local.home>
	 <5111CE60.4080403@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 19:30 -0800, Ben Greear wrote:

> It's huge, so here's a link:
> 
> http://www.candelatech.com/~greearb/debug.tgz
> 

The trace shows that __netif_receive_skb() is grabbing an
rcu_read_lock() but never releasing it. But I don't see any possible way
that can be true in the code.

Can you apply the following patch and run the trace again. I'd like to
see if the code is going in the path I expect it is.

Thanks,

-- Steve

diff --git a/net/core/dev.c b/net/core/dev.c
index e5942bf..5b12ff5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3260,6 +3260,7 @@ static int __netif_receive_skb(struct sk_buff *skb)
 	pt_prev = NULL;
 
 	rcu_read_lock();
+	trace_printk("lock\n");
 
 another_round:
 	skb->skb_iif = skb->dev->ifindex;
@@ -3314,6 +3315,7 @@ ncls:
 	}
 
 	rx_handler = rcu_dereference(skb->dev->rx_handler);
+	trace_printk("handler %pS\n", rx_handler);
 	if (rx_handler) {
 		if (pt_prev) {
 			ret = deliver_skb(skb, pt_prev, orig_dev);
@@ -3359,6 +3361,7 @@ ncls:
 	} else {
 drop:
 		atomic_long_inc(&skb->dev->rx_dropped);
+		trace_printk("kfree\n");
 		kfree_skb(skb);
 		/* Jamal, now you will not able to escape explaining
 		 * me how you were going to use this. :-)
@@ -3367,6 +3370,7 @@ drop:
 	}
 
 unlock:
+	trace_printk("unlock\n");
 	rcu_read_unlock();
 out:
 	tsk_restore_flags(current, pflags, PF_MEMALLOC);


