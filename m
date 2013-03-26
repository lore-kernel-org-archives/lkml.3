Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab3CZGl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:41:56 -0400
Received: from intranet.asianux.com ([58.214.24.6]:11531 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3CZGly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:41:54 -0400
X-Spam-Score: -100.8
Message-ID: <51514313.1070505@asianux.com>
Date: Tue, 26 Mar 2013 14:41:23 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: tglx@linutronix.de, Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>
Subject: Re: [Suggestion] kernel: 'now' may be used uninitialized in posix_cpu_timer_schedule
 function
References: <51514202.2030504@asianux.com>
In-Reply-To: <51514202.2030504@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 oh, sorry, it seems better to let ARM folks know about it.

 ;-)


On 2013年03月26日 14:36, Chen Gang wrote:
> Hello Maintainers:
> 
>   compiling with EXTRA_CFLAGS=-W:
>     make V=1 EXTRA_CFLAGS=-W ARCH=arm s3c2410_defconfig
>     make V=1 EXTRA_CFLAGS=-W ARCH=arm menuconfig
>       set 'arm-linux-gnu-' for cross chain prefix
>     make V=1 EXTRA_CFLAGS=-W ARCH=arm
> 
>   it will report:
>     kernel/posix-cpu-timers.c:1065:19: warning: ‘now’ may be used uninitialized in this function [-Wuninitialized]
> 
>   it seems it is really a bug.
>     can any member help to fix it ?
>     or provide additional suggestion ?
>       (it seems only "unsigned long long now = 0" is not enough).
> 
>   :-)
> 
> 
> 
> in kernel/posix-cpu-timers.c:
>   for variable 'now' is defined without initialization (line 1029)
>   it may be used without initialization (line 1066)
> 
> 
> 1026 void posix_cpu_timer_schedule(struct k_itimer *timer)
> 1027 {
> 1028         struct task_struct *p = timer->it.cpu.task;
> 1029         unsigned long long now;
> 1030 
> 1031         if (unlikely(p == NULL))
> 1032                 /*
> 1033                  * The task was cleaned up already, no future firings.
> 1034                  */
> 1035                 goto out;
> 1036 
> 1037         /*
> 1038          * Fetch the current sample and update the timer's expiry time.
> 1039          */
> 1040         if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
> 1041                 cpu_clock_sample(timer->it_clock, p, &now);
> 1042                 bump_cpu_timer(timer, now);
> 1043                 if (unlikely(p->exit_state)) {
> 1044                         clear_dead_task(timer, now);
> 1045                         goto out;
> 1046                 }
> 1047                 read_lock(&tasklist_lock); /* arm_timer needs it.  */
> 1048                 spin_lock(&p->sighand->siglock);
> 1049         } else {
> 1050                 read_lock(&tasklist_lock);
> 1051                 if (unlikely(p->sighand == NULL)) {
> 1052                         /*
> 1053                          * The process has been reaped.
> 1054                          * We can't even collect a sample any more.
> 1055                          */
> 1056                         put_task_struct(p);
> 1057                         timer->it.cpu.task = p = NULL;
> 1058                         timer->it.cpu.expires = 0;
> 1059                         goto out_unlock;
> 1060                 } else if (unlikely(p->exit_state) && thread_group_empty(p)) {
> 1061                         /*
> 1062                          * We've noticed that the thread is dead, but
> 1063                          * not yet reaped.  Take this opportunity to
> 1064                          * drop our task ref.
> 1065                          */
> 1066                         clear_dead_task(timer, now);
> 1067                         goto out_unlock;
> 1068                 }
> 1069                 spin_lock(&p->sighand->siglock);
> 1070                 cpu_timer_sample_group(timer->it_clock, p, &now);
> 1071                 bump_cpu_timer(timer, now);
> 1072                 /* Leave the tasklist_lock locked for the call below.  */
> 1073         }
> 1074 
> 1075         /*
> 1076          * Now re-arm for the new expiry time.
> 1077          */
> 1078         BUG_ON(!irqs_disabled());
> 1079         arm_timer(timer);
> 1080         spin_unlock(&p->sighand->siglock);
> 1081 
> 1082 out_unlock:
> 1083         read_unlock(&tasklist_lock);
> 1084 
> 1085 out:
> 1086         timer->it_overrun_last = timer->it_overrun;
> 1087         timer->it_overrun = -1;
> 1088         ++timer->it_requeue_pending;
> 1089 }
> 


-- 
Chen Gang

Asianux Corporation
