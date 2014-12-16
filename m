Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbaLPOcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:32:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:50290 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaLPOcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:32:45 -0500
Date: Tue, 16 Dec 2014 15:32:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
In-Reply-To: <alpine.DEB.2.11.1412161105470.17382@nanos>
Message-ID: <alpine.DEB.2.11.1412161510000.17382@nanos>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com> <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com> <548E8D01.9050707@linux.vnet.ibm.com> <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com> <20141215234443.GA23297@lerouge>
 <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com> <548FFD20.1040102@linux.vnet.ibm.com> <alpine.DEB.2.11.1412161105470.17382@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Thomas Gleixner wrote:
> Now the powerclamp mess is a different story.
> 
> Calling tick_nohz_idle_enter()/exit() from outside the idle task is
> just broken. Period.
> 
> Trying to work around that madness in the core code is just fiddling
> with the symptoms and ignoring the root cause. And the root cause is
> simply that powerclamp calls tick_nohz_idle_enter()/exit().

The only sane solution for that insanity is to rip out the thread code
from powerclamp and replace it with a simple per cpu timer.

timerfn() 
{
   too_hot = magic();
   sched_fair_this_cpu_wreckaged(too_hot);   
   restart_clamp_timer();
}

And have the following in sched

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df2cdf77f899..d257b62ee533 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4989,6 +4989,34 @@ preempt:
 		set_last_buddy(se);
 }
 
+#ifdef CONFIG_WRECKAGE_SCHED_FAIR
+static struct static_key wreckage_key = STATIC_KEY_INIT;
+static DEFINE_PER_CPU(cpu_is_wreckaged, bool);
+
+void sched_fair_this_cpu_wreckaged(bool wreckaged)
+{
+	this_cpu_write(sched_block_fair, wreckaged);
+}
+
+void sched_fair_cpu_wreckage_control(bool on)
+{
+	if (on)
+		static_key_slow_inc(&wreckage_key);
+	else
+		static_key_slow_dec(&wreckage_key);
+}
+
+static inline bool class_fair_disabled(void)
+{
+	if (static_key_false(&wreckage_key))
+		return false;
+	return this_cpu_read(sched_block_fair);
+}
+
+#else
+static inline bool class_fair_disabled(void) { return false; }
+#endif
+
 static struct task_struct *
 pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 {
@@ -4997,6 +5025,8 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 	struct task_struct *p;
 	int new_tasks;
 
+	if (class_fair_disabled())
+		goto idle;
 again:
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (!cfs_rq->nr_running)

The static key is enabled once the powerclamp mess starts. So nobody
else than powerclamp users are affected by this and rightfully so.

Not pretty, but better than a gazillion workarounds all over the place
to make "pretending I'm idle" actually work. This is basically the
same mechanism as we have with the RT throttler, where a RT hog will
be put onto hold for some time. We just put all sched other tasks on
hold while still allowing RT tasks and everything else to work.

Thoughts?

Thanks,

	tglx
