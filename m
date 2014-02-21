Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbaBUOX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:23:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38529 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbaBUOXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:23:24 -0500
Date: Fri, 21 Feb 2014 15:23:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC, MCE, AMD: Fix code to prevent NULL dereference
Message-ID: <20140221142317.GB11531@pd.tnic>
References: <20140217182729.GE4559@pd.tnic>
 <5302625C.4050700@amd.com>
 <20140217194153.GG4559@pd.tnic>
 <53028EE8.20106@amd.com>
 <20140218003654.GK4559@pd.tnic>
 <20140218084636.GA24465@pd.tnic>
 <5303A607.7090309@amd.com>
 <20140220093207.GB8876@pd.tnic>
 <53062845.8010203@amd.com>
 <20140220161351.GA2014@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140220161351.GA2014@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 05:13:51PM +0100, Borislav Petkov wrote:
> On Thu, Feb 20, 2014 at 10:07:33AM -0600, Aravind Gopalakrishnan wrote:
> > Tested the above a final time on local machine and it works fine..
> 
> Ok, I'll queue it up with your Tested-by. Thanks.

So I dropped the family check altogether, modulo the warning that says
that we're getting loaded on unsupported hardware. We want to allow
loading, even if we don't have family ops.

Ok?

--
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] MCE, AMD: Fix decoding module loading on unsupported hw

We want to still be able to issue some error information on systems for
which there is no decoding support (think older distro kernels here,
for example). Therefore, we allow module registration but skip the
per-family bank-specific decoders and issue the general information
only, i.e.:

[   46.822828] [Hardware Error]: Error Status: Uncorrected, software containable error.
[   46.822846] [Hardware Error]: CPU:0 (15:30:0) MC0_STATUS[-|UE|-|-|-|-|-]: 0xa000000000010f0f
[   46.822858] [Hardware Error]: cache level: L3/GEN, mem/io: GEN, mem-tx: GEN, part-proc: GEN (timed out)

with the hope that it still contains helpful useful bits.

Suggested-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Tested-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/mce_amd.c | 65 +++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 30f7309446a6..51b9caa0b024 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -741,6 +741,36 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 	if (amd_filter_mce(m))
 		return NOTIFY_STOP;
 
+	pr_emerg(HW_ERR "%s\n", decode_error_status(m));
+
+	pr_emerg(HW_ERR "CPU:%d (%x:%x:%x) MC%d_STATUS[%s|%s|%s|%s|%s",
+		m->extcpu,
+		c->x86, c->x86_model, c->x86_mask,
+		m->bank,
+		((m->status & MCI_STATUS_OVER)	? "Over"  : "-"),
+		((m->status & MCI_STATUS_UC)	? "UE"	  : "CE"),
+		((m->status & MCI_STATUS_MISCV)	? "MiscV" : "-"),
+		((m->status & MCI_STATUS_PCC)	? "PCC"	  : "-"),
+		((m->status & MCI_STATUS_ADDRV)	? "AddrV" : "-"));
+
+	if (c->x86 == 0x15 || c->x86 == 0x16)
+		pr_cont("|%s|%s",
+			((m->status & MCI_STATUS_DEFERRED) ? "Deferred" : "-"),
+			((m->status & MCI_STATUS_POISON)   ? "Poison"   : "-"));
+
+	/* do the two bits[14:13] together */
+	ecc = (m->status >> 45) & 0x3;
+	if (ecc)
+		pr_cont("|%sECC", ((ecc == 2) ? "C" : "U"));
+
+	pr_cont("]: 0x%016llx\n", m->status);
+
+	if (m->status & MCI_STATUS_ADDRV)
+		pr_emerg(HW_ERR "MC%d_ADDR: 0x%016llx\n", m->bank, m->addr);
+
+	if (!fam_ops)
+		goto err_code;
+
 	switch (m->bank) {
 	case 0:
 		decode_mc0_mce(m);
@@ -774,33 +804,7 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 		break;
 	}
 
-	pr_emerg(HW_ERR "Error Status: %s\n", decode_error_status(m));
-
-	pr_emerg(HW_ERR "CPU:%d (%x:%x:%x) MC%d_STATUS[%s|%s|%s|%s|%s",
-		m->extcpu,
-		c->x86, c->x86_model, c->x86_mask,
-		m->bank,
-		((m->status & MCI_STATUS_OVER)	? "Over"  : "-"),
-		((m->status & MCI_STATUS_UC)	? "UE"	  : "CE"),
-		((m->status & MCI_STATUS_MISCV)	? "MiscV" : "-"),
-		((m->status & MCI_STATUS_PCC)	? "PCC"	  : "-"),
-		((m->status & MCI_STATUS_ADDRV)	? "AddrV" : "-"));
-
-	if (c->x86 == 0x15 || c->x86 == 0x16)
-		pr_cont("|%s|%s",
-			((m->status & MCI_STATUS_DEFERRED) ? "Deferred" : "-"),
-			((m->status & MCI_STATUS_POISON)   ? "Poison"   : "-"));
-
-	/* do the two bits[14:13] together */
-	ecc = (m->status >> 45) & 0x3;
-	if (ecc)
-		pr_cont("|%sECC", ((ecc == 2) ? "C" : "U"));
-
-	pr_cont("]: 0x%016llx\n", m->status);
-
-	if (m->status & MCI_STATUS_ADDRV)
-		pr_emerg(HW_ERR "MC%d_ADDR: 0x%016llx\n", m->bank, m->addr);
-
+ err_code:
 	amd_decode_err_code(m->status & 0xffff);
 
 	return NOTIFY_STOP;
@@ -816,10 +820,7 @@ static int __init mce_amd_init(void)
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
 	if (c->x86_vendor != X86_VENDOR_AMD)
-		return 0;
-
-	if (c->x86 < 0xf || c->x86 > 0x16)
-		return 0;
+		return -ENODEV;
 
 	fam_ops = kzalloc(sizeof(struct amd_decoder_ops), GFP_KERNEL);
 	if (!fam_ops)
@@ -874,7 +875,7 @@ static int __init mce_amd_init(void)
 	default:
 		printk(KERN_WARNING "Huh? What family is it: 0x%x?!\n", c->x86);
 		kfree(fam_ops);
-		return -EINVAL;
+		fam_ops = NULL;
 	}
 
 	pr_info("MCE: In-kernel MCE decoding enabled.\n");
-- 
1.8.5.2.192.g7794a68

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
