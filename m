Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaKEJXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:23:04 -0500
Received: from mail-bn1on0148.outbound.protection.outlook.com ([157.56.110.148]:27904
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753936AbaKEJW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:22:56 -0500
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <kim.phillips@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <horia.geanta@freescale.com>,
        <marex@denx.de>, Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH v2] crypto: caam: fix error reporting
Date: Wed, 5 Nov 2014 11:21:24 +0200
Message-ID: <1415179284-19791-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
References: <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(105606002)(92726001)(107046002)(88136002)(46102003)(62966003)(104016003)(95666004)(31966008)(99396003)(2201001)(87286001)(92566001)(106466001)(19580395003)(19580405001)(89996001)(77156002)(68736004)(229853001)(87936001)(93916002)(48376002)(76176999)(36756003)(50466002)(26826002)(50226001)(4396001)(84676001)(44976005)(120916001)(102836001)(21056001)(6806004)(33646002)(64706001)(20776003)(104166001)(97736003)(47776003)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0610;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0610;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B18196@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0755;
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
 drivers/crypto/caam/error.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 6531054..66d73bf 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -213,27 +213,36 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
 		void (*report_ssed)(struct device *jrdev, const u32 status,
 				    const char *error);
 		const char *error;
-	} status_src[] = {
+	} status_src[16] = {
 		{ NULL, "No error" },
 		{ NULL, NULL },
 		{ report_ccb_status, "CCB" },
 		{ report_jump_status, "Jump" },
 		{ report_deco_status, "DECO" },
-		{ NULL, NULL },
+		{ NULL, "Queue Manager Interface" },
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
 
 	/*
-	 * If there is no further error handling function, just
-	 * print the error code, error string and exit. Otherwise
-	 * call the handler function.
+	 * If there is an error handling function, call it to report the error.
+	 * Otherwise print the error source name.
 	 */
-	if (!status_src[ssrc].report_ssed)
-		dev_err(jrdev, "%08x: %s: \n", status, status_src[ssrc].error);
-	else
+	if (status_src[ssrc].report_ssed)
 		status_src[ssrc].report_ssed(jrdev, status, error);
+	else if (error)
+		dev_err(jrdev, "%d: %s\n", ssrc, error);
+	else
+		dev_err(jrdev, "%d: unknown error source\n", ssrc);
 }
 EXPORT_SYMBOL(caam_jr_strstatus);
-- 
1.8.3.1

