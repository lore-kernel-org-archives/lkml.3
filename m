Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3KNBhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:37:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab3KNBhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:37:43 -0500
Date: Thu, 14 Nov 2013 09:36:49 +0800
From: Dave Young <dyoung@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de
Subject: Re: [patch 7/7 v2] x86: add xloadflags bit for efi runtime support
 on kexec
Message-ID: <20131114013649.GA4081@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082719.416282009@dhcp-16-126.nay.redhat.com>
 <5283A6DD.2030808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5283A6DD.2030808@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/13 at 08:20am, H. Peter Anvin wrote:
> On 11/05/2013 12:20 AM, dyoung@redhat.com wrote:
> > Old kexec-tools can not load new kernel. The reason is previously kexec-tools
> > do not fill efi_info in x86 setup header thus efi init fail and switch
> > to noefi boot. In new kexec-tools it will by default fill efi_info and
> > pass other efi required infomation to 2nd kernel so kexec kernel efi
> > initialization will success finally.
> > 
> > To prevent from breaking userspace, add a new xloadflags bit so kexec-tools
> > will check the flag and switch to old logic.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  arch/x86/boot/header.S                |    9 ++++++++-
> >  arch/x86/include/uapi/asm/bootparam.h |    1 +
> >  2 files changed, 9 insertions(+), 1 deletion(-)
> > 
> > --- linux-2.6.orig/arch/x86/boot/header.S
> > +++ linux-2.6/arch/x86/boot/header.S
> > @@ -391,7 +391,14 @@ xloadflags:
> >  #else
> >  # define XLF23 0
> >  #endif
> > -			.word XLF0 | XLF1 | XLF23
> > +
> > +#if defined(CONFIG_X86_64) && defined(CONFIG_EFI)
> > +# define XLF4 XLF_EFI_KEXEC
> > +#else
> > +# define XLF4 0
> > +#endif
> > +
> > +			.word XLF0 | XLF1 | XLF23 | XLF4
> >  
> >  cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
> >                                                  #added with boot protocol
> > --- linux-2.6.orig/arch/x86/include/uapi/asm/bootparam.h
> > +++ linux-2.6/arch/x86/include/uapi/asm/bootparam.h
> > @@ -24,6 +24,7 @@
> >  #define XLF_CAN_BE_LOADED_ABOVE_4G	(1<<1)
> >  #define XLF_EFI_HANDOVER_32		(1<<2)
> >  #define XLF_EFI_HANDOVER_64		(1<<3)
> > +#define XLF_EFI_KEXEC			(1<<4)
> >  
> >  #ifndef __ASSEMBLY__
> >  
> > 
> 
> Also needs to be added to Documentation/x86/boot.txt with the exact
> semantics being exposed.

Will do

> 
> 	-hpa
> 
