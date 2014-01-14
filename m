Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaANQ1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:27:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59788 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaANQ12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:27:28 -0500
Date: Tue, 14 Jan 2014 17:27:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum 793
Message-ID: <20140114162722.GF29865@pd.tnic>
References: <20140114114133.GA31473@khazad-dum.debian.net>
 <20140114115547.GA29887@pd.tnic>
 <52D55468.6000000@zytor.com>
 <20140114153534.GE29865@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140114153534.GE29865@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This adds the workaround for erratum 793 as a precaution in case not
every BIOS implements it. This addresses CVE-2013-6885.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/amd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 4a48e8bbd857..e4d6f8c91f51 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -507,6 +507,17 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
 	}
 #endif
+
+#define MSR_AMD_LS_CFG	0xc0011020
+	/* F16h, models 00h-0fh, erratum 793 */
+	if (c->x86 == 0x16 && c->x86_model <= 0xf) {
+		u64 val;
+
+		rdmsrl(MSR_AMD_LS_CFG, val);
+		if (!(val & BIT(15)))
+			wrmsrl(MSR_AMD_LS_CFG, val | BIT(15));
+	}
+
 }
 
 static const int amd_erratum_383[];
-- 
1.8.5.2.192.g7794a68

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
