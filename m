Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967897Ab3E3H7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:59:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S967643Ab3E3H7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:59:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,769,1363104000"; 
   d="scan'208";a="7411037"
From: liguang <lig.fnst@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Dave Jones <davej@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, liguang <lig.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] sys: remove kernel_shutdown_prepare's parameter
Date: Thu, 30 May 2013 15:58:04 +0800
Message-Id: <1369900686-5936-2-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 15:57:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 15:57:31,
	Serialize complete at 2013/05/30 15:57:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel_shutdown_prepare's parameter can be removed
by checking global 'system_state', so, maybe we
can save a register to be used :-).

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 kernel/sys.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 07c6177..7f56ed4 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -382,11 +382,10 @@ void kernel_restart(char *cmd)
 }
 EXPORT_SYMBOL_GPL(kernel_restart);
 
-static void kernel_shutdown_prepare(enum system_states state)
+static void kernel_shutdown_prepare(void)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list,
-		(state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
-	system_state = state;
+		(system_state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
 	usermodehelper_disable();
 	device_shutdown();
 }
@@ -397,7 +396,7 @@ static void kernel_shutdown_prepare(enum system_states state)
  */
 void kernel_halt(void)
 {
-	kernel_shutdown_prepare(SYSTEM_HALT);
+	kernel_shutdown_prepare();
 	disable_nonboot_cpus();
 	syscore_shutdown();
 	printk(KERN_EMERG "System halted.\n");
@@ -414,7 +413,7 @@ EXPORT_SYMBOL_GPL(kernel_halt);
  */
 void kernel_power_off(void)
 {
-	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
+	kernel_shutdown_prepare();
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
 	disable_nonboot_cpus();
@@ -484,11 +483,13 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 		break;
 
 	case LINUX_REBOOT_CMD_HALT:
+		system_state = SYSTEM_HALT;
 		kernel_halt();
 		do_exit(0);
 		panic("cannot halt");
 
 	case LINUX_REBOOT_CMD_POWER_OFF:
+		system_state = SYSTEM_POWER_OFF;
 		kernel_power_off();
 		do_exit(0);
 		break;
-- 
1.7.2.5

