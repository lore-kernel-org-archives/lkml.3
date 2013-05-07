Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab3EGEBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:01:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29703 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760389Ab3EGD66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:58 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=dY3PZAwpraEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=vZmle3W92FYA:10 a=nAebDoNsAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=lVSJx6lErsgA:10 a=p7eRH5PH6dwA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035848.487401178@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Huacai Chen <chenhc@lemote.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [045/126] PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0045-PM-reboot-call-syscore_shutdown-after-disable_nonboo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhc@lemote.com>

[ Upstream commit 6f389a8f1dd22a24f3d9afc2812b30d639e94625 ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sys.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 909148a..61c086b7 100644
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
1.7.10.4


