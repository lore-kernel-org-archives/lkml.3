Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3HPF6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 01:58:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34541 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab3HPF6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 01:58:07 -0400
Message-ID: <520DBF4E.2060101@ti.com>
Date: Fri, 16 Aug 2013 00:57:34 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v3 00/12] edma: Add support for SG lists of any length
References: <1375719297-12871-1-git-send-email-joelf@ti.com>
In-Reply-To: <1375719297-12871-1-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following offline discussions with Sekhar, we discussed some ideas to
change a few things in this patch series to make it fail-safe. As such,
the only changes we are making for v4 will be to not cyclically link
immediately but doing so only once the ISR has finished setup (apart
from other style cleanups).

Any conditions where we are not able to modify the link in time (due to
heavily loaded system) will be detected and reported by the use of
linking to a NULL set.

The new approach will be fast because of no requirement to stall or
wait, and any DMA issues with heavily loaded systems can be detected as
error conditions.

This should architecturally be the final version of the patch series to
add DMA support for SG lists of any length.

Thanks,

-Joel

On 08/05/2013 11:14 AM, Joel Fernandes wrote:
> Here is a more improved approach for DMA support of SG lists of any length
> in the EDMA DMA Engine driver.
> 
> In the previous approach [1] we depended on error interrupts to detect
> missed events and manually retrigger them, however as discussed in [2],
> there are concerns this can be trouble some for high speed peripherals
> which may need a more real-time response from the DMA controller.
> 
> In this approach, we divide the total no of MAX slots per channel, into
> 2 linked sets which are cyclically linked to each other (the cyclic
> link between the 2 sets make sure that the DMA is continuous till the whole
> SG list has exhausted). We then enable completion interrupts on both linked
> sets which results in recyling/preparing respective linked set with the
> next set of SG entries. The interrupt handler executes in parallel while
> the EDMA controller DMA's the next list. This results in no interruption.
> 
> Special handling is done for first linked set (as we set up both linked
> sets initially before starting with the DMA), and last one where the cyclic
> link has to be broken and a link to the Dummy slot has to be created.
> Also we keep track of whether all pending DMA operations have completed
> before we can mark it as complete.
> 
> [1] https://lkml.org/lkml/2013/7/29/312
> [2] https://lkml.org/lkml/2013/7/30/54
> 
> Joel Fernandes (12):
>   dma: edma: Setup parameters to DMA MAX_NR_SG at a time
>   ARM: edma: Don't clear EMR of channel in edma_stop
>   dma: edma: remove limits on number of slots
>   dma: edma: Write out and handle MAX_NR_SG at a given time
>   ARM: edma: Add function to enable interrupt for a PaRAM slot
>   ARM: edma: Add pr_debug in edma_link
>   dma: edma: Add function to dump a PaRAM set from PaRAM
>   dma: edma: Add one more required slot to MAX slots
>   dma: edma: Implement multiple linked sets for continuity
>   dma: edma: Check if MAX_NR_SG is even in prep function
>   dma: edma: Keep tracking of Pending interrupts (pending_acks)
>   dma: edma: Return if nothing left todo in edma_execute
> 
>  arch/arm/common/edma.c             |   18 ++-
>  drivers/dma/edma.c                 |  279 +++++++++++++++++++++++++++++-------
>  include/linux/platform_data/edma.h |    1 +
>  3 files changed, 243 insertions(+), 55 deletions(-)
> 

