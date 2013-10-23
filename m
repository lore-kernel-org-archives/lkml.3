Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3JWIcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:32:48 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28359 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab3JWIco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:32:44 -0400
X-IronPort-AV: E=Sophos;i="4.93,553,1378857600"; 
   d="scan'208";a="63712819"
Message-ID: <1382517150.22417.21.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] EFI and multiboot2 devlopment work for Xen
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <grub-devel@gnu.org>, <keir@xen.org>, <david.woodhouse@intel.com>,
        <stefano.stabellini@eu.citrix.com>,
        Daniel Kiper <daniel.kiper@oracle.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>, Jan Beulich <JBeulich@suse.com>,
        Peter Jones <pjones@redhat.com>, <ross.philipson@citrix.com>,
        <boris.ostrovsky@oracle.com>, <richard.l.maliszewski@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Date: Wed, 23 Oct 2013 09:32:30 +0100
In-Reply-To: <20131022162632.GB19189@phenom.dumpdata.com>
References: <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
	 <1382433990.1657.66.camel@hastur.hellion.org.uk>
	 <5266620602000078000FCA48@nat28.tlf.novell.com>
	 <1382435127.1657.70.camel@hastur.hellion.org.uk>
	 <526668A502000078000FCA7B@nat28.tlf.novell.com>
	 <20131022134252.GA27302@phenom.dumpdata.com>
	 <1382449985.18283.12.camel@hastur.hellion.org.uk>
	 <20131022140947.GA17829@phenom.dumpdata.com>
	 <1382451868.18283.21.camel@hastur.hellion.org.uk>
	 <1382455358.18283.31.camel@hastur.hellion.org.uk>
	 <20131022162632.GB19189@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 12:26 -0400, Konrad Rzeszutek Wilk wrote:
> It can (at least in Linux). There are two entry points in the Linux kernel
> and - one when it is launched from 'linuxefi' (See efi_stub_entry in 
> arch/x86/boot/compressed/head_64.S), the other when it is launched
> from an EFI shell - see efi_pe_entry in arch/x86/boot/compressed/head_64.S.


Yes, it seems I was confused and spreading misinformation. Sorry!

Matthew explained this stuff to me yesterday, let me see if I can
regurgitate it. Hopefully Matthew can crrect the inevitable mistakes...

A kernel binary built with EFI stub support has three entry points:

      * The traditional real mode "zImage" entry point
      * The standard PE/COFF entry point
      * A "Linux EFI" PE/COFF entry point

I think we can safely ignore the first of these for the purposes of this
conversation. I'm also going to ignore SB initially and cover it
separately at the end.

The second (standard PE/COFF entry point) can be launched using the UEFI
chainloader call. AIUI this should work with xen.efi today. There are
some limitations however, firstly there is no way to pass additional
blobs and so the launched image must load e.g. dom0 and initrd itself,
which Linux does by processing the initrd= option in the command line
and using UEFI functionality to load the blobs from disk. Xen does by
reading its own config file and loading dom0 + initrd based on that. I
assume this means that chainload doesn't call ExitBootServices (anyone
can confirm?). Another limitation of this is that the UEFI functionality
to load stuff from disk can only read from FAT partitions.  It's not
clear to me if this mechanism limits only the loading of additional
blobs from FAT or if that applies to the kernel image itself. In reality
the blob and the kernel are usually stored in the same directory anyhow.

Is there a second method which can load standard PE/COFF images i.e.
some sort of "boot a kernel" method which calls ExitBootServices etc?
Even if this exists I don't think we can/want to use it.

The third ("Linux EFI" PE/COFF entry) is launched with the "efilinux"
patch to grub. This does not call ExitBootServices and also passes an
additional struct to the kernel which contains mostly (exactly? == is
the same struct) the same stuff as the traditional 16-bit entry point
would construct and pass to the 32-bit kernel. The EFI stub can also use
UEFI calls to get most (all?) of the same info. There was some related
madness about how the framebuffer is detected. Unlike the chainload
mechanism efilinux does not expect or provide PE/COFF relocation. The
kernel is PIC on entry so no relocations are actually needed. In theory
the Linux EFI stub could instead have included a NULL relocation table
but doesn't. (I expect Xen is in the same boat WRT relocations). I think
this method also provides a mechanism to provide a blob (AKA the initrd)
to the kernel, which means it can be loaded from any filesystem which
grub understands (not just FAT). There is only one which is a not
sufficient for Xen.

>From a SB point of view the major difference between chainload and
linuxefi is that chainload can only validate signatures against the UEFI
"core" key db (maintained by UEFI) while linuxefi can also use keys from
MOK db ("Machine Operator Key", which is a second DB provided and
maintained by "shim"). Michael was saying elsewhere in this thread that
SuSE at least have a patch which allow the chainload mechanism to use
MOK as well.

I hope that is an accurate braindump of what Matthew explained to me
yesterday, mistakes are naturally all mine ;-)

Am I correct that xen.efi today can be loaded from grub today using the
chainload command? Whereupon it will parse the xen.cfg and load the dom0
kernel and load things from FAT etc and everything just works. IOW
        UEFI -> chainload(Xen)
and
        UEFI -> chainload(grub) -> chainload(Xen)
work equivalently from the POV of Xen?

Ian.

