Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbbAZHbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 02:31:09 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57312 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbbAZHbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 02:31:03 -0500
Message-ID: <54C5ECF4.10709@ti.com>
Date: Mon, 26 Jan 2015 09:29:56 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sekhar Nori <nsekhar@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: edma: Split up header file to platform_data
 and API file
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com>	<1417084891-17990-4-git-send-email-peter.ujfalusi@ti.com> <CAOesGMgdLB9WkOwCt__iRMnTYZ-tMNS==FL+b6s3CzHK4b0MYQ@mail.gmail.com>
In-Reply-To: <CAOesGMgdLB9WkOwCt__iRMnTYZ-tMNS==FL+b6s3CzHK4b0MYQ@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/22/2015 03:40 AM, Olof Johansson wrote:
> Hi,
> 
> On Thu, Nov 27, 2014 at 2:41 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>> include/linux/platform_data/ is not a correct place to keep the API
>> definitions for edma, it is meant to be only for the pdata for the device.
>> Clean up this by moving the API to include/linux/edma.h
> 
> It's a nice net improvement, but it moves some things that should be
> in _neither_ location to a new place where it doesn't belong either --
> and the new location is even more global. See below.
> 
> ...
> 
>> diff --git a/include/linux/edma.h b/include/linux/edma.h
>> new file mode 100644
>> index 000000000000..9df92198c117
>> --- /dev/null
>> +++ b/include/linux/edma.h
>> @@ -0,0 +1,153 @@
>> +/*
>> + * TI EDMA definitions
>> + *
>> + * Copyright (C) 2006-2013 Texas Instruments.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +/*
>> + * This EDMA3 programming framework exposes two basic kinds of resource:
>> + *
>> + *  Channel    Triggers transfers, usually from a hardware event but
>> + *             also manually or by "chaining" from DMA completions.
>> + *             Each channel is coupled to a Parameter RAM (PaRAM) slot.
>> + *
>> + *  Slot       Each PaRAM slot holds a DMA transfer descriptor (PaRAM
>> + *             "set"), source and destination addresses, a link to a
>> + *             next PaRAM slot (if any), options for the transfer, and
>> + *             instructions for updating those addresses.  There are
>> + *             more than twice as many slots as event channels.
>> + *
>> + * Each PaRAM set describes a sequence of transfers, either for one large
>> + * buffer or for several discontiguous smaller buffers.  An EDMA transfer
>> + * is driven only from a channel, which performs the transfers specified
>> + * in its PaRAM slot until there are no more transfers.  When that last
>> + * transfer completes, the "link" field may be used to reload the channel's
>> + * PaRAM slot with a new transfer descriptor.
>> + *
>> + * The EDMA Channel Controller (CC) maps requests from channels into physical
>> + * Transfer Controller (TC) requests when the channel triggers (by hardware
>> + * or software events, or by chaining).  The two physical DMA channels provided
>> + * by the TCs are thus shared by many logical channels.
>> + *
>> + * DaVinci hardware also has a "QDMA" mechanism which is not currently
>> + * supported through this interface.  (DSP firmware uses it though.)
>> + */
>> +
>> +#ifndef __LINUX_EDMA_H_
>> +#define __LINUX_EDMA_H_
>> +
>> +#include <linux/platform_data/edma.h>
>> +
>> +/* PaRAM slots are laid out like this */
>> +struct edmacc_param {
>> +       u32 opt;
>> +       u32 src;
>> +       u32 a_b_cnt;
>> +       u32 dst;
>> +       u32 src_dst_bidx;
>> +       u32 link_bcntrld;
>> +       u32 src_dst_cidx;
>> +       u32 ccnt;
>> +} __packed;
>> +
>> +/* fields in edmacc_param.opt */
>> +#define SAM            BIT(0)
>> +#define DAM            BIT(1)
>> +#define SYNCDIM                BIT(2)
>> +#define STATIC         BIT(3)
>> +#define EDMA_FWID      (0x07 << 8)
>> +#define TCCMODE                BIT(11)
>> +#define EDMA_TCC(t)    ((t) << 12)
>> +#define TCINTEN                BIT(20)
>> +#define ITCINTEN       BIT(21)
>> +#define TCCHEN         BIT(22)
>> +#define ITCCHEN                BIT(23)
> 
> This seems like the kind of thing that should go with the edma driver
> instead of being globally exported to the kernel through a
> include/linux header file.

Currently the edmacc_param struct is used by arch/arm/common/edma.c,
drivers/dma/edma.c and the sound/soc/davinci/davinci-pcm.c

For now this has to be in a global header file. Even with my local VIP branch
where I had removed the davinci-pcm already the two drivers for edma needs
this in global header file.
I can assure you, it will be gone (along with the arch/arm/common/edma.c) but
not right away.

-- 
Péter
