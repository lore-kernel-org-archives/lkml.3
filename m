Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaJJOLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:11:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59794 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaJJOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:10:00 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-49-5437e8b5983b
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v3 5/6] ima: require signature based appraisal
Date: Fri, 10 Oct 2014 17:09:32 +0300
Message-id: <4dd050e33e489d3b563075a9ea4e3d15675f6550.1412950047.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xy7pbX5iHGPQcMrKYs34Nm8Wtv3uZ
	Lb4srbN4OWMeu8XlXXPYLD70PGKzOP/3OKvFpxWTmB04PHbOusvucWLGbxaPB4c2s3jsXvCZ
	yaNvyypGj8+b5Dw2PXnLFMAexWWTkpqTWZZapG+XwJXRe+M6S8EkgYov398zNTBe4u1i5OSQ
	EDCR2P3yFTuELSZx4d56ti5GLg4hgaWMEtuvvGGGcDqZJL482ARWxSagJ7Gh+Qc7SEJEYBGj
	xONlF1lBEswC6RKfJvWCFQkL2El8PfOCEcRmEVCVOH7pBRuIzSsQJ/Gr/zYTxDo5iZPHJoP1
	cgpYSXx79QssLiRgKfH9fQsLLvEJjPwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoQE
	6dcdjEuPWR1iFOBgVOLhvSBjHiLEmlhWXJl7iFGCg1lJhPfbc6AQb0piZVVqUX58UWlOavEh
	RiYOTqkGRtd5MvcvPOAz1DrCwnenvUh2qU731ZjHir6TvfwsHq48/cZdqsMge/GduD/Oi1Yl
	T2kN91WfmH+7mv9qXa3bDdnHbqaLbuy8KrR9evhNtRCTgxPi1j8zYFssbmyf0p/A//9TB/vi
	d7Jea29oLl/WtdzhiMP+nSu+6P08ufm21iTxuAnrvS7Mu6LEUpyRaKjFXFScCADaEe4TMAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides kernel parameter CONFIG_IMA_APPRAISE_SIGNED_INIT
to force IMA appraisal using signatures. This is useful, when EVM key
is not initalized yet and we want securely initialize integrity or any
other functionality.

It forces embedded policy to require signature. Signed initialization
script can initialize EVM key, update the IMA policy and change further
requirement of everything to be signed.

Changes in v2:
* policy change of this patch separated from the key loading patch

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/Kconfig      | 7 +++++++
 security/integrity/ima/ima_policy.c | 5 +++++
 2 files changed, 12 insertions(+)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 44941c1..6a1971f 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -146,3 +146,10 @@ config IMA_X509_PATH
 	default "/etc/ima/x509_ima.der"
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

