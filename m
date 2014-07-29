Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaG2K5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:57:33 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55821 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753240AbaG2K52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:57:28 -0400
Date: Tue, 29 Jul 2014 11:57:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Vitaly Andrianov <vitalya@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Cyril Chemparathy <cyril@ti.com>
Subject: Re: [PATCH 2/2] ARM: LPAE: reduce damage caused by idmap to
	virtual memory layout
Message-ID: <20140729105717.GC30282@n2100.arm.linux.org.uk>
References: <20140722153623.25088.37742.stgit@buzz> <20140722153635.25088.14197.stgit@buzz> <20140728181456.GO15536@arm.com> <CALYGNiNJDHfQm2yk067hh-Wywsb_Ki5AEE_sTMkYegJi9spSzw@mail.gmail.com> <20140728184107.GR15536@arm.com> <CALYGNiNaMMv9itJ_+cvPDn1_Yo4GTPQJ-Cy9zBzJzfaDLfkvmg@mail.gmail.com> <20140728191305.GA30282@n2100.arm.linux.org.uk> <CALYGNiNVduTK8MXt8VJyiqdsB0mA_OnC0hLOB-WzgAEMZyu9sg@mail.gmail.com> <20140728194251.GB30282@n2100.arm.linux.org.uk> <CALYGNiO6PEPoHDrcLRZxQVT2=-1upyh6E-TWBCMB0MR8u5Sx6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALYGNiO6PEPoHDrcLRZxQVT2=-1upyh6E-TWBCMB0MR8u5Sx6w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 11:57:16PM +0400, Konstantin Khlebnikov wrote:
> On Mon, Jul 28, 2014 at 11:42 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Jul 28, 2014 at 11:29:39PM +0400, Konstantin Khlebnikov wrote:
> >> Ok, before switching from identity mapping to normal mapping kernel must
> >> switch instruction pointer from physical address to virtual.
> >
> > "switch instruction pointer from physical address to virtual."
> >
> > There's no such distinction for the instruction pointer.
> 
> I know. I mean "logically".
> 
...
> 
> Sorry but I'm really look so dumb? Maybe it's true, it's almost
> midnight at my side.

When you use language which suggests a lack of understanding, then
I will explain things.

> > It doesn't matter, provided the kernel text and data in the virtual
> > address space are not overwritten by the identity mapping.  If it
> > ends up in the vmalloc or IO space, that should not be a problem.
> 
> In my case it's been overwritten.
> And it always happens when PHYS_OFFSET >= PAGE_OFFSET
> because in case of LPAE idmap always overwrites 1Gb at once.

Right, I now see what you're getting at.  Here's a better description
which I've used when committing your patch.  I've only taken patch 2
at the present time.



On LPAE, each level 1 (pgd) page table entry maps 1GiB, and the level 2
(pmd) entries map 2MiB.

When the identity mapping is created on LPAE, the pgd pointers are copied
from the swapper_pg_dir.  If we find that we need to modify the contents
of a pmd, we allocate a new empty pmd table and insert it into the
appropriate 1GB slot, before then filling it with the identity mapping.

However, if the 1GB slot covers the kernel lowmem mappings, we obliterate
those mappings.

When replacing a PMD, first copy the old PMD contents to the new PMD, so
that we preserve the existing mappings in the 1GiB region, particularly
the mappings of the kernel itself.


-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
