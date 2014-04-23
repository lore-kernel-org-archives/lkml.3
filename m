Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbaDWNk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:40:28 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56757 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbaDWN36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:58 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-98-5357c0550412
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 17/20] ima: make IMA policy replaceable at runtime
Date: Wed, 23 Apr 2014 16:30:35 +0300
Message-id: <37308b997a49c67605cd1357a34c8cb6738ecd3e.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xq7qhB8KDDZY+4LG49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mo4secHW8F/mYp1PTPYGhgnSnQxcnJICJhInFqxnA3CFpO4
	cG89kM3FISSwlFFi3/LXjBBOJ5PE56bz7CBVbAJ6Ehuaf4DZIgIuErvn9DGBFDEL9DBK7P6z
	mBkkISzgJDF111smEJtFQFWip3k/I4jNKxAnMe3wVBaIdQoSy76sBavnFLCS+NM8HWyokICl
	xPdJk3GKT2DkX8DIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJBy/7GBcfMzqEKMAB6MS
	D6/E8rBgIdbEsuLK3EOMEhzMSiK8SxaFBwvxpiRWVqUW5ccXleakFh9iZOLglGpgrLrwMNzC
	tUElnK3q5JL5JceMgmzmzHzWvalowrLtk1Q/nMret6/z9f9vmjE6hh1iDc57D8WmKf3W3CzR
	stntwmxOW7kzzeJqPpf2NFfK3+o0a//D/kvsO4PxzFPJ87bMiObs9OB6v6Gz4pO86W1NY64b
	i6ZWT5577M91x7RPHyW/s4if2FbprsRSnJFoqMVcVJwIAN52lnolAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides functionality to replace the IMA policy at runtime.

By default, the IMA policy can be successfully updated only once,
but with this patch when the kernel configuration option
CONFIG_IMA_POLICY_REPLACEABLE is enabled, the IMA policy can be replaced
multiple times at runtime.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/Kconfig      |  8 ++++++++
 security/integrity/ima/ima_fs.c     |  2 ++
 security/integrity/ima/ima_policy.c | 23 +++++++++++++++++++----
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index b00044f..b60a315 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -160,3 +160,11 @@ config IMA_KERNEL_POLICY
 	default n
 	help
 	  This option enables IMA policy loading from the kernel.
+
+config IMA_POLICY_REPLACEABLE
+	bool "Allows to replace policy at runtime"
+	depends on IMA_POLICY_LOADER
+	default n
+	help
+	  Enabling this option allows to replace policy at runtime.
+	  Only signed policy is allowed.
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index d050a5c..b4144b4 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -304,11 +304,13 @@ static int ima_open_policy(struct inode *inode, struct file *filp)
 		return -EACCES;
 	if (test_and_set_bit(IMA_FS_BUSY, &ima_fs_flags))
 		return -EBUSY;
+#ifndef CONFIG_IMA_POLICY_REPLACEABLE
 	if (!ima_default_policy()) {
 		/* policy was already set*/
 		clear_bit(IMA_FS_BUSY, &ima_fs_flags);
 		return -EACCES;
 	}
+#endif
 	return 0;
 }
 
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index c6da801..981e953 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -108,11 +108,14 @@ static struct ima_rule_entry default_appraise_rules[] = {
 
 static LIST_HEAD(ima_default_rules);
 static LIST_HEAD(ima_policy_rules);
+static LIST_HEAD(ima_active_rules);
 static struct list_head *ima_rules;
 static bool path_rules;
 
 static DEFINE_MUTEX(ima_rules_mutex);
 
+static void ima_do_delete_rules(struct list_head *rules);
+
 static bool ima_use_tcb __initdata;
 static int __init default_measure_policy_setup(char *str)
 {
@@ -367,7 +370,14 @@ void ima_update_policy(void)
 	int result = 0;
 	int audit_info = 0;
 
-	ima_rules = &ima_policy_rules;
+	if (ima_default_policy()) {
+		/* set new policy head */
+		ima_rules = &ima_active_rules;
+	} else {
+		/* FIXME: must be protected by lock */
+		ima_do_delete_rules(ima_rules);
+	}
+	list_replace_init(&ima_policy_rules, ima_rules);
 
 	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
 			    NULL, op, cause, result, audit_info);
@@ -734,14 +744,14 @@ ssize_t ima_parse_add_rule(char *rule)
 	return len;
 }
 
-/* ima_delete_rules called to cleanup invalid policy */
-void ima_delete_rules(void)
+/* ima_delete_rules called to cleanup invalid or old policy */
+static void ima_do_delete_rules(struct list_head *rules)
 {
 	struct ima_rule_entry *entry, *tmp;
 	int i;
 
 	mutex_lock(&ima_rules_mutex);
-	list_for_each_entry_safe(entry, tmp, &ima_policy_rules, list) {
+	list_for_each_entry_safe(entry, tmp, rules, list) {
 		for (i = 0; i < MAX_LSM_RULES; i++)
 			kfree(entry->lsm[i].args_p);
 
@@ -751,6 +761,11 @@ void ima_delete_rules(void)
 	mutex_unlock(&ima_rules_mutex);
 }
 
+void ima_delete_rules(void)
+{
+	ima_do_delete_rules(&ima_policy_rules);
+}
+
 #ifdef CONFIG_IMA_POLICY_LOADER
 
 ssize_t ima_read_policy(char *path)
-- 
1.8.3.2

