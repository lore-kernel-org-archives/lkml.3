Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaBRIqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 03:46:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35254 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbaBRIqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 03:46:39 -0500
Date: Tue, 18 Feb 2014 09:46:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC, MCE, AMD: Fix code to prevent NULL dereference
Message-ID: <20140218084636.GA24465@pd.tnic>
References: <1392659391-2411-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20140217182729.GE4559@pd.tnic>
 <5302625C.4050700@amd.com>
 <20140217194153.GG4559@pd.tnic>
 <53028EE8.20106@amd.com>
 <20140218003654.GK4559@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140218003654.GK4559@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, let's try a simpler thing. Only build-tested here:

---
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 30f7309446a6..30592838f1da 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -738,6 +738,9 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 	struct cpuinfo_x86 *c = &cpu_data(m->extcpu);
 	int ecc;
 
+	if (!fam_ops)
+		return NOTIFY_DONE;
+
 	if (amd_filter_mce(m))
 		return NOTIFY_STOP;
 
@@ -816,10 +819,10 @@ static int __init mce_amd_init(void)
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
 	if (c->x86_vendor != X86_VENDOR_AMD)
-		return 0;
+		return -ENODEV;
 
 	if (c->x86 < 0xf || c->x86 > 0x16)
-		return 0;
+		return -ENODEV;
 
 	fam_ops = kzalloc(sizeof(struct amd_decoder_ops), GFP_KERNEL);
 	if (!fam_ops)
@@ -874,6 +877,7 @@ static int __init mce_amd_init(void)
 	default:
 		printk(KERN_WARNING "Huh? What family is it: 0x%x?!\n", c->x86);
 		kfree(fam_ops);
+		fam_ops = NULL;
 		return -EINVAL;
 	}
 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
