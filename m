Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbaAMQr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:47:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53165 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbaAMQCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 076/208] kexec: migrate to reboot cpu
Date: Mon, 13 Jan 2014 15:58:37 +0000
Message-Id: <1389628849-1614-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek Goyal <vgoyal@redhat.com>

commit c97102ba96324da330078ad8619ba4dfe840dbe3 upstream.

Commit 1b3a5d02ee07 ("reboot: move arch/x86 reboot= handling to generic
kernel") moved reboot= handling to generic code.  In the process it also
removed the code in native_machine_shutdown() which are moving reboot
process to reboot_cpu/cpu0.

I guess that thought must have been that all reboot paths are calling
migrate_to_reboot_cpu(), so we don't need this special handling.  But
kexec reboot path (kernel_kexec()) is not calling
migrate_to_reboot_cpu() so above change broke kexec.  Now reboot can
happen on non-boot cpu and when INIT is sent in second kerneo to bring
up BP, it brings down the machine.

So start calling migrate_to_reboot_cpu() in kexec reboot path to avoid
this problem.

Bisected by WANG Chao.

Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
Reported-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Tested-by: Baoquan He <bhe@redhat.com>
Tested-by: WANG Chao <chaowang@redhat.com>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/reboot.h | 1 +
 kernel/kexec.c         | 1 +
 kernel/reboot.c        | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index 8e00f9f..9e7db9e 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -43,6 +43,7 @@ extern int unregister_reboot_notifier(struct notifier_block *);
  * Architecture-specific implementations of sys_reboot commands.
  */
 
+extern void migrate_to_reboot_cpu(void);
 extern void machine_restart(char *cmd);
 extern void machine_halt(void);
 extern void machine_power_off(void);
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 1f8d938..57cc094 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1683,6 +1683,7 @@ int kernel_kexec(void)
 	{
 		kexec_in_progress = true;
 		kernel_restart_prepare(NULL);
+		migrate_to_reboot_cpu();
 		printk(KERN_EMERG "Starting new kernel\n");
 		machine_shutdown();
 	}
diff --git a/kernel/reboot.c b/kernel/reboot.c
index f813b34..662c83f 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -104,7 +104,7 @@ int unregister_reboot_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
-static void migrate_to_reboot_cpu(void)
+void migrate_to_reboot_cpu(void)
 {
 	/* The boot cpu is always logical cpu 0 */
 	int cpu = reboot_cpu;
-- 
1.8.3.2

