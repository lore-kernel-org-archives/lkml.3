Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaJJOKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:10:07 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41953 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaJJOJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:09:58 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-44-5437e8b4faa6
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v3 3/6] ima: load x509 certificate from the kernel
Date: Fri, 10 Oct 2014 17:09:30 +0300
Message-id: <23f7ccd5eb085aa1cdd6c21e10c2d1665ae92feb.1412950047.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xy7pbXpiHGEy7x2IxZ/0aNotbf/cy
	W3xZWmfxcsY8dovLu+awWXzoecRmcf7vcVaLTysmMTtweOycdZfd48SM3yweDw5tZvHYveAz
	k0ffllWMHp83yXlsevKWKYA9issmJTUnsyy1SN8ugSvj8cFtzAVrxCqenljF3sB4S6iLkZND
	QsBEYtOuUywQtpjEhXvr2boYuTiEBJYySjy6+ogZwulkkth0rpcRpIpNQE9iQ/MPdpCEiMAi
	RonHyy6ygiSYBdIlPk3qZQexhQWcJCZ3fmYCsVkEVCVezvoP1swrECcxtWEVE8Q6OYmTxyaD
	9XIKWEl8e/ULLC4kYCnx/X0LCy7xCYz8CxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKE
	BOnXHYxLj1kdYhTgYFTi4b0gYx4ixJpYVlyZe4hRgoNZSYT323OgEG9KYmVValF+fFFpTmrx
	IUYmDk6pBsYNsec/tRg8nrcgw4z1qd8lV9f5D8uSN61k1uQ1uPPSaPLWx7e+lHlbq735/LlI
	rmZWZnviw7fKa58vKH+53uOOaEJdh/8pjeRFgk5vHsc8lj6RvVur/MCiQ4nim3cqKzP5P+zf
	sGCTCWvOYYOrM80bq1x2105lvjD9SVQSU3v3o10bxQNKNM2UWIozEg21mIuKEwFqOTprMAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define configuration option to load X509 certificate into the
IMA trusted kernel keyring. It implements ima_load_x509() hook
to load X509 certificate into the .ima trusted kernel keyring
from root filesystem.

Changes in v2:
* added '__init'
* use ima_policy_flag to disable appraisal to load keys

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/Kconfig    | 15 +++++++++++++++
 security/integrity/ima/ima_init.c | 17 +++++++++++++++++
 security/integrity/integrity.h    |  8 ++++++++
 3 files changed, 40 insertions(+)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index e099875..44941c1 100644
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
+	default "/etc/ima/x509_ima.der"
+	help
+	   This option defines IMA X509 certificate path.
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 9164fc8..0b6c305 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -24,6 +24,12 @@
 #include <crypto/hash_info.h>
 #include "ima.h"
 
+#ifdef CONFIG_IMA_X509_PATH
+#define IMA_X509_PATH	CONFIG_IMA_X509_PATH
+#else
+#define IMA_X509_PATH	"/etc/ima/x509_ima.der"
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

