Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab3G3FTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:19:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54398 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab3G3FTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:19:12 -0400
Message-ID: <51F74CAD.3040604@ti.com>
Date: Tue, 30 Jul 2013 10:48:37 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 3/9] ARM: edma: Add function to manually trigger an EDMA
 channel
References: <1375104595-16018-1-git-send-email-joelf@ti.com> <1375104595-16018-4-git-send-email-joelf@ti.com>
In-Reply-To: <1375104595-16018-4-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 July 2013 06:59 PM, Joel Fernandes wrote:
> Manual trigger for events missed as a result of splitting a
> scatter gather list and DMA'ing it in batches. Add a helper
> function to trigger a channel incase any such events are missed.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  arch/arm/common/edma.c             |   21 +++++++++++++++++++++
>  include/linux/platform_data/edma.h |    2 ++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index 3567ba1..10995b2 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -1236,6 +1236,27 @@ void edma_resume(unsigned channel)
>  }
>  EXPORT_SYMBOL(edma_resume);
>  
> +int edma_manual_trigger(unsigned channel)

edma_trigger_channel() maybe? Brings consistency with
edma_alloc_channel() edma_free_channel() etc.

> +{
> +	unsigned ctlr;
> +	int j;
> +	unsigned int mask;
> +
> +	ctlr = EDMA_CTLR(channel);
> +	channel = EDMA_CHAN_SLOT(channel);
> +	mask = BIT(channel & 0x1f);
> +
> +	j = channel >> 5;
> +
> +	/* EDMA channels without event association */

May be actually check for no-event association before you trigger in
software? You can do that by looking at unused channel list, no?

> +	edma_shadow0_write_array(ctlr, SH_ESR, j, mask);

edma_shadow0_write_array(ctlr, SH_ESR, channel >> 5, mask) is no less
readable, but I leave it to you.

Thanks,
Sekhar

