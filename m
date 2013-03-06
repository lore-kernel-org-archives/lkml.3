Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3CFDU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 22:20:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab3CFDUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 22:20:54 -0500
Message-ID: <1362540045.22132.68.camel@bling.home>
Subject: Re: Marvell 88NV9143 in mini-PCIe not working with intel_iommu=on
From: Alex Williamson <alex.williamson@redhat.com>
To: Andrew Cooks <acooks@gmail.com>
Cc: Gaudenz Steinlin <gaudenz@soziologie.ch>, jyli@marvell.com,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>, Shun Fu <fushun@marvell.com>
Date: Tue, 05 Mar 2013 20:20:45 -0700
In-Reply-To: <CAJtEV7Zyq3+YPu9Vvcxcm8nw41-ENjLuRHUzyFFzXQn-wiSf1w@mail.gmail.com>
References: <874ngpj3d9.fsf@meteor.durcheinandertal.bofh>
	 <CAJtEV7Zyq3+YPu9Vvcxcm8nw41-ENjLuRHUzyFFzXQn-wiSf1w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 10:48 +0800, Andrew Cooks wrote:
> On Tue, Mar 5, 2013 at 11:03 PM, Gaudenz Steinlin <gaudenz@soziologie.ch> wrote:
> >
> > [ Sending this to the MVUMI driver authors and the IOMMU list as I can't
> > tell which part is at fault. ]
> >
> > [ ... ]
> > [    4.342079] dmar: DRHD: handling fault status reg 2
> > [    4.342132] dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr fffff000
> > [    4.342132] DMAR:[fault reason 02] Present bit in context entry is clear
> > [ ... ]
> > [   34.344078] mvumi 0000:02:00.1: no handshake response at state 0x2.
> > [   34.344115] mvumi 0000:02:00.1: isr : global=0x0,status=0x0.
> > [   34.344146] mvumi 0000:02:00.1: handshake failed at state 0x2.
> > [   34.344266] mvumi: probe of 0000:02:00.1 failed with error -22
> >
> 
> Looks like another Marvell DMA source tag issue.
> 
> > And the full lspic output for this device:
> >
> > gaudenz@meteor:~$ sudo lspci -vv -nnq -s 02:
> > 02:00.0 Mass storage controller [01ff]: Marvell Technology Group Ltd. Device [1b4b:91f3]
> >         Subsystem: Marvell Technology Group Ltd. Device [1b4b:9143]
> > ...
> >         Capabilities: [140 v1] Virtual Channel
> >                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
> >                 Arb:    Fixed- WRR32- WRR64- WRR128-
> >                 Ctrl:   ArbSelect=Fixed
> >                 Status: InProgress-
> >                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> >                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> >                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
> >                         Status: NegoPending- InProgress-
> >
> > 02:00.1 Mass storage controller [0180]: Marvell Technology Group Ltd. Device [1b4b:9143] (rev 10)
> >         Subsystem: Marvell Technology Group Ltd. Device [1b4b:9143]
> > ...
> >         Kernel driver in use: mvumi
> >
> > 02:00.2 Non-Volatile memory controller [0108]: Marvell Technology Group Ltd. Device [1b4b:91e3] (prog-if 01)
> >         Subsystem: Marvell Technology Group Ltd. Device [1b4b:9143]
> >...
> 
> In this case it seems like a multifunction device with 02:00.1 being
> the only function that the mvumi driver cares about.  So my guess is
> that 02:00.1 is issuing DMA with the incorrect tag of 02:00.0.
> 
> Perhaps Alex Williamson can tell us about iommu device groups, whether
> it would be possible to group the functions together automatically and
> whether that would solve the problem. It should also be possible to
> adapt the quirk patch I posted recently to handle this, but I'm still
> waiting to hear if that patch has a future.

I don't see any ACS support so the functions are likely placed into the
same IOMMU group.  If your guess about the source ID tagging is correct
then oddly you probably could use VFIO to assign these devices to a QEMU
guest and it would work because all the functions get the same IOMMU
mapping, but the host IOMMU drivers don't make use of IOMMU groups for
the DMA API, so it's no help there.  Thanks,

Alex

