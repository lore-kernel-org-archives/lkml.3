Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbaGKQao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:30:44 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:23353
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751183AbaGKQam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:30:42 -0400
X-WSS-ID: 0N8K36W-07-67B-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <dougthompson@xmission.com>, <bp@alien8.de>, <m.chehab@samsung.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] EDAC, MCE_AMD: Add MCE decoding for F15h M60h
Date: Fri, 11 Jul 2014 12:13:15 -0500
Message-ID: <1405098795-4678-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(62966002)(77982001)(229853001)(21056001)(36756003)(53416004)(88136002)(2201001)(20776003)(101416001)(104166001)(4396001)(74662001)(64706001)(86362001)(77156001)(81342001)(68736004)(84676001)(92726001)(83322001)(48376002)(31966008)(97736001)(106466001)(77096002)(50226001)(85306003)(50986999)(47776003)(93916002)(95666004)(74502001)(19580395003)(81542001)(87936001)(83072002)(89996001)(50466002)(76482001)(79102001)(85852003)(107046002)(46102001)(19580405001)(80022001)(92566001)(44976005)(102836001)(99396002)(105586002)(87286001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB038;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02698DF457
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add decoding logic for new Fam15h model 60h.

Tested using mce_amd_inj module and works fine.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 drivers/edac/mce_amd.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 5f43620..7406d1c 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -78,7 +78,8 @@ static const char * const f15h_mc1_mce_desc[] = {
 	"uop queue",
 	"insn buffer",
 	"predecode buffer",
-	"fetch address FIFO"
+	"fetch address FIFO",
+	"dispatch uop queue"
 };
 
 static const char * const f15h_mc2_mce_desc[] = {
@@ -267,6 +268,15 @@ static bool f15h_mc0_mce(u16 ec, u8 xec)
 			pr_cont("System Read Data Error.\n");
 		else
 			pr_cont(" Internal error condition type %d.\n", xec);
+	} else if (INT_ERROR(ec)) {
+		switch (xec) {
+		case 0x00 ... 0x1f:
+			pr_cont("Hardware Assert.\n");
+			break;
+		default:
+			ret = false;
+
+		}
 	} else
 		ret = false;
 
@@ -373,7 +383,7 @@ static bool f15h_mc1_mce(u16 ec, u8 xec)
 		pr_cont("%s.\n", f15h_mc1_mce_desc[xec-4]);
 		break;
 
-	case 0x11 ... 0x14:
+	case 0x11 ... 0x15:
 		pr_cont("Decoder %s parity error.\n", f15h_mc1_mce_desc[xec-4]);
 		break;
 
@@ -397,10 +407,24 @@ static void decode_mc1_mce(struct mce *m)
 		bool k8 = (boot_cpu_data.x86 == 0xf && (m->status & BIT_64(58)));
 
 		pr_cont("during %s.\n", (k8 ? "system linefill" : "NB data read"));
+	} else if (INT_ERROR(ec)) {
+		switch (xec) {
+		case 0x00 ... 0x3f:
+			pr_cont("Hardware Assert.\n");
+			return;
+		default:
+			goto wrong_mc1_mce;
+
+		}
 	} else if (fam_ops->mc1_mce(ec, xec))
 		;
 	else
-		pr_emerg(HW_ERR "Corrupted MC1 MCE info?\n");
+		goto wrong_mc1_mce;
+
+	return;
+
+wrong_mc1_mce:
+	pr_emerg(HW_ERR "Corrupted MC1 MCE info?\n");
 }
 
 static bool k8_mc2_mce(u16 ec, u8 xec)
@@ -468,6 +492,15 @@ static bool f15h_mc2_mce(u16 ec, u8 xec)
 		default:
 			ret = false;
 		}
+	} else if (INT_ERROR(ec)) {
+		switch (xec) {
+		case 0x00 ... 0x3f:
+			pr_cont("Hardware Assert.\n");
+			break;
+		default:
+			ret = false;
+
+		}
 	}
 
 	return ret;
@@ -615,6 +648,7 @@ static void decode_mc4_mce(struct mce *m)
 static void decode_mc5_mce(struct mce *m)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
+	u16 ec = EC(m->status);
 	u8 xec = XEC(m->status, xec_mask);
 
 	if (c->x86 == 0xf || c->x86 == 0x11)
@@ -622,6 +656,16 @@ static void decode_mc5_mce(struct mce *m)
 
 	pr_emerg(HW_ERR "MC5 Error: ");
 
+	if (INT_ERROR(ec)) {
+		switch (xec) {
+		case 0x00 ... 0x1f:
+			pr_cont("Hardware Assert.\n");
+			return;
+		default:
+			goto wrong_mc5_mce;
+		}
+	}
+
 	if (xec == 0x0 || xec == 0xc)
 		pr_cont("%s.\n", mc5_mce_desc[xec]);
 	else if (xec <= 0xd)
@@ -642,6 +686,9 @@ static void decode_mc6_mce(struct mce *m)
 	pr_emerg(HW_ERR "MC6 Error: ");
 
 	switch (xec) {
+	case 0x0:
+		pr_cont("Hardware Assertion");
+		break;
 	case 0x1:
 		pr_cont("Free List");
 		break;
@@ -857,7 +904,11 @@ static int __init mce_amd_init(void)
 		break;
 
 	case 0x15:
-		xec_mask = 0x1f;
+		if (c->x86_model == 0x60)
+			xec_mask = 0x3f;
+		else
+			xec_mask = 0x1f;
+
 		fam_ops->mc0_mce = f15h_mc0_mce;
 		fam_ops->mc1_mce = f15h_mc1_mce;
 		fam_ops->mc2_mce = f15h_mc2_mce;
-- 
1.8.1.2

