Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbbAWKh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:37:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36158 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbbAWKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:37:23 -0500
Date: Fri, 23 Jan 2015 02:36:29 -0800
From: tip-bot for Lai Jiangshan <tipbot@zytor.com>
Message-ID: <tip-4bee96860a65c3a62d332edac331b3cf936ba3ad@git.kernel.org>
Cc: srivatsa.bhat@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        laijs@cn.fujitsu.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        rientjes@google.com
Reply-To: laijs@cn.fujitsu.com, rusty@rustcorp.com.au, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com, mingo@kernel.org,
        peterz@infradead.org, rientjes@google.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <1406777421-12830-1-git-send-email-laijs@cn.fujitsu.com>
References: <1406777421-12830-1-git-send-email-laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] smpboot: Add missing get_online_cpus()
  in smpboot_register_percpu_thread()
Git-Commit-ID: 4bee96860a65c3a62d332edac331b3cf936ba3ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bee96860a65c3a62d332edac331b3cf936ba3ad
Gitweb:     http://git.kernel.org/tip/4bee96860a65c3a62d332edac331b3cf936ba3ad
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Thu, 31 Jul 2014 11:30:17 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 23 Jan 2015 11:33:51 +0100

smpboot: Add missing get_online_cpus() in smpboot_register_percpu_thread()

The following race exists in the smpboot percpu threads management:

CPU0	      	   	     CPU1
cpu_up(2)
  get_online_cpus();
  smpboot_create_threads(2);
			     smpboot_register_percpu_thread();
			     for_each_online_cpu();
			       __smpboot_create_thread();
  __cpu_up(2);

This results in a missing per cpu thread for the newly onlined cpu2 and
in a NULL pointer dereference on a consecutive offline of that cpu.

Proctect smpboot_register_percpu_thread() with get_online_cpus() to
prevent that.

[ tglx: Massaged changelog and removed the change in
        smpboot_unregister_percpu_thread() because that's an
        optimization and therefor not stable material. ]

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1406777421-12830-1-git-send-email-laijs@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/smpboot.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index f032fb5..40190f2 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -280,6 +280,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
 	unsigned int cpu;
 	int ret = 0;
 
+	get_online_cpus();
 	mutex_lock(&smpboot_threads_lock);
 	for_each_online_cpu(cpu) {
 		ret = __smpboot_create_thread(plug_thread, cpu);
@@ -292,6 +293,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
 	list_add(&plug_thread->list, &hotplug_threads);
 out:
 	mutex_unlock(&smpboot_threads_lock);
+	put_online_cpus();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
