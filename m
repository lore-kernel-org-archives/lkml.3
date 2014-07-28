Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaG1T5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:57:19 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:53539 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaG1T5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:57:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140728194251.GB30282@n2100.arm.linux.org.uk>
References: <20140722153623.25088.37742.stgit@buzz>
	<20140722153635.25088.14197.stgit@buzz>
	<20140728181456.GO15536@arm.com>
	<CALYGNiNJDHfQm2yk067hh-Wywsb_Ki5AEE_sTMkYegJi9spSzw@mail.gmail.com>
	<20140728184107.GR15536@arm.com>
	<CALYGNiNaMMv9itJ_+cvPDn1_Yo4GTPQJ-Cy9zBzJzfaDLfkvmg@mail.gmail.com>
	<20140728191305.GA30282@n2100.arm.linux.org.uk>
	<CALYGNiNVduTK8MXt8VJyiqdsB0mA_OnC0hLOB-WzgAEMZyu9sg@mail.gmail.com>
	<20140728194251.GB30282@n2100.arm.linux.org.uk>
Date: Mon, 28 Jul 2014 23:57:16 +0400
Message-ID: <CALYGNiO6PEPoHDrcLRZxQVT2=-1upyh6E-TWBCMB0MR8u5Sx6w@mail.gmail.com>
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

On Mon, Jul 28, 2014 at 11:42 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jul 28, 2014 at 11:29:39PM +0400, Konstantin Khlebnikov wrote:
>> Ok, before switching from identity mapping to normal mapping kernel must
>> switch instruction pointer from physical address to virtual.
>
> "switch instruction pointer from physical address to virtual."
>
> There's no such distinction for the instruction pointer.

I know. I mean "logically".

>
> There is the mode where the MMU is disabled.  The CPU fetches from the
> address in the program counter.  The instructions it fetches will
> instruct it to perform operations to enable the MMU.
>
> The CPU itself continues fetching instructions (with an unpredictable
> number of instructions in the CPU's pipeline) across this boundary.
>
> Hence, it is _impossible_ to know which exact instructions are fetched
> with the MMU off, and which are fetched with the MMU on.
>
> This is why we need the identity mapping: so that the CPU's instruction
> fetches can continue unaffected by turning the MMU on.
>
> Before the MMU is on, the CPU is fetching from an untranslated (== physical)
> view of the address space, which is limited to 4GB in size.
>
> After the MMU is on, the CPU is fetching from a translated (== virtual)
> view of the address space, which and the translated version is also
> limited to 4GB in size.

Sorry but I'm really look so dumb? Maybe it's true, it's almost
midnight at my side.

>
>> It's a long jump
>> out idmap code section to some normal kernel function.
>> __secondary_switched in my case. And both physical source and virtual
>> destination addresses must present in one same mapping (idmap).
>
> ... one which the code already caters for.
>
>> idmap pgd starts as copy of pgd from init_mm, it points to the same pmd pages.
>> When it populates identical mapping for that special code section it allocates
>> new pages from pmd entries (which covers 1Gb of vm layout) but only few of
>> them are filled. In case 3/1GB split If idmap touches somehing above 3Gb it
>> kills whole kernel vm layout and as result kernel cannot jump to any
>> virtual address.
>
> It doesn't matter, provided the kernel text and data in the virtual
> address space are not overwritten by the identity mapping.  If it
> ends up in the vmalloc or IO space, that should not be a problem.

In my case it's been overwritten.
And it always happens when PHYS_OFFSET >= PAGE_OFFSET
because in case of LPAE idmap always overwrites 1Gb at once.

>
> It also should not be a problem if the physical memory starts at
> PAGE_OFFSET (iow, PHYS_OFFSET == PAGE_OFFSET).  Indeed, we have
> some platforms where that is true.
>
> --
> FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
> according to speedtest.net.
