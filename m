Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbaAFWir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:38:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbaAFWin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Whitehead <mwhitehe@redhat.com>,
        Dave Young <dyoung@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Baoquan He <bhe@redhat.com>, WANG Chao <chaowang@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 012/144] kexec: migrate to reboot cpu
Date: Mon,  6 Jan 2014 14:36:13 -0800
Message-Id: <20140106223745.680293459@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/reboot.h |    1 +
 kernel/kexec.c         |    1 +
 kernel/reboot.c        |    2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -43,6 +43,7 @@ extern int unregister_reboot_notifier(st
  * Architecture-specific implementations of sys_reboot commands.
  */
 
+extern void migrate_to_reboot_cpu(void);
 extern void machine_restart(char *cmd);
 extern void machine_halt(void);
 extern void machine_power_off(void);
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1680,6 +1680,7 @@ int kernel_kexec(void)
 	{
 		kexec_in_progress = true;
 		kernel_restart_prepare(NULL);
+		migrate_to_reboot_cpu();
 		printk(KERN_EMERG "Starting new kernel\n");
 		machine_shutdown();
 	}
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -104,7 +104,7 @@ int unregister_reboot_notifier(struct no
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
-static void migrate_to_reboot_cpu(void)
+void migrate_to_reboot_cpu(void)
 {
 	/* The boot cpu is always logical cpu 0 */
 	int cpu = reboot_cpu;


