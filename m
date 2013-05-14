Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3ENHhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:37:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51527 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3ENHh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:37:29 -0400
Message-ID: <1368517039.5885.3.camel@marge.simpson.net>
Subject: Re: dynticks: CONFIG_VIRT_CPU_ACCOUNTING +  CONFIG_CONTEXT_TRACKING
 breaks accounting on core2 CPUs only
From: Mike Galbraith <bitbucket@online.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 14 May 2013 09:37:19 +0200
In-Reply-To: <20130514005744.GA12749@somewhere>
References: <1368346669.5998.13.camel@marge.simpson.net>
	 <20130514005744.GA12749@somewhere>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:P4yoq2b9O3XRo41JJM7wb4xGLq9xC7LKOht4eFaL9xn
 V4g894fgHhmVf37Z7ELLjg4P7w5C9F+ZurmcnDHKlpz/lstZez
 SuP88CtZWfOnqqA84LU8Vup5CbT8ycZWMs18FwR+p4GJXNgfWm
 3v+krdjvUUDaUdtVKBkd1f7YMyV7ppQOtme1mU4HZkB0dZ5X3n
 7Jk2kOpHlKiY/4DU9jIjyd4EZPBet61N+2iIR8JjIpf1ZJDkZa
 1CP9DbWXh1UWBQ7G57zK3aq66jzyfw+YltSfu4/D/YxB27iwq0
 3VjTAszsCVRhfipxGbPNgqU6iqNYFdQPwbagJhvnP660tO1JZ3
 0UAs9SPLnJtFvn85NLnWVLvn2p9l3M73a8BzCqmB3qlik/b/jG
 JdZt3c/kszSzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 02:57 +0200, Frederic Weisbecker wrote:
> On Sun, May 12, 2013 at 10:17:49AM +0200, Mike Galbraith wrote:
> > Greetings,
> > 
> > Turning on new NO_HZ feature on my Q6600 box in master, I see that tasks
> > accrue zero utime/stime.  However, the same exact kernel on E5620 box
> > works fine, so it would appear there's a CPU dependency somewhere.
> 
> Ah indeed, I just managed to reproduce the same issue.
> 
> > 
> > Is core2 expected to go dysfunctional with context tracking enabled?
> > CONFIG_VIRT_CPU_ACCOUNTING alone works fine in 3.9-stable, turn on
> > CONFIG_CONTEXT_TRACKING_FORCE, and CPU accounting stops working on core2
> > boxen only, same exact kernel continues to work just fine on E5620
> > (Westmere) box.
> 
> There was no known issue with core2. The box where I'm seeing the it
> is a Phenom quad core that had NR_CPUS=2. May be the issue is more
> likely to happen with this low number. I don't know.
> 
> I'm investigating further.

Me too.

bash-6023  [001] d...   290.494214: vtime_delta: clock: 289702961236 vtime_snap: 290493017701

Always.  Not good.

I see..

current->vtime_snap = sched_clock();

and..

clock = local_clock();

Things that make ya go hmm.  The below "fixes" it (not).

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index cc2dc3ee..3133665 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -634,14 +634,17 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 #endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
-static unsigned long long vtime_delta(struct task_struct *tsk)
+static noinline unsigned long long vtime_delta(struct task_struct *tsk)
 {
 	unsigned long long clock;
 
-	clock = local_clock();
+//	clock = local_clock();
+	clock = sched_clock();
+	trace_printk("clock: %Lu vtime_snap: %Lu\n", clock, tsk->vtime_snap);
 	if (clock < tsk->vtime_snap)
 		return 0;
 
+	trace_printk("clock: %Lu vtime_snap: %Lu returns :%Lu\n", clock, tsk->vtime_snap, clock - tsk->vtime_snap);
 	return clock - tsk->vtime_snap;
 }
 



