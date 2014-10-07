Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaJGNxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:53:13 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53588 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaJGNxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:53:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>, rmk+kernel@arm.linux.org.uk
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Tue, 07 Oct 2014 15:52:27 +0200
Message-ID: <3659934.boXsmm8jcn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141007120659.GA30590@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <3256560.C0cZnIlnAv@wuerfel> <20141007120659.GA30590@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wRyjLbOireHYfVNHQV8+IqjKUhHp+VJXi6r3ejCxmp3
 am32ZHtdzF2XGaq2avxXX+UewA9ywT5bH3N11SeG1h79kmiIbj
 8WzOIw/l+OlPtv4+Zh3VQzdQwGfqWRgRc3dpojgk42Y2JqTKbS
 uTlQhCHZquQLn84z8y0bvY5xharI26W+E6otFE/3lykU9uLe4E
 tK0tuZJgH6nVsZNG/ygZfcPCscIibwn6NpE7bYH+G/z2cfpRab
 F4iShjTHqz3tvFgcOWjIInn+Ml6xCPajDbk3aEZXjF7ELvvXc+
 EG+UufluPR/Z+3AfH4U0W0UR6KNoykt/2T6lOXRj4xHqtsSV6h
 Mtpnh2BKk45kST98ebxA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2014 13:06:59 Lorenzo Pieralisi wrote:
> On Wed, Oct 01, 2014 at 10:38:45AM +0100, Arnd Bergmann wrote:
> 
> [...]
> 
> > pci_mmap_page_range could either get generalized some more in an attempt
> > to have a __weak default implementation that works on ARM, or it could
> > be changed to lose the dependency on pci_sys_data instead. In either
> > case, the change would involve using the generic pci_host_bridge_window
> > list.
> 
> On ARM pci_mmap_page_range requires pci_sys_data to retrieve its
> mem_offset parameter. I had a look, and I do not understand *why*
> it is required in that function, so I am asking. That function
> is basically used to map PCI resources to userspace, IIUC, through
> /proc or /sysfs file mappings. As far as I understand those mappings
> expect VMA pgoff to be the CPU address when files representing resources
> are mmapped from /proc and 0 when mmapped from /sys (I mean from
> userspace, then VMA pgoff should be updated by the kernel to map the
> resource).

Applying the mem_offset is certainly the more intuitive way, since
that lets you read the PCI BAR values from a device and access the
device with the appropriate offsets.

> Question is: why pci_mmap_page_range() should apply an additional
> shift to the VMA pgoff based on pci_sys_data.mem_offset, which represents
> the offset from cpu->bus offset. I do not understand that. PowerPC
> does not seem to apply that fix-up (in PowerPC __pci_mmap_make_offset there
> is commented out code which prevents the pci_mem_offset shift to be
> applied). I think it all boils down to what the userspace interface is
> expecting when the memory areas are mmapped, if anyone has comments on
> this that is appreciated.

The important part is certainly that whatever transformation is done
by pci_resource_to_user() gets undone by __pci_mmap_make_offset().

In case of PowerPC and Microblaze, the mem_offset handling is commented
out in both, to work around X11 trying to use the same values on
/dev/mem. However, they do have the respective fixup for io_offset.

sparc applies the offset in both places for both io_offset and mem_offset.
xtensa applies only io_offset in __pci_mmap_make_offset but neither
  in pci_resource_to_user. This probably works because the mem_offset is
  always zero there.
mips applies a different fixup (for 36-bit addressing), but not the
  mem_offset.

Every other architecture applies no offset here, neither in __pci_mmap_make_offset/pci_mmap_page_range nor in pci_resource_to_user

The only hint I could find for how the ARM version came to be is
from the historic kernel tree git log for linux-2.5.42, which added
the current code as

    2002/10/13 11:05:47+01:00 rmk
    [ARM] Update pcibios_enable_device, supply pci_mmap_page_range()
    Update pcibios_enable_device to only enable requested resources,
    mainly for IDE.  Supply a pci_mmap_page_range() function to allow
    user space to mmap PCI regions.

At that point, only two platforms had a nonzero mem_offset:
footbridge/dc21285 and integrator/pci_v3. Both were using VGA,
and presumably used this to make X work. (rmk might remember
details).

The code at the time matched what powerpc and sparc did, but then
both implemented pci_resource_to_user() in order for libpciaccess
to work correctly (bcea1db16b for sparc, 463ce0e103f for powerpc),
and later powerpc changed it again to not apply the offset in
pci_resource_to_user or pci_mmap_page_range in 396a1a5832ae.

	Arnd
