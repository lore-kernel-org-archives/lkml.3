Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3JUU5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 16:57:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25438 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3JUU5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 16:57:49 -0400
Date: Mon, 21 Oct 2013 13:53:09 -0700 (PDT)
From: Seth Goldberg <seth.goldberg@oracle.com>
X-X-Sender: sethg@bergsoft
To: The development of GNU GRUB <grub-devel@gnu.org>
cc: boris.ostrovsky@oracle.com, david.woodhouse@intel.com,
        ian.campbell@citrix.com, jbeulich@suse.com, keir@xen.org,
        konrad.wilk@oracle.com, pjones@redhat.com,
        richard.l.maliszewski@intel.com, ross.philipson@citrix.com,
        stefano.stabellini@eu.citrix.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
In-Reply-To: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
Message-ID: <alpine.GSO.2.00.1310211348530.2162@oretfbsg>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Quoting Daniel Kiper, who wrote the following on Mon, 21 Oct 2013:

> Hi,
>
> During work on multiboot2 protocol support for Xen it was discovered
> that memory map passed via relevant tag could not represent wide range
> of memory types available on EFI platforms. Additionally, GRUB2
> implementation calls ExitBootServices() on them just before jumping
> into loaded image. In this situation loaded system could not clearly
> identify reserved memory regions, EFI runtime services regions and others.

   Yes, that is exactly why we added full support to pass the entire UEFI 
memory map via a new tag.

>
> Normally, on EFI platform, system requires access to at least EFI runtime
> services. However, it is not possible to identify them in GRUB2
> implementation of multiboot2 protocol because they are marked as reserved,
> like memory mapped IO regions, really reserved memory regions and others.
> Additionally, it is not possible to get memory map directly from EFI (similar
> solution is used on legacy BIOS platforms in Xen case) because ExitBootServices()
> was earlier called by GRUB2. So there is only one chance to do that today.
> Loaded image could map all reserved regions. However, this is not final
> solution because it could be dangerous. So this is rather workaround which
> should be used on currently existing multiboot2 protocol implementation only.
> At this stage extra tag could be added to multiboot2 protocol to pass plain
> EFI memory map to loaded image too. However, this solution requires some
> coordination with GRUB2 upstream and could take some time.

   This is precisely what we did, and though there is a risk of using a tag 
that is not accepted upstream, we did what we needed to do, since we ship the 
boot loader with the OS and don't have to be concerned with making it work 
with some arbitrary already-installed loader.

>
> Additionally, it should be mentioned that there is no possibility or it could
> be very difficult to implement secure boot on EFI platforms using GRUB2 as boot
> loader because, as it was mentioned earlier, it calls ExitBootServices().
>
> At first there was a plan to use upstream GRUB2 as a reference multiboot2 protocol
> implementation. However, during discussion on LPC 2013 it was stated that every
> distribution uses tons of patches for GRUB2. So distros GRUB2 implementation
> substantially deviates form upstream. One of this deviation is linuxefi module
> which enables usage of secure boot protocol on EFI platforms with shim. However,
> it should be mentioned that this module still uses Linux x86 boot protocol.
> So I think that similar solution could be used in multiboot2 protocol case.
>
> Separate multiboot2efi module should be established. It should verify system
> kernel and all loaded modules using shim on EFI platforms with enabled secure boot
> (this step should be omitted on platforms without secure boot). If verification
> is successfully completed GRUB2 should transfer control to loaded image. Later
> it should get system memory map directly from EFI, do other needed things, call
> ExitBootServices() and finally start loaded system. I think that this proposal
> could solve above mentioned problems. Additionally, I think that multiboot2 protocol
> should be extended by adding extra tag which will be used to pass plain EFI memory
> map to loaded image. Just in case (we could also use this as transitional thing
> as I mentioned above). Work on this solution should be coordinated with upstream
> GRUB2 guys to ease its later introduction in distros and to avoid another deviation.
>

   I'm not sure we even need a separate command -- it adds complexity for no 
reason.  It's reasonable to just perform the validation if we're on a UEFI 
platform and secure boot is enabled.  MAYBE an arg to the multiboot2 command 
would be useful for testing, but I'd rather not have any way for secure boot 
to be circumvented, lest a piece of malware only needs to write a new 
menuentry with the non-secure-boot multiboot2 command and make it the default.

  Thanks,
  --S


> At first I am going to prepare multiboot2 protocol implementation for Xen (there
> is about 80% of code ready) with above mentioned workaround. Later I am going
> to work on multiboot2efi module.
>
> What do you think about that?
> Any comments, suggestions, objections?
>
> Daniel
>
> _______________________________________________
> Grub-devel mailing list
> Grub-devel@gnu.org
> https://lists.gnu.org/mailman/listinfo/grub-devel
>
