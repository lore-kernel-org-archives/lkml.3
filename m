Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3JVOKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:10:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19629 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab3JVOKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:10:07 -0400
Date: Tue, 22 Oct 2013 10:09:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>, ross.philipson@citrix.com,
        stefano.stabellini@eu.citrix.com, grub-devel@gnu.org,
        david.woodhouse@intel.com, richard.l.maliszewski@intel.com,
        xen-devel@lists.xen.org, boris.ostrovsky@oracle.com,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Peter Jones <pjones@redhat.com>, linux-kernel@vger.kernel.org,
        keir@xen.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131022140947.GA17829@phenom.dumpdata.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <1382449985.18283.12.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382449985.18283.12.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 02:53:05PM +0100, Ian Campbell wrote:
> On Tue, 2013-10-22 at 09:42 -0400, Konrad Rzeszutek Wilk wrote:
> 
> > Looking at the Fedora GRUB2 source, the 'struct linux_kernel_header' is defined
> > in the linux/Documentation/x86/boot.txt and hpa is pretty strict
> > about making it backwards compatible. It also seems to support Xen!
> > 
> > (Interestingly enough we do have this structure in the code: see
> > setup_header in arch/x86/bzimage.c)
> 
> There will be another usage in tools/libxc/...bzimage too

Right.
> 
> FWIW I think we only use this stuff for the magic number/version and the
> payload_offset/length fields, which we do in order to extract the
> payload (ELF file) for booting dom0 and domU. It's not AFAIK used for
> booting Xen itself or lets say, that's not why I added it ;-)).

Right. I just meant that we have some of the code in the hypervisor
so using it to pass the EFI payload that way could be possible. But
then I realized it is pointless as we boot using the PV mechanism
which gets the EFI payload via hypercalls. So many ways to get this.

> 
> > Which in the GRUB2 is being constructed by parsing the EFI
> > data structures. But Linux concentrates on the EFI parts and mostly
> > ignores the rest. So this is more about passing those EFI values
> > downstream.
> 
> I wonder why Linux can't make the EFI calls to fetch them itself?

I believe it can if it is launched that way. Here is what I saw in the
Linux kernel:
/*                                                                              
 * Determine if we were loaded by an EFI loader.  If so, then we have also been 
 * passed the efi memmap, systab, etc., so we should use these data structures  
 * for initialization.  Note, the efi init code path is determined by the           
 * global efi_enabled. This allows the same kernel image to be used on existing 
 * systems (with a traditional BIOS) as well as on EFI systems.                 
 */                                                                             

Looking at arch/x86/boot/header.S in Linux I see some PE header and this
commit explains at lot:

commit 291f36325f9f252bd76ef5f603995f37e453fc60
Author: Matt Fleming <matt.fleming@intel.com>
Date:   Mon Dec 12 21:27:52 2011 +0000

    x86, efi: EFI boot stub support
    
    There is currently a large divide between kernel development and the
    development of EFI boot loaders. The idea behind this patch is to give
    the kernel developers full control over the EFI boot process. As
    H. Peter Anvin put it,
    
    "The 'kernel carries its own stub' approach been very successful in
    dealing with BIOS, and would make a lot of sense to me for EFI as
    well."
    
    This patch introduces an EFI boot stub that allows an x86 bzImage to
    be loaded and executed by EFI firmware. The bzImage appears to the
    firmware as an EFI application. Luckily there are enough free bits
    within the bzImage header so that it can masquerade as an EFI
    application, thereby coercing the EFI firmware into loading it and
    jumping to its entry point. The beauty of this masquerading approach
    is that both BIOS and EFI boot loaders can still load and run the same
    bzImage, thereby allowing a single kernel image to work in any boot
    environment.
    
    The EFI boot stub supports multiple initrds, but they must exist on
    the same partition as the bzImage. Command-line arguments for the
    kernel can be appended after the bzImage name when run from the EFI
    shell, e.g.
    
    Shell> bzImage console=ttyS0 root=/dev/sdb initrd=initrd.img


So it can be booted the same way as xen.efi. But my understanding is
that folks prefer a bootloader instead of loading the bzImage in an
NVRAM of a platform with pre-set parameters. Hence that mechanism
is not used by the majority of users.

Instead the majority of users would like to use a bootloader, like
GRUB2. And there are certain restrictions - if you launch from it
an PE/COFF application GRUB2 will call ExitBootServices. But if
you launch the Linux image (so using the linuxefi), it WILL NOT
call ExitBootServices.

But I say that (about ExitBootServices) - and I can't find it in
the GRUB2 code, so perhaps I am mistaken.
