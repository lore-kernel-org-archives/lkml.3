Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3JUM6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 08:58:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31077 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3JUM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:58:19 -0400
Date: Mon, 21 Oct 2013 14:57:56 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: boris.ostrovsky@oracle.com, david.woodhouse@intel.com,
        ian.campbell@citrix.com, jbeulich@suse.com, keir@xen.org,
        konrad.wilk@oracle.com, pjones@redhat.com,
        richard.l.maliszewski@intel.com, ross.philipson@citrix.com,
        stefano.stabellini@eu.citrix.com, xen-devel@lists.xen.org,
        grub-devel@gnu.org, linux-kernel@vger.kernel.org
Subject: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During work on multiboot2 protocol support for Xen it was discovered
that memory map passed via relevant tag could not represent wide range
of memory types available on EFI platforms. Additionally, GRUB2
implementation calls ExitBootServices() on them just before jumping
into loaded image. In this situation loaded system could not clearly
identify reserved memory regions, EFI runtime services regions and others.

Normally, on EFI platform, system requires access to at least EFI runtime
services. However, it is not possible to identify them in GRUB2
implementation of multiboot2 protocol because they are marked as reserved,
like memory mapped IO regions, really reserved memory regions and others.
Additionally, it is not possible to get memory map directly from EFI (similar
solution is used on legacy BIOS platforms in Xen case) because ExitBootServices()
was earlier called by GRUB2. So there is only one chance to do that today.
Loaded image could map all reserved regions. However, this is not final
solution because it could be dangerous. So this is rather workaround which
should be used on currently existing multiboot2 protocol implementation only.
At this stage extra tag could be added to multiboot2 protocol to pass plain
EFI memory map to loaded image too. However, this solution requires some
coordination with GRUB2 upstream and could take some time.

Additionally, it should be mentioned that there is no possibility or it could
be very difficult to implement secure boot on EFI platforms using GRUB2 as boot
loader because, as it was mentioned earlier, it calls ExitBootServices().

At first there was a plan to use upstream GRUB2 as a reference multiboot2 protocol
implementation. However, during discussion on LPC 2013 it was stated that every
distribution uses tons of patches for GRUB2. So distros GRUB2 implementation
substantially deviates form upstream. One of this deviation is linuxefi module
which enables usage of secure boot protocol on EFI platforms with shim. However,
it should be mentioned that this module still uses Linux x86 boot protocol.
So I think that similar solution could be used in multiboot2 protocol case.

Separate multiboot2efi module should be established. It should verify system
kernel and all loaded modules using shim on EFI platforms with enabled secure boot
(this step should be omitted on platforms without secure boot). If verification
is successfully completed GRUB2 should transfer control to loaded image. Later
it should get system memory map directly from EFI, do other needed things, call
ExitBootServices() and finally start loaded system. I think that this proposal
could solve above mentioned problems. Additionally, I think that multiboot2 protocol
should be extended by adding extra tag which will be used to pass plain EFI memory
map to loaded image. Just in case (we could also use this as transitional thing
as I mentioned above). Work on this solution should be coordinated with upstream
GRUB2 guys to ease its later introduction in distros and to avoid another deviation.

At first I am going to prepare multiboot2 protocol implementation for Xen (there
is about 80% of code ready) with above mentioned workaround. Later I am going
to work on multiboot2efi module.

What do you think about that?
Any comments, suggestions, objections?

Daniel
