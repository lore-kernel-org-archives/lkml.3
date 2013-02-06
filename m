Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3BFNWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:22:35 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65312 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3BFNWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:22:33 -0500
Date: Wed, 6 Feb 2013 08:23:22 -0500
From: Matt Porter <mporter@ti.com>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Chris Ball <cjb@laptop.org>, Vinod Koul <vinod.koul@intel.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dan Williams <djbw@fb.com>, Venkatraman S <svenkatr@ti.com>
Subject: Re: [PATCH 0/3] omap_hsmmc DT DMA Client support
Message-ID: <20130206132322.GY2244@beef>
References: <1359752479-29427-1-git-send-email-mporter@ti.com>
 <201302061341.06964.poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302061341.06964.poeschel@lemonage.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 01:41:06PM +0100, Lars Poeschel wrote:
> Hi Matt!
> 
> At first thanks for you efforts on DMA Engine on AM33XX.
> 
> On Friday 01 February 2013 at 22:01:17, Matt Porter wrote:
> > This series adds DT DMA Engine Client support to the omap_hsmmc.
> > It leverages the generic DMA OF helpers in -next and the
> > dma_request_slave_channel_compat() wrapper introduced in the
> > AM33XX DMA Engine series to support DMA in omap_hsmmc on platforms
> > booting via DT. These platforms include omap2/3/4/5 and am33xx.
> > 
> > These patches were split out from the v5 version of the AM33XX DMA
> > series and split from the EDMA-specific omap_hsmmc changes.
> > 
> > The series depends on the following patches:
> > 
> > 	- dmaengine DT support and edma dmaengine driver fix from
> > 	  the git://git.infradead.org/users/vkoul/slave-dma.git next
> > 	  branch
> > 	- dma_request_slave_channel_compat() support
> > 	  https://patchwork.kernel.org/patch/2081671/
> > 
> > The series with all dependencies can be found at
> > https://github.com/ohporter/linux/tree/omap-hsmmc-dt-dmaengine-v1
> 
> I cloned your github repository and did short testing with it. I get the 
> following error when the kernel mounts my sd-card:
> 
> Starting udev
> [    5.884738] udevd[72]: starting version 182
> [    8.879651] edma-dma-engine edma-dma-engine.0: Exceeded max SG segments 33 

Hi Lars,

I left it somewhat ambiguous as to what this series claims to support,
sorry about that. This series, by itself, supports only platforms using
SDMA (omap 2/3/4/5 assuming you add the appropriate DMA dts bits). This
is only part of what am33xx requires for working mmc support. I've also
posted v3 of dmaengine slave sg caps series at
https://lkml.org/lkml/2013/2/4/561

I have to rebase the am33xx specific bits for omap_hsmmc on top of that
and post. That was previously all contained in one series but I didn't
want to block omap2/3/4/5 from working DMA on DT support until the api
change is resolved for am33xx.

-Matt

> [    8.887377] omap_hsmmc mmc.3: prep_slave_sg() failed
> [    8.892588] omap_hsmmc mmc.3: MMC start dma failure
> [    8.897725] mmcblk0: unknown error -1 sending read/write command, card 
> status 0x900
> [    8.905889] end_request: I/O error, dev mmcblk0, sector 17039
> [    8.911926] end_request: I/O error, dev mmcblk0, sector 17047
> [    8.917934] end_request: I/O error, dev mmcblk0, sector 17055
> [    8.923960] end_request: I/O error, dev mmcblk0, sector 17063
> [    8.929967] end_request: I/O error, dev mmcblk0, sector 17071
> [    8.935988] end_request: I/O error, dev mmcblk0, sector 17079
> [    8.942010] end_request: I/O error, dev mmcblk0, sector 17087
> [    8.948016] end_request: I/O error, dev mmcblk0, sector 17095
> [    8.954037] end_request: I/O error, dev mmcblk0, sector 17103
> [    8.960043] end_request: I/O error, dev mmcblk0, sector 17111
> [    9.020919] EXT4-fs error (device mmcblk0p2): __ext4_get_inode_loc:3764: 
> inode #8: block 239: comm mount: unable to read itable block
> [    9.033514] EXT4-fs (mmcblk0p2): no journal found
> [    9.043799] kjournald starting.  Commit interval 5 seconds
> [    9.049589] EXT3-fs (mmcblk0p2): warning: mounting fs with errors, running 
> e2fsck is recommended
> [    9.060940] EXT3-fs (mmcblk0p2): using internal journal
> [    9.066437] EXT3-fs (mmcblk0p2): recovery complete
> [    9.071460] EXT3-fs (mmcblk0p2): mounted filesystem with ordered data mode
> 
> After that the filesystem on the sd-card has an error that I have to fix with 
> e2fsck. As rootfs I use a nfsroot.
> In my quick tests, same setup, I don't get any error on edma-dmaengine-
> am33xx-v5 branch of your repository.
> If you need any further information, let me now.
> 
> Regards,
> Lars
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
