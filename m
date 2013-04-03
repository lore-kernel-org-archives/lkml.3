Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763175Ab3DCJ0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:26:08 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:43340 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761264Ab3DCJ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:26:05 -0400
From: Huacai Chen <chenhc@lemote.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhc@lemote.com>, <stable@vger.kernel.org>
Subject: [PATCH] reboot: call syscore_shutdown() after disable_nonboot_cpus()
Date: Wed,  3 Apr 2013 17:25:36 +0800
Message-Id: <1364981136-25629-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
avoid reboot failure.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Cc: <stable@vger.kernel.org>
---
 kernel/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index b0003db..f879033dd 100644
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
-- 
1.7.7.3

