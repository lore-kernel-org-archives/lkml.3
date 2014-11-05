Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaKEPEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:04:13 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43135 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbaKEPCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:02:46 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-c8-545a3c1549b4
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v4 3/6] ima: load x509 certificate from the kernel
Date: Wed, 05 Nov 2014 17:01:14 +0200
Message-id: <874ac8915c305145c816085c3e18dbfae91298cf.1415197743.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1415197743.git.d.kasatkin@samsung.com>
References: <cover.1415197743.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1415197743.git.d.kasatkin@samsung.com>
References: <cover.1415197743.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t/xK7qiNlEhBs8nilnMWb+GzeLW373M
	Fl+W1lm8nDGP3eLyrjlsFh96HrFZnP97nNXi04pJzA4cHjtn3WX3ODHjN4vHg0ObWTx2L/jM
	5NG3ZRWjx+dNch6bnrxlCmCP4rJJSc3JLEst0rdL4Mq4s28RW8FumYoLL/+xNTC+FO9i5OSQ
	EDCR2LbhCzuELSZx4d56ti5GLg4hgaWMEs2ft7BAOJ1MEp9OT2YDqWIT0JPY0PyDHSQhIrCI
	UWLT14ssIAlmgXSJT5N6wUYJCzhJdK9tZQKxWQRUJXbMA1nBwcErECdx+bwUxDY5iZPHJrOC
	2JwCVhITnlwEmy8kYCmx8FETIy7xCYz8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKE
	hOiXHYyLj1kdYhTgYFTi4fVoigwRYk0sK67MPcQowcGsJMJ7zTIqRIg3JbGyKrUoP76oNCe1
	+BAjEwenVAOj7QP7Wx/Xf3lw7z2vzmouW+OZ/RO3vL35/1jksu1rGzPPmAjut3wu8dgzhWOG
	bdv6b4FlNzZ6OWl3vVry8GyhXdL2ZZ0Zh/PtlwoI/FSycnzx99l51vlTfz2o5bl7ItzoYvk6
	1qNZrKG3v/zKDa5w7Hi8SfAdR+nNKau3rIiIu7yVjUHUy8MnVImlOCPRUIu5qDgRAGqD6Bsv	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define configuration option to load X509 certificate into the
IMA trusted kernel keyring. It implements ima_load_x509() hook
to load X509 certificate into the .ima trusted kernel keyring
from the root filesystem.

Changes in v3:
* use ima_policy_flag in ima_get_action()
  ima_load_x509 temporarily clears ima_policy_flag to disable
  appraisal to load key. Use it to skip appraisal rules.
* Key directory path changed to /etc/keys (Mimi)

Changes in v2:
* added '__init'
* use ima_policy_flag to disable appraisal to load keys

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/Kconfig    | 15 +++++++++++++++
 security/integrity/ima/ima_api.c  |  3 +--
 security/integrity/ima/ima_init.c | 17 +++++++++++++++++
 security/integrity/integrity.h    |  8 ++++++++
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index e099875..8288edc 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -131,3 +131,18 @@ config IMA_TRUSTED_KEYRING
 	help
 	   This option requires that all keys added to the .ima
 	   keyring be signed by a key on the system trusted keyring.
+
+config IMA_LOAD_X509
+	bool "Load X509 certificate to the '.ima' trusted keyring"
+	depends on IMA_TRUSTED_KEYRING
+	default n
+	help
+	   This option enables X509 certificate loading from the kernel
+	   to the '.ima' trusted keyring.
+
+config IMA_X509_PATH
+	string "IMA X509 certificate path"
+	depends on IMA_LOAD_X509
+	default "/etc/keys/x509_ima.der"
+	help
+	   This option defines IMA X509 certificate path.
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index a99eb6d..b0dc922 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -173,8 +173,7 @@ int ima_get_action(struct inode *inode, int mask, int function)
 {
 	int flags = IMA_MEASURE | IMA_AUDIT | IMA_APPRAISE;
 
-	if (!ima_appraise)
-		flags &= ~IMA_APPRAISE;
+	flags &= ima_policy_flag;
 
 	return ima_match_policy(inode, function, mask, flags);
 }
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 9164fc8..5e4c29d 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -24,6 +24,12 @@
 #include <crypto/hash_info.h>
 #include "ima.h"
 
+#ifdef CONFIG_IMA_X509_PATH
+#define IMA_X509_PATH	CONFIG_IMA_X509_PATH
+#else
+#define IMA_X509_PATH	"/etc/keys/x509_ima.der"
+#endif
+
 /* name for boot aggregate entry */
 static const char *boot_aggregate_name = "boot_aggregate";
 int ima_used_chip;
@@ -91,6 +97,17 @@ err_out:
 	return result;
 }
 
+#ifdef CONFIG_IMA_LOAD_X509
+void __init ima_load_x509(void)
+{
+	int unset_flags = ima_policy_flag & IMA_APPRAISE;
+
+	ima_policy_flag &= ~unset_flags;
+	integrity_load_x509(INTEGRITY_KEYRING_IMA, IMA_X509_PATH);
+	ima_policy_flag |= unset_flags;
+}
+#endif
+
 int __init ima_init(void)
 {
 	u8 pcr_i[TPM_DIGEST_SIZE];
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 1057abb..caa1f6c 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -162,6 +162,14 @@ static inline int asymmetric_verify(struct key *keyring, const char *sig,
 }
 #endif
 
+#ifdef CONFIG_IMA_LOAD_X509
+void __init ima_load_x509(void);
+#else
+static inline void ima_load_x509(void)
+{
+}
+#endif
+
 #ifdef CONFIG_INTEGRITY_AUDIT
 /* declarations */
 void integrity_audit_msg(int audit_msgno, struct inode *inode,
-- 
1.9.1

