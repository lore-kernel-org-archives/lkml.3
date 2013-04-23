Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab3DWQEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:04:50 -0400
Received: from nm26-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.225]:24574
	"EHLO nm26-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153Ab3DWQEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:04:47 -0400
X-Yahoo-Newman-Id: 224272.45327.bm@smtp105.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7nrDFmMVM1kQBTwKk5LPROC2o2KcVuAVxiC_UihqA6BYsSL
 utRCX4SJKevTZ9wUknEmITV7XxIohCLKo8.WwQ5Vv16jU1xpAmCoWafzeYW3
 gkg0U1.wi.TXpSu5v134Da8sTa1lLN4o2QgNqj_ni0fJ_3iTFon1HWs6l6gf
 ZR61xzKeiWN9j9MPOQ85Hld1ke8dIa9yyB6EH21o0rnndQaWVVjbP6wBMfud
 OcObJIk0eJ9mV5xX3n5Sd._7lPWAKZqy39B8i6FQxbngibsmZ2jpnjPPklHR
 MXHSkfPshJUnYPPfPkI7Rp5LC0WUuiVnEDDLqbXQL9d0vyGSdCbmSOF5styj
 ZkdfMaZ76KninnBR0WPPpUknEmP9Vk0kGmxsFYkmFsY2Yu55doNqsxIQUa.w
 zH5KPpXbtmhGVHKPk6er0B6N6jX.TcmA0au5XQkr3LEjWHsdtTpg8CEAqudg
 fhQ--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp105.biz.mail.ne1.yahoo.com with SMTP; 23 Apr 2013 09:04:45 -0700 PDT
Message-ID: <5176B11E.6010908@schaufler-ca.com>
Date: Tue, 23 Apr 2013 09:04:46 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>
CC: John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH v13 7/9] LSM: remove Yama special case stacking
References: <5176ABB7.5080300@schaufler-ca.com>
In-Reply-To: <5176ABB7.5080300@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v13 7/9] LSM: remove Yama special case stacking

Remove the special case stacking for Yama.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 security/security.c      |   21 ---------------------
 security/yama/Kconfig    |    8 --------
 security/yama/yama_lsm.c |   19 -------------------
 3 files changed, 48 deletions(-)

diff --git a/security/security.c b/security/security.c
index d0b768c..67e435b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -138,23 +138,11 @@ int __init register_security(struct security_operations *ops)
 
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
-#ifdef CONFIG_SECURITY_YAMA_STACKED
-	int rc;
-	rc = yama_ptrace_access_check(child, mode);
-	if (rc)
-		return rc;
-#endif
 	return security_ops->ptrace_access_check(child, mode);
 }
 
 int security_ptrace_traceme(struct task_struct *parent)
 {
-#ifdef CONFIG_SECURITY_YAMA_STACKED
-	int rc;
-	rc = yama_ptrace_traceme(parent);
-	if (rc)
-		return rc;
-#endif
 	return security_ops->ptrace_traceme(parent);
 }
 
@@ -783,9 +771,6 @@ int security_task_create(unsigned long clone_flags)
 
 void security_task_free(struct task_struct *task)
 {
-#ifdef CONFIG_SECURITY_YAMA_STACKED
-	yama_task_free(task);
-#endif
 	security_ops->task_free(task);
 }
 
@@ -911,12 +896,6 @@ int security_task_wait(struct task_struct *p)
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			 unsigned long arg4, unsigned long arg5)
 {
-#ifdef CONFIG_SECURITY_YAMA_STACKED
-	int rc;
-	rc = yama_task_prctl(option, arg2, arg3, arg4, arg5);
-	if (rc != -ENOSYS)
-		return rc;
-#endif
 	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5);
 }
 
diff --git a/security/yama/Kconfig b/security/yama/Kconfig
index 20ef514..51d6709 100644
--- a/security/yama/Kconfig
+++ b/security/yama/Kconfig
@@ -11,11 +11,3 @@ config SECURITY_YAMA
 	  Further information can be found in Documentation/security/Yama.txt.
 
 	  If you are unsure how to answer this question, answer N.
-
-config SECURITY_YAMA_STACKED
-	bool "Yama stacked with other LSMs"
-	depends on SECURITY_YAMA
-	default n
-	help
-	  When Yama is built into the kernel, force it to stack with the
-	  selected primary LSM.
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 13c88fbc..63ad9bb 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -364,16 +364,6 @@ int yama_ptrace_traceme(struct task_struct *parent)
 	return rc;
 }
 
-#ifndef CONFIG_SECURITY_YAMA_STACKED
-static struct security_operations yama_ops = {
-	.name =			"yama",
-
-	.ptrace_access_check =	yama_ptrace_access_check,
-	.ptrace_traceme =	yama_ptrace_traceme,
-	.task_prctl =		yama_task_prctl,
-	.task_free =		yama_task_free,
-};
-#endif
 
 #ifdef CONFIG_SYSCTL
 static int yama_dointvec_minmax(struct ctl_table *table, int write,
@@ -420,18 +410,9 @@ static struct ctl_table yama_sysctl_table[] = {
 
 static __init int yama_init(void)
 {
-#ifndef CONFIG_SECURITY_YAMA_STACKED
-	if (!security_module_enable(&yama_ops))
-		return 0;
-#endif
 
 	printk(KERN_INFO "Yama: becoming mindful.\n");
 
-#ifndef CONFIG_SECURITY_YAMA_STACKED
-	if (register_security(&yama_ops))
-		panic("Yama: kernel registration failed.\n");
-#endif
-
 #ifdef CONFIG_SYSCTL
 	if (!register_sysctl_paths(yama_sysctl_path, yama_sysctl_table))
 		panic("Yama: sysctl registration failed.\n");

