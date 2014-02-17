Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaBQS1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:27:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47450 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbaBQS1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:27:32 -0500
Date: Mon, 17 Feb 2014 19:27:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC, MCE, AMD: Fix code to prevent NULL dereference
Message-ID: <20140217182729.GE4559@pd.tnic>
References: <1392659391-2411-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1392659391-2411-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 11:49:51AM -0600, Aravind Gopalakrishnan wrote:
> If MCE decoding support does not exist for a particular family/model,
> and if one tries to inject errors using mce_amd_inj module, it leads
> to kernel OOPS. Especially if we inject errors to MC0, MC1, MC2 banks.

Well, we shouldn't even be loading the module on unsupported hw, i.e.,
something like that:

--
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 30f7309446a6..3ef997bfb89d 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -816,10 +816,10 @@ static int __init mce_amd_init(void)
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
 	if (c->x86_vendor != X86_VENDOR_AMD)
-		return 0;
+		return -ENODEV;
 
 	if (c->x86 < 0xf || c->x86 > 0x16)
-		return 0;
+		return -ENODEV;
 
 	fam_ops = kzalloc(sizeof(struct amd_decoder_ops), GFP_KERNEL);
 	if (!fam_ops)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
