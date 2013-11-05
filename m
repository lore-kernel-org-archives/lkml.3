Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab3KEJRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:17:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3KEJRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:17:42 -0500
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        akpm@linux-foundation.org, holt@sgi.com, davej@fedoraproject.org,
        rmk+kernel@arm.linux.org.uk, vgoyal@redhat.com, chaowang@redhat.com,
        mwhitehe@redhat.com, kexec@lists.infradead.org,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH] x86: make reboot task only run on the appropriate processor
Date: Tue,  5 Nov 2013 17:16:07 +0800
Message-Id: <1383642967-12595-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently system always reboot after below message when execute "kexec -e".

[    0.572119] smpboot: Booting Node   0, Processors  #   1 OK

In commit 1b3a5d02ee070c8f9943333b9b6370f486601e0f, reboot= handling was
moved to kerne/reboot.c. However, the code to migrate current thread to
reboot cpu was removed. That cause this incorrect kexec behavior.

Now add that code block back.

Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
Reported-by: Dave Young <dyoung@redhat.com>
Tested-by: WANG Chao <chaowang@redhat.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/kernel/reboot.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 7e920bf..3049de9 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -551,6 +551,21 @@ void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
+       /* The boot cpu is always logical cpu 0 */
+       int reboot_cpu_id = 0;
+
+       /* See if there has been given a command line override */
+       if ((reboot_cpu != -1) && (reboot_cpu < nr_cpu_ids) &&
+               cpu_online(reboot_cpu))
+               reboot_cpu_id = reboot_cpu;
+
+       /* Make certain the cpu I'm about to reboot on is online */
+       if (!cpu_online(reboot_cpu_id))
+               reboot_cpu_id = smp_processor_id();
+
+       /* Make certain I only run on the appropriate processor */
+       set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
+
 	/*
 	 * Stop all of the others. Also disable the local irq to
 	 * not receive the per-cpu timer interrupt which may trigger
-- 
1.8.3.1

