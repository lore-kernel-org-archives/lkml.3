Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaG1T3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:29:42 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:48064 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaG1T3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:29:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140728191305.GA30282@n2100.arm.linux.org.uk>
References: <20140722153623.25088.37742.stgit@buzz>
	<20140722153635.25088.14197.stgit@buzz>
	<20140728181456.GO15536@arm.com>
	<CALYGNiNJDHfQm2yk067hh-Wywsb_Ki5AEE_sTMkYegJi9spSzw@mail.gmail.com>
	<20140728184107.GR15536@arm.com>
	<CALYGNiNaMMv9itJ_+cvPDn1_Yo4GTPQJ-Cy9zBzJzfaDLfkvmg@mail.gmail.com>
	<20140728191305.GA30282@n2100.arm.linux.org.uk>
Date: Mon, 28 Jul 2014 23:29:39 +0400
Message-ID: <CALYGNiNVduTK8MXt8VJyiqdsB0mA_OnC0hLOB-WzgAEMZyu9sg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: LPAE: reduce damage caused by idmap to virtual
 memory layout
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Vitaly Andrianov <vitalya@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Cyril Chemparathy <cyril@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 11:13 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jul 28, 2014 at 10:57:00PM +0400, Konstantin Khlebnikov wrote:
>> Also I seen comment somewhere in the code which tells that idrmap pgd is
>> always below 4gb which isn't quite true.
>
> "idmap" means "identity map".  It's a region which maps the same value of
> physical address to the same value of virtual address.
>
> Since the virtual address space is limited to 4GB, there is /no way/ that
> the physical address can be above 4GB, and it still be called an
> "identity map".
>
> The reason for this is that code in the identity map will be fetched with
> the MMU off.  While this code is running, it will enable the MMU using the
> identity map page table pointer, and the CPU must see _no_ change in the
> instructions/data fetched from that region.  It will then branch to the
> kernel proper, and the kernel will then switch away from the identity page
> table.
>
> Once the kernel has switched away from the identity page table, interrupts
> and other exceptions can then be taken on the CPU - but not before.
> Neither is it expected that the CPU will access any devices until it has
> switched away from the identity page table.
>
> What this also means is that the code in the identity map must remain
> visible in the low 4GB of physical address space.

Ok, before switching from identity mapping to normal mapping kernel must
switch instruction pointer from physical address to virtual. It's a long jump
out idmap code section to some normal kernel function.
__secondary_switched in my case. And both physical source and virtual
destination addresses must present in one same mapping (idmap).

idmap pgd starts as copy of pgd from init_mm, it points to the same pmd pages.
When it populates identical mapping for that special code section it allocates
new pages from pmd entries (which covers 1Gb of vm layout) but only few of
them are filled. In case 3/1GB split If idmap touches somehing above 3Gb it
kills whole kernel vm layout and as result kernel cannot jump to any
virtual address.

>
>> Moreover, I had some experiments with
>> mapping ram to random places in qemu and seen that kernel cannot boot if
>> PHYS_OFFSET isn't alligned to 128mb which is strange.
>
> That is intentional.  PHYS_OFFSET has a number of restrictions, one of
> them is indeed that the physical offset /will/ be aligned to 128MB.
> That was decided after looking at the platforms we have and is now
> fixed at that value with platform-breaking consequences if it needs
> changing.
>
> --
> FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
> according to speedtest.net.
