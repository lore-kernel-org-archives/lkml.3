Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3DVOfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:35:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51639 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039Ab3DVOaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Huacai Chen" <chenhc@lemote.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.652145028@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [29/75] PM / reboot: call syscore_shutdown() after
 disable_nonboot_cpus()
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sys.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -320,7 +320,6 @@ void kernel_restart_prepare(char *cmd)
 	system_state = SYSTEM_RESTART;
 	usermodehelper_disable();
 	device_shutdown();
-	syscore_shutdown();
 }
 
 /**
@@ -366,6 +365,7 @@ void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
 	disable_nonboot_cpus();
+	syscore_shutdown();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else
@@ -391,6 +391,7 @@ static void kernel_shutdown_prepare(enum
 void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
+	disable_nonboot_cpus();
 	syscore_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	kmsg_dump(KMSG_DUMP_HALT);

