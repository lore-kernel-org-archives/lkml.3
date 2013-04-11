Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab3DKKWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 06:22:25 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:58306 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761840Ab3DKKWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:22:23 -0400
Message-ID: <51668E3D.1030305@linux.vnet.ibm.com>
Date: Thu, 11 Apr 2013 15:49:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Dave Hansen <dave@sr71.net>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] CPU hotplug, smpboot: Fix crash in smpboot_thread_fn()
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos> <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net> <5165713D.7030503@linux.vnet.ibm.com> <alpine.LFD.2.02.1304111007270.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304111007270.21884@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041110-8878-0000-0000-000006A9767C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 01:40 PM, Thomas Gleixner wrote:
> On Wed, 10 Apr 2013, Srivatsa S. Bhat wrote:
> 
>> Interestingly, in every single stack trace, the crashing task is the migration
>> thread. Now, migration thread belongs to the highest priority stop_task sched
>> class, and this particular sched class is very unique in the way it implements
>> its internal sched class functions, and I suspect this has a lot of bearing
>> on how functions like kthread_bind(), wake_up_process() etc react with it
>> (by looking at how it implements its functions such as select_task_rq(),
>> enqueue_task(), dequeue_task() etc).
> 
> I don't think that's relevant. The migration thread can only be woken
> via try_to_wakeup and my previous patch which implements a separate
> task state makes sure that it cannot be woken accidentaly by anything
> else than unpark.
> 

Hmm, but it got to be simpler than that, no? Given that it used to work fine
before...

>> But note that __kthread_bind() can wake up the task if the task is an RT
>> task. So it can be called only when the CPU (to which we want to bind the task)
> 
> kthread_bind() does NOT wakeup anything. It merily sets the cpus
> allowed ptr without further ado.
> 

Sorry, I was mistaken and was carried away by a bug in the code I was testing.
I had intended to move kthread_bind() to the body of kthread_create_on_cpu()
and place it after the call to kthread_park(), as shown below:

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 691dc2e..b485fc0 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -308,6 +308,9 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 	to_kthread(p)->cpu = cpu;
 	/* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
 	kthread_park(p);
+
+	wait_task_inactive(p, TASK_INTERRUPTIBLE);
+	__kthread_bind(p, cpu);
 	return p;
 }
 
But by mistake, I had written the code as:

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 691dc2e..b485fc0 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -308,6 +308,9 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 	to_kthread(p)->cpu = cpu;
 	/* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
 	kthread_park(p);
+
+	if (!wait_task_inactive(p, TASK_INTERRUPTIBLE))
+		__kthread_bind(p, cpu);
 	return p;
 }
 
So, no wonder it never actually bound the task to the CPU. So when I gave this a run,
I saw watchdog threads hitting the same BUG_ON(), and since watchdog threads are
of RT priority, and RT is the only class that implements ->set_cpus_allowed(), I
thought that those threads got woken up due to the bind. But I was mistaken of
course, because I had checked for the wrong return value of wait_task_inactive().

Regards,
Srivatsa S. Bhat

