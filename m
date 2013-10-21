Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3JUMsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 08:48:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab3JUMsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:48:18 -0400
Date: Mon, 21 Oct 2013 20:47:39 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131021124739.GA4515@dhcp-16-126.nay.redhat.com>
References: <20131010085827.GA9929@pd.tnic>
 <20131010123453.GA12321@console-pimps.org>
 <20131011062437.GA14115@dhcp-16-126.nay.redhat.com>
 <20131011074144.GA18719@pd.tnic>
 <20131012075443.GD7550@dhcp-16-126.nay.redhat.com>
 <20131012101308.GI12321@console-pimps.org>
 <20131012103054.GA13739@pd.tnic>
 <20131013031126.GB1914@darkstar.nay.redhat.com>
 <20131013092521.GA22866@pd.tnic>
 <20131014155851.GJ4009@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014155851.GJ4009@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/13 at 05:58pm, Borislav Petkov wrote:
> On Sun, Oct 13, 2013 at 11:25:21AM +0200, Borislav Petkov wrote:
> > In the meantime, I'll finish randconfigs testing of the patches and
> > upload the latest version to k-org, I'll let you know.
> 
> Ok, here it is:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git#efi
> 
> This version seems to work on most boxes except Matt's Asus half-life
> zombie.

What's the status of this series?

> 
> Let me know if there are issues,

I need below patch for mapping to fixed virt addr passed
from 1st kernel. Would you like to add it to your series
or I send out it later?

BTW, what tree should my patches based on? Matt's next tree?
Looks like your tree is not consistant with Matt's tree.

--

Add function efi_map_region_fixed for mapping to a specific
virt address. 

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- bp.orig/arch/x86/platform/efi/efi.c
+++ bp/arch/x86/platform/efi/efi.c
@@ -1086,6 +1086,19 @@ static void efi_merge_regions(void)
 	}
 }
 
+void __init efi_map_region_fixed(efi_memory_desc_t *md, u64 virt_addr)
+{
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+	unsigned long pf = 0;
+
+	if (!(md->attribute & EFI_MEMORY_WB))
+		pf |= _PAGE_PCD;
+
+	if(kernel_map_pages_in_pgd(pgd, md->phys_addr, virt_addr, md->num_pages, pf))
+		pr_warning("Error mapping PA 0x%llx -> VA 0x%llx!\n",
+			   md->phys_addr, virt_addr);
+}
+
 /*
  * Map efi memory ranges for runtime serivce
  * Return the new memmap with updated virtual addrresses.
