Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbaGNOGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:06:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48336 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbaGNOG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:06:27 -0400
Date: Mon, 14 Jul 2014 16:06:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC, MCE_AMD: Add MCE decoding for F15h M60h
Message-ID: <20140714140610.GB25115@pd.tnic>
References: <1405098795-4678-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1405098795-4678-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:13:15PM -0500, Aravind Gopalakrishnan wrote:
> Add decoding logic for new Fam15h model 60h.
> 
> Tested using mce_amd_inj module and works fine.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> ---
>  drivers/edac/mce_amd.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 55 insertions(+), 4 deletions(-)

Ok, I simplified it a bit, those switch-case(s) with a single case
statement are not as readable as a simple if-else. I'd appreciate it if
you ran it to check whether it still decodes fine before I apply it.

Thanks.

---
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] EDAC, MCE, AMD: Add MCE decoding for F15h M60h
Date:	Fri, 11 Jul 2014 12:13:15 -0500
Message-ID: <1405098795-4678-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Status: RO

Add decoding logic for new Fam15h model 60h.

Tested using mce_amd_inj module and works fine.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Link: http://lkml.kernel.org/r/1405098795-4678-1-git-send-email-Aravind.Gopalakrishnan@amd.com
[ Boris: simplify a bit. ]
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/mce_amd.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

Index: linux/drivers/edac/mce_amd.c
===================================================================
--- linux.orig/drivers/edac/mce_amd.c	2014-07-14 15:37:55.997137526 +0200
+++ linux/drivers/edac/mce_amd.c	2014-07-14 15:55:01.081151137 +0200
@@ -78,7 +78,8 @@ static const char * const f15h_mc1_mce_d
 	"uop queue",
 	"insn buffer",
 	"predecode buffer",
-	"fetch address FIFO"
+	"fetch address FIFO",
+	"dispatch uop queue"
 };
 
 static const char * const f15h_mc2_mce_desc[] = {
@@ -267,6 +268,12 @@ static bool f15h_mc0_mce(u16 ec, u8 xec)
 			pr_cont("System Read Data Error.\n");
 		else
 			pr_cont(" Internal error condition type %d.\n", xec);
+	} else if (INT_ERROR(ec)) {
+		if (xec <= 0x1f)
+			pr_cont("Hardware Assert.\n");
+		else
+			ret = false;
+
 	} else
 		ret = false;
 
@@ -373,7 +380,7 @@ static bool f15h_mc1_mce(u16 ec, u8 xec)
 		pr_cont("%s.\n", f15h_mc1_mce_desc[xec-4]);
 		break;
 
-	case 0x11 ... 0x14:
+	case 0x11 ... 0x15:
 		pr_cont("Decoder %s parity error.\n", f15h_mc1_mce_desc[xec-4]);
 		break;
 
@@ -397,10 +404,20 @@ static void decode_mc1_mce(struct mce *m
 		bool k8 = (boot_cpu_data.x86 == 0xf && (m->status & BIT_64(58)));
 
 		pr_cont("during %s.\n", (k8 ? "system linefill" : "NB data read"));
+	} else if (INT_ERROR(ec)) {
+		if (xec <= 0x3f)
+			pr_cont("Hardware Assert.\n");
+		else
+			goto wrong_mc1_mce;
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
@@ -468,6 +485,11 @@ static bool f15h_mc2_mce(u16 ec, u8 xec)
 		default:
 			ret = false;
 		}
+	} else if (INT_ERROR(ec)) {
+		if (xec <= 0x3f)
+			pr_cont("Hardware Assert.\n");
+		else
+			ret = false;
 	}
 
 	return ret;
@@ -615,6 +637,7 @@ static void decode_mc4_mce(struct mce *m
 static void decode_mc5_mce(struct mce *m)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
+	u16 ec = EC(m->status);
 	u8 xec = XEC(m->status, xec_mask);
 
 	if (c->x86 == 0xf || c->x86 == 0x11)
@@ -622,6 +645,14 @@ static void decode_mc5_mce(struct mce *m
 
 	pr_emerg(HW_ERR "MC5 Error: ");
 
+	if (INT_ERROR(ec)) {
+		if (xec <= 0x1f) {
+			pr_cont("Hardware Assert.\n");
+			return;
+		} else
+			goto wrong_mc5_mce;
+	}
+
 	if (xec == 0x0 || xec == 0xc)
 		pr_cont("%s.\n", mc5_mce_desc[xec]);
 	else if (xec <= 0xd)
@@ -642,6 +673,10 @@ static void decode_mc6_mce(struct mce *m
 	pr_emerg(HW_ERR "MC6 Error: ");
 
 	switch (xec) {
+	case 0x0:
+		pr_cont("Hardware Assertion");
+		break;
+
 	case 0x1:
 		pr_cont("Free List");
 		break;
@@ -857,7 +892,8 @@ static int __init mce_amd_init(void)
 		break;
 
 	case 0x15:
-		xec_mask = 0x1f;
+		xec_mask = c->x86_model == 0x60 ? 0x3f : 0x1f;
+
 		fam_ops->mc0_mce = f15h_mc0_mce;
 		fam_ops->mc1_mce = f15h_mc1_mce;
 		fam_ops->mc2_mce = f15h_mc2_mce;

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
