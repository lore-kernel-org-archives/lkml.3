Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbaAWWtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:49:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49015 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaAWWtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:49:03 -0500
Date: Thu, 23 Jan 2014 23:48:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
Message-ID: <20140123224857.GG5868@pd.tnic>
References: <20140123221108.GL18196@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140123221108.GL18196@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 04:11:08PM -0600, Alex Thorlton wrote:
> We've been hitting the following bug in the latest kernel, during boot:

Can you merge

git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git#next

into your tree, enable CONFIG_EFI_PGT_DUMP, apply the debugging patch
below, catch the whole dmesg and send it to me (privately is fine too)?

Thanks.

---
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index f35c66c5959a..07712b9b4263 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -348,7 +348,12 @@ static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
 						_PAGE_USER));
 		}
 		pmd = pmd_offset(pud, phys);
-		BUG_ON(!pmd_none(*pmd));
+		if (!pmd_none(*pmd)) {
+			pr_err("phys: 0x%lx, PGD: 0x%lx, PUD: 0x%lx, PMD: 0x%lx\n",
+				phys, pgd_val(*pgd), pud_val(*pud), pmd_val(*pmd));
+			BUG();
+		}
+
 		set_pmd(pmd, __pmd(phys | pgprot_val(prot)));
 	}
 }
--

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
