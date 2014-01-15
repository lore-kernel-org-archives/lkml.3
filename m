Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaAOLLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:11:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36895 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbaAOLLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:11:03 -0500
Date: Wed, 15 Jan 2014 12:10:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: [PATCH -v1.2] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
Message-ID: <20140115111056.GB32056@pd.tnic>
References: <20140114114133.GA31473@khazad-dum.debian.net>
 <20140114115547.GA29887@pd.tnic>
 <52D55468.6000000@zytor.com>
 <20140114153534.GE29865@pd.tnic>
 <20140114162722.GF29865@pd.tnic>
 <52D56627.9060802@zytor.com>
 <20140114164208.GK29865@pd.tnic>
 <52D5780E.4070700@zytor.com>
 <20140114230711.GS29865@pd.tnic>
 <52D5D883.802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D5D883.802@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 04:38:27PM -0800, H. Peter Anvin wrote:
> In file included from
> /home/hpa/kernel/distwork/arch/x86/include/asm/processor.h:20:0,

Finnish!

Well, Boris the dumbass forgot to amend, changes were still in the index
but not committed. This is what I get when I do a couple of things at
the same time. :(

---
From: Borislav Petkov <bp@suse.de>

This adds the workaround for erratum 793 as a precaution in case not
every BIOS implements it. This addresses CVE-2013-6885.

Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
---
 arch/x86/include/uapi/asm/msr-index.h |  1 +
 arch/x86/kernel/cpu/amd.c             | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 37813b5ddc37..59cea185ad1d 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -184,6 +184,7 @@
 #define MSR_AMD64_PATCH_LOADER		0xc0010020
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
+#define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
 #define MSR_AMD64_BU_CFG2		0xc001102a
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 4a48e8bbd857..6ac3a67ad471 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -507,6 +507,16 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
 	}
 #endif
+
+	/* F16h erratum 793, CVE-2013-6885 */
+	if (c->x86 == 0x16 && c->x86_model <= 0xf) {
+		u64 val;
+
+		rdmsrl(MSR_AMD64_LS_CFG, val);
+		if (!(val & BIT(15)))
+			wrmsrl(MSR_AMD64_LS_CFG, val | BIT(15));
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
