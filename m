Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3FHLam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 07:30:42 -0400
Received: from smtpbg64.qq.com ([103.7.28.238]:33862 "HELO smtpbg64.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752353Ab3FHLal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 07:30:41 -0400
X-QQ-mid: bizesmtp2t1370691038t240t200
X-QQ-SSF: 01200000000000F0FLF2000A0000000
Message-ID: <51B315CD.9010908@kylinos.com.cn>
Date: Sat, 08 Jun 2013 19:30:21 +0800
From: "weiqi@kylinos.com.cn" <weiqi@kylinos.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "weiqi@kylinos.com.cn" <weiqi@kylinos.com.cn>,
        torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: race condition in schedule_on_each_cpu()
References: <tencent_0777D84B54B4163A3B85255A@qq.com> <20130606212303.GH5045@htj.dyndns.org> <51B138AA.4070707@kylinos.com.cn> <51B14472.60904@kylinos.com.cn> <20130607232219.GK14781@mtj.dyndns.org> <51B27744.6090507@kylinos.com.cn>
In-Reply-To: <51B27744.6090507@kylinos.com.cn>
Content-Type: multipart/mixed;
 boundary="------------030909090009080905060902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030909090009080905060902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello Tejun Heo,

I've backported the  schedule_on_each_cpu()  "direct excution" patch on 
3.0.30-rt50,
and  It  fixed my problem.

attachment is the effective patch.

However, I do not understand why  machine1 can expose problem,  but 
machine2 not.

I guess, because it's  rt-kernel's  preempt level related, so , is this 
difference due to cpu performance?

How do you think about this ?

Thank you~

--------------030909090009080905060902
Content-Type: text/plain; charset=UTF-8;
 name="direct_execution.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="direct_execution.patch"

diff -up linux-3.0.30-rt50/kernel/workqueue.c.bak linux-3.0.30-rt50/kernel/workqueue.c
--- linux-3.0.30-rt50/kernel/workqueue.c.bak	2013-06-08 19:09:06.801059232 +0800
+++ linux-3.0.30-rt50/kernel/workqueue.c	2013-06-08 19:09:15.680069626 +0800
@@ -1922,6 +1922,7 @@ static int worker_thread(void *__worker)
 
 	/* tell the scheduler that this is a workqueue worker */
 	worker->task->flags |= PF_WQ_WORKER;
+	smp_mb();
 woke_up:
 	spin_lock_irq(&gcwq->lock);
 
@@ -2736,6 +2737,7 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
 int schedule_on_each_cpu(work_func_t func)
 {
 	int cpu;
+	int orig = -1;
 	struct work_struct __percpu *works;
 
 	works = alloc_percpu(struct work_struct);
@@ -2744,13 +2746,20 @@ int schedule_on_each_cpu(work_func_t fun
 
 	get_online_cpus();
 
+	if(current->flags & PF_WQ_WORKER)
+		orig = raw_smp_processor_id();
+
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = per_cpu_ptr(works, cpu);
 
 		INIT_WORK(work, func);
-		schedule_work_on(cpu, work);
+		if(cpu != orig)
+			schedule_work_on(cpu, work);
 	}
 
+	if (orig >= 0)
+		func(per_cpu_ptr(works,orig));
+
 	for_each_online_cpu(cpu)
 		flush_work(per_cpu_ptr(works, cpu));
 

--------------030909090009080905060902--
