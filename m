Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbaGOM40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:56:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32821 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932AbaGOM4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:56:23 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-12-53c524edb081
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 4/4] ima: require signed user-space initialization
Date: Tue, 15 Jul 2014 15:54:23 +0300
Message-id: <b4f46adc19bfe8b386dfc538efae20fc705018a6.1405428802.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1405428802.git.d.kasatkin@samsung.com>
References: <cover.1405428802.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1405428802.git.d.kasatkin@samsung.com>
References: <cover.1405428802.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t/xK7pvVY4GG2xtZrOYs34Nm8Wtv3uZ
	Ld41/Wax+LK0zuLljHnsFpd3zWGz+NDziM3i04pJzA4cHjtn3WX3ODHjN4vHg0ObWTx2L/jM
	5PF+31U2j74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4MrYtO4TY8EmqYr32zexNzBOFeti5OSQ
	EDCR+HFoGjuELSZx4d56ti5GLg4hgaWMEk9vPGOEcDqZJM7uX8kGUsUmoCexofkHO0hCRKCd
	UeLA9dNg7cwCNRIPexaxgNjCAq4SqzetZAaxWQRUJZYtnMXUxcjBwSsQJ7FksjzENjmJk8cm
	s4LYnAJWEpeXHmIHKRESsJS4diEAh/AERv4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3
	MULC88sOxsXHrA4xCnAwKvHwVogdDhZiTSwrrsw9xCjBwawkwluodDRYiDclsbIqtSg/vqg0
	J7X4ECMTB6dUA6NejmylzlrmU3cVN3YnnuuZ5l9u/sox9WtIUr+cpYZheZAqt7moq0aLYuGl
	3U6/LDkra/5MVVo6R83p8f6fD06wN3CUsTR2zq+3WlDTt8Tb17A7WO3H9agqk1i7b3MVwx5I
	Wnd+v9jRe64mgKVfS8OydLun77rMJ+qX9n//F5gqPplt1lNtJZbijERDLeai4kQAYPx8ai0C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides kernel parameter CONFIG_IMA_APPRAISE_SIGNED_INIT
to force initial user-space verification using signatures.
This is useful, when EVM key is not initalized yet and we want securely
initialize integrity or any other functionality. It implements
ima_preapre_keys() hook to load X509 certificate into the .ima trusted
kernel keyring from root filesystem. It forces embedded policy to
check signature. Signed initialization script can initialize EVM key,
update the IMA policy and change requirement of everything to be signed.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/Kconfig      | 15 +++++++++++++++
 security/integrity/ima/ima_init.c   | 17 +++++++++++++++++
 security/integrity/ima/ima_policy.c |  5 +++++
 3 files changed, 37 insertions(+)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 2477d1e..294ee2f 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -132,3 +132,18 @@ config IMA_TRUSTED_KEYRING
 	help
 	   This option requires that all keys added to the .ima
 	   keyring be signed by a key on the system trusted keyring.
+
+config IMA_APPRAISE_SIGNED_INIT
+	bool "Require signed user-space initialization"
+	depends on IMA_TRUSTED_KEYRING
+	select INTEGRITY_LOAD_X509
+	default n
+	help
+	   This option requires user-space init to be signed.
+
+config IMA_X509_PATH
+	string "IMA X509 certificate path"
+	depends on IMA_APPRAISE_SIGNED_INIT
+	default "/init/ima/x509_ima.der"
+	help
+	   This option defines IMA X509 certificate path.
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 8cf0f39..120b041 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -24,6 +24,12 @@
 #include <crypto/hash_info.h>
 #include "ima.h"
 
+#ifdef CONFIG_IMA_X509_PATH
+#define IMA_X509_PATH	CONFIG_IMA_X509_PATH
+#else
+#define IMA_X509_PATH	"/init/ima/x509_ima.der"
+#endif
+
 /* name for boot aggregate entry */
 static const char *boot_aggregate_name = "boot_aggregate";
 int ima_used_chip;
@@ -85,6 +91,17 @@ err_out:
 			    audit_cause, result, 0);
 }
 
+void __init ima_prepare_keys(void)
+{
+	if (ima_initialized) {
+		/* disable IMA to load the key */
+		/* hackish for now */
+		ima_initialized = 0;
+		integrity_load_x509(INTEGRITY_KEYRING_IMA, IMA_X509_PATH);
+		ima_initialized = 1;
+	}
+}
+
 int __init ima_init(void)
 {
 	u8 pcr_i[TPM_DIGEST_SIZE];
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index b9716d9..96e885f 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -97,7 +97,12 @@ static struct ima_rule_entry default_appraise_rules[] = {
 	{.action = DONT_APPRAISE, .fsmagic = SECURITYFS_MAGIC, .flags = IMA_FSMAGIC},
 	{.action = DONT_APPRAISE, .fsmagic = SELINUX_MAGIC, .flags = IMA_FSMAGIC},
 	{.action = DONT_APPRAISE, .fsmagic = CGROUP_SUPER_MAGIC, .flags = IMA_FSMAGIC},
+#ifndef CONFIG_IMA_APPRAISE_SIGNED_INIT
 	{.action = APPRAISE, .fowner = GLOBAL_ROOT_UID, .flags = IMA_FOWNER},
+#else
+	/* force signature */
+	{.action = APPRAISE, .fowner = GLOBAL_ROOT_UID, .flags = IMA_FOWNER | IMA_DIGSIG_REQUIRED},
+#endif
 };
 
 static LIST_HEAD(ima_default_rules);
-- 
1.9.1

