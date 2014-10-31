Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbaJaROl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:14:41 -0400
Received: from mail-bl2on0125.outbound.protection.outlook.com ([65.55.169.125]:11834
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751485AbaJaROk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:14:40 -0400
X-Greylist: delayed 959 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2014 13:14:39 EDT
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <horia.geanta@freescale.com>,
        <marex@denx.de>, Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: caam: fix error reporting
Date: Fri, 31 Oct 2014 18:57:33 +0200
Message-ID: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(229853001)(19580395003)(84676001)(69596002)(89996001)(97736003)(88136002)(87936001)(26826002)(36756003)(33646002)(19580405001)(105606002)(92566001)(2201001)(92726001)(68736004)(64706001)(99396003)(6806004)(77156002)(104166001)(106466001)(107046002)(104016003)(44976005)(87286001)(4396001)(120916001)(47776003)(93916002)(20776003)(81156004)(48376002)(46102003)(31966008)(50226001)(95666004)(21056001)(102836001)(50466002)(50986999)(62966003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB399;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB399;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B18196@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error code returned by hardware is four bits wide with an expected
zero MSB. A hardware error condition where the error code can get between
0x8 and 0xf will trigger an out of bound array access on the error
message table.
This patch fixes the invalid array access following such an error and
reports the condition.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/error.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 6531054..c4483ad 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -213,7 +213,7 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
 		void (*report_ssed)(struct device *jrdev, const u32 status,
 				    const char *error);
 		const char *error;
-	} status_src[] = {
+	} status_src[16] = {
 		{ NULL, "No error" },
 		{ NULL, NULL },
 		{ report_ccb_status, "CCB" },
@@ -222,18 +222,23 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
 		{ NULL, NULL },
 		{ report_jr_status, "Job Ring" },
 		{ report_cond_code_status, "Condition Code" },
+		{ NULL, NULL },
+		{ NULL, NULL },
+		{ NULL, NULL },
+		{ NULL, NULL },
+		{ NULL, NULL },
+		{ NULL, NULL },
+		{ NULL, NULL },
+		{ NULL, NULL },
 	};
 	u32 ssrc = status >> JRSTA_SSRC_SHIFT;
 	const char *error = status_src[ssrc].error;
 
-	/*
-	 * If there is no further error handling function, just
-	 * print the error code, error string and exit. Otherwise
-	 * call the handler function.
-	 */
-	if (!status_src[ssrc].report_ssed)
-		dev_err(jrdev, "%08x: %s: \n", status, status_src[ssrc].error);
-	else
+	if (status_src[ssrc].report_ssed)
 		status_src[ssrc].report_ssed(jrdev, status, error);
+	else if (error)
+		dev_err(jrdev, "%d: %s\n", ssrc, error);
+	else
+		dev_err(jrdev, "%d: unknown error code\n", ssrc);
 }
 EXPORT_SYMBOL(caam_jr_strstatus);
-- 
1.8.3.1

