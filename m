Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab3K2I33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:29:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab3K2I30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:29:26 -0500
Date: Fri, 29 Nov 2013 16:28:22 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 00/12] kexec kernel efi runtime support
Message-ID: <20131129082822.GA4186@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <20131127125003.GG18170@console-pimps.org>
 <20131128020840.GB4282@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128020840.GB4282@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/13 at 10:08am, Dave Young wrote:
> On 11/27/13 at 12:50pm, Matt Fleming wrote:
> > On Tue, 26 Nov, at 01:57:45PM, Dave Young wrote:
> > > Hi,
> > > 
> > > Here is the V4 resend for supporting kexec kernel efi runtime.
> > > Per pervious discussion I pass the 1st kernel efi runtime mapping
> > > via setup_data to 2nd kernel. Besides of the runtime mapping
> > > info I also pass the fw_vendor, runtime, config table, smbios
> > > physical address in setup_data. EFI spec mentioned fw_vendor,
> > > runtime, config table addresses will be converted to virt address
> > > after entering virtual mode, but we will use it as physical address
> > > in efi_init. For smbios EFI spec did not mention about the address
> > > updating, but during my test on a HP workstation, the bios will
> > > convert it to Virt addr, thus pass it in setup_data as well.
> >  
> > Dave, your commits introduce a bunch of new sparse warnings,
> 
> Hi, Matt
> 
> Will fix them, thanks.
> 
> > 
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:130:15: warning: incorrect type in assignment (different address spaces)
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:130:15:    expected struct setup_data *sdata
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:130:15:    got void [noderef] <asn:2>*
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:140:23: warning: incorrect type in argument 1 (different address spaces)
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:140:23:    expected void [noderef] <asn:2>*addr
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:140:23:    got struct setup_data *sdata
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:143:16: warning: incorrect type in assignment (different address spaces)
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:143:16:    expected struct efi_setup_data *[addressable] [toplevel] esdata
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:143:16:    got void [noderef] <asn:2>*
> > 
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:701:20: warning: incorrect type in assignment (different address spaces)
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:701:20:    expected void *tablep
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:701:20:    got void [noderef] <asn:2>*
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:722:23: warning: incorrect type in argument 1 (different address spaces)
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:722:23:    expected void [noderef] <asn:2>*addr
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:722:23:    got void *tablep
> > 
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:1079:31: warning: incorrect type in argument 1 (different address spaces)
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:1079:31:    expected void [noderef] <asn:2>*addr
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:1079:31:    got struct efi_setup_data *[addressable] [toplevel] esdata

For the early_memremap, these warnings are safe, but it create a lot of
warnings and looks anoise.

I think for anyone who are using early_memremap should know this is a normal
kernel memory instead of real __iomem, so I'd prefer below fix, it will suppress
most of original and new warnings:

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 34f69cb..1db414f 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -325,9 +325,10 @@ extern void early_ioremap_init(void);
 extern void early_ioremap_reset(void);
 extern void __iomem *early_ioremap(resource_size_t phys_addr,
 				   unsigned long size);
-extern void __iomem *early_memremap(resource_size_t phys_addr,
+extern void *early_memremap(resource_size_t phys_addr,
 				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
+extern void early_memunmap(void *addr, unsigned long size);
 extern void fixup_early_ioremap(void);
 extern bool is_early_ioremap_ptep(pte_t *ptep);
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 799580c..92a896652 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -562,10 +562,10 @@ early_ioremap(resource_size_t phys_addr, unsigned long size)
 }
 
 /* Remap memory */
-void __init __iomem *
+void __init *
 early_memremap(resource_size_t phys_addr, unsigned long size)
 {
-	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
+	return (__force void __kernel *) __early_ioremap(phys_addr, size, PAGE_KERNEL);
 }
 
 void __init early_iounmap(void __iomem *addr, unsigned long size)
@@ -620,3 +620,8 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
 	}
 	prev_map[slot] = NULL;
 }
+
+void __init early_memunmap(void *addr, unsigned long size)
+{
+	early_iounmap((__force void __iomem *)addr, size);
+}

