Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaFBWow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:44:52 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:35891 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaFBWou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:44:50 -0400
Message-ID: <1401749088.3645.189.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <waiman.long@hp.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Date: Mon, 02 Jun 2014 15:44:48 -0700
In-Reply-To: <20140602220831.GG22231@linux.vnet.ibm.com>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
	 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
	 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
	 <20140602163032.GI16155@laptop.programming.kicks-ass.net>
	 <538CB56E.5010709@hp.com>
	 <20140602200525.GD13930@laptop.programming.kicks-ass.net>
	 <CA+55aFwJwVf_MbcwNNWg-KrLdoOaV2xse2jzvBZTJHJgC_Htvg@mail.gmail.com>
	 <20140602210227.GE22231@linux.vnet.ibm.com>
	 <CA+55aFzX3oDvzqh4AfkJ7-X1Yfo8obFM+jOOmwzeN-GyqOPLJg@mail.gmail.com>
	 <20140602220831.GG22231@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 15:08 -0700, Paul E. McKenney wrote:

> diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
> index c639556f3fa0..c0120279dead 100644
> --- a/kernel/rcu/srcu.c
> +++ b/kernel/rcu/srcu.c
> @@ -295,12 +295,15 @@ EXPORT_SYMBOL_GPL(cleanup_srcu_struct);
>  int __srcu_read_lock(struct srcu_struct *sp)
>  {
>  	int idx;
> +	unsigned long *lp;
>  
>  	idx = ACCESS_ONCE(sp->completed) & 0x1;
>  	preempt_disable();
> -	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 1;
> +	lp = this_cpu_ptr(&sp->per_cpu_ref->c[idx]);
> +	ACCESS_ONCE(*lp) = *lp + 1;
>  	smp_mb(); /* B */  /* Avoid leaking the critical section. */
> -	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->seq[idx]) += 1;
> +	lp = this_cpu_ptr(&sp->per_cpu_ref->seq[idx]);
> +	ACCESS_ONCE(*lp) = *lp + 1;
>  	preempt_enable();
>  	return idx;
>  

This probably could use the following 

diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index c639556f3fa0..3a97eb6f9076 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -298,9 +298,9 @@ int __srcu_read_lock(struct srcu_struct *sp)
 
 	idx = ACCESS_ONCE(sp->completed) & 0x1;
 	preempt_disable();
-	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 1;
+	this_cpu_inc(sp->per_cpu_ref->c[idx]);
 	smp_mb(); /* B */  /* Avoid leaking the critical section. */
-	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->seq[idx]) += 1;
+	this_cpu_inc(sp->per_cpu_ref->seq[idx]);
 	preempt_enable();
 	return idx;
 }


