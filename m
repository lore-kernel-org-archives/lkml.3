Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3DRJ00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:26:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40246 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521Ab3DRJSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Huacai Chen <chenhc@lemote.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 49/72] PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()
Date: Thu, 18 Apr 2013 10:16:34 +0100
Message-Id: <1366276617-3553-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhc@lemote.com>

commit 6f389a8f1dd22a24f3d9afc2812b30d639e94625 upstream.

As commit 40dc166c (PM / Core: Introduce struct syscore_ops for core
subsystems PM) say, syscore_ops operations should be carried with one
CPU on-line and interrupts disabled. However, after commit f96972f2d
(kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()),
syscore_shutdown() is called before disable_nonboot_cpus(), so break
the rules. We have a MIPS machine with a 8259A PIC, and there is an
external timer (HPET) linked at 8259A. Since 8259A has been shutdown
too early (by syscore_shutdown()), disable_nonboot_cpus() runs without
timer interrupt, so it hangs and reboot fails. This patch call
syscore_shutdown() a little later (after disable_nonboot_cpus()) to
avoid reboot failure, this is the same way as poweroff does.

For consistency, add disable_nonboot_cpus() to kernel_halt().

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sys.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index b6fe559..0836a7f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -323,7 +323,6 @@ void kernel_restart_prepare(char *cmd)
 	system_state = SYSTEM_RESTART;
 	usermodehelper_disable();
 	device_shutdown();
-	syscore_shutdown();
 }
 
 /**
@@ -369,6 +368,7 @@ void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
 	disable_nonboot_cpus();
+	syscore_shutdown();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else
@@ -394,6 +394,7 @@ static void kernel_shutdown_prepare(enum system_states state)
 void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
+	disable_nonboot_cpus();
 	syscore_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	kmsg_dump(KMSG_DUMP_HALT);
-- 
1.8.1.2

