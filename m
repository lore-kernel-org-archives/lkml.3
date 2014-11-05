Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbaKEPDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:03:51 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25535 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbaKEPCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:02:49 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-10-545a3c174503
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v4 5/6] ima: require signature based appraisal
Date: Wed, 05 Nov 2014 17:01:16 +0200
Message-id: <01b40710b8c8dd7ce941d7513a24b6f3eb4f6b8e.1415197743.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1415197743.git.d.kasatkin@samsung.com>
References: <cover.1415197743.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1415197743.git.d.kasatkin@samsung.com>
References: <cover.1415197743.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t/xK7riNlEhBg/uSVjMWb+GzeLW373M
	Fl+W1lm8nDGP3eLyrjlsFh96HrFZnP97nNXi04pJzA4cHjtn3WX3ODHjN4vHg0ObWTx2L/jM
	5NG3ZRWjx+dNch6bnrxlCmCP4rJJSc3JLEst0rdL4Mr4dMOh4I9AxevXHg2MK/m6GDk5JARM
	JPa9PcIGYYtJXLi3HswWEljKKNGwoaSLkQvI7mSSmLBlNjNIgk1AT2JD8w92kISIwCJGiU1f
	L7KAJJgF0iU+TeplB7GFBewkbly7BdbAIqAqMe/pfFYQm1cgTuLV/QtMENvkJE4emwwW5xSw
	kpjw5CLUZkuJhY+aGHGJT2DkX8DIsIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJDy/7mBc
	eszqEKMAB6MSD69HU2SIEGtiWXFl7iFGCQ5mJRHea5ZRIUK8KYmVValF+fFFpTmpxYcYmTg4
	pRoYZz5mrVHx0O4RXXd15Uq3ZaX2nBcnFXPU1wnxGiXcurhxziaHWZuPXfJ8b+o568O5D4Vq
	H19ETtKbLrfJ5dGR1cqKu648+//2+p9pMi+bXVv3799WLW6Zlt7Y6+n9jPOJhoXVhiiL1xne
	CW9UwtwPbTe5zce5a/b5jKf/NRZOCDQLmJ+gp1grocRSnJFoqMVcVJwIAImRk1UtAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides CONFIG_IMA_APPRAISE_SIGNED_INIT kernel configuration
option to force IMA appraisal using signatures. This is useful, when EVM
key is not initialized yet and we want securely initialize integrity or
any other functionality.

It forces embedded policy to require signature. Signed initialization
script can initialize EVM key, update the IMA policy and change further
requirement of everything to be signed.

Changes in v3:
* kernel parameter fixed to configuration option in the patch description

Changes in v2:
* policy change of this patch separated from the key loading patch

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/Kconfig      | 7 +++++++
 security/integrity/ima/ima_policy.c | 5 +++++
 2 files changed, 12 insertions(+)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 8288edc..31b44b8 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -146,3 +146,10 @@ config IMA_X509_PATH
 	default "/etc/keys/x509_ima.der"
 	help
 	   This option defines IMA X509 certificate path.
+
+config IMA_APPRAISE_SIGNED_INIT
+	bool "Require signed user-space initialization"
+	depends on IMA_LOAD_X509
+	default n
+	help
+	   This option requires user-space init to be signed.
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 0d14d25..222ff79 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -100,7 +100,12 @@ static struct ima_rule_entry default_appraise_rules[] = {
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

