Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaLHNyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:54:21 -0500
Received: from smtprelay0070.hostedemail.com ([216.40.44.70]:44879 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752470AbaLHNyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:54:18 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2741:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3870:3871:3872:3874:4250:4321:4470:5007:6119:6261:6742:7875:7903:9010:9038:10004:10400:10471:10848:10967:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:12740:13255:13972:14096:14097:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boys54_7c854197b8b43
X-Filterd-Recvd-Size: 3460
Date: Mon, 8 Dec 2014 08:54:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Anton Blanchard <anton@samba.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        tj@kernel.org, fengguang.wu@intel.com, rafael.j.wysocki@intel.com,
        yuyang.du@intel.com, lkp@01.org, yuanhan.liu@linux.intel.com,
        pjt@google.com, bsegall@google.com, daniel@numascale.com,
        subbaram@codeaurora.org, computersforpeace@gmail.com, sp@datera.io,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] kthread: kthread_bind fails to enforce CPU affinity
 (fixes kernel BUG at kernel/smpboot.c:134!)
Message-ID: <20141208085405.730577a3@gandalf.local.home>
In-Reply-To: <1418009221-12719-1-git-send-email-anton@samba.org>
References: <1418009221-12719-1-git-send-email-anton@samba.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  8 Dec 2014 14:27:01 +1100
Anton Blanchard <anton@samba.org> wrote:

> I have a busy ppc64le KVM box where guests sometimes hit the infamous
> "kernel BUG at kernel/smpboot.c:134!" issue during boot:
> 
> BUG_ON(td->cpu != smp_processor_id());
> 
> Basically a per CPU hotplug thread scheduled on the wrong CPU. The oops
> output confirms it:
> 
> CPU: 0
> Comm: watchdog/130
> 
> The issue is in kthread_bind where we set the cpus_allowed mask, but do
> not touch task_thread_info(p)->cpu. The scheduler assumes the previously
> scheduled CPU is in the cpus_allowed mask, but in this case we are
> moving a thread to another CPU so it is not.
> 

Does this happen always on boot up, and always with the watchdog thread?

I followed the logic that starts the watchdog threads.

watchdog_enable_all_cpus()
  smpboot_register_percpu-thread() {

    for_each_online_cpu(cpu) { ... }

Where watchdog_enable_all_cpus() can be called by
lockup_detector_init() before SMP is started, but also by
proc_dowatchdog() which is called by the sysctl commands (after SMP is
up and running).

I noticed there's no "get_online_cpus()" anywhere, although the
unregister_percpu_thread() has it. Is it possible that we created a
thread on a CPU that wasn't fully online yet?

Perhaps the following patch is needed? Even if this isn't the solution
to this bug, it is probably needed as watchdog_enable_all_cpus() can be
called after boot up too.

-- Steve

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index eb89e1807408..60d35ac5d3f1 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -279,6 +279,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
 	unsigned int cpu;
 	int ret = 0;
 
+	get_online_cpus();
 	mutex_lock(&smpboot_threads_lock);
 	for_each_online_cpu(cpu) {
 		ret = __smpboot_create_thread(plug_thread, cpu);
@@ -291,6 +292,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
 	list_add(&plug_thread->list, &hotplug_threads);
 out:
 	mutex_unlock(&smpboot_threads_lock);
+	put_online_cpus();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
