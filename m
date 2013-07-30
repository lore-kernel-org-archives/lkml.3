Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab3G3IbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:31:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58480 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3G3IbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:31:02 -0400
Message-ID: <51F77982.7030601@ti.com>
Date: Tue, 30 Jul 2013 13:59:54 +0530
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
Subject: Re: [PATCH 7/9] ARM: edma: Don't clear EMR of channel in edma_stop
References: <1375104595-16018-1-git-send-email-joelf@ti.com> <1375104595-16018-8-git-send-email-joelf@ti.com>
In-Reply-To: <1375104595-16018-8-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 July 2013 06:59 PM, Joel Fernandes wrote:
> We certainly don't want error conditions to be cleared anywhere

'anywhere' is a really loaded term.

> as this will make us 'forget' about missed events. We depend on
> knowing which events were missed in order to be able to reissue them.

> This fixes a race condition where the EMR was being cleared
> by the transfer completion interrupt handler.
> 
> Basically, what was happening was:
> 
>             Missed event
>              |
>              |
>              V
> SG1-SG2-SG3-Null
>          \
>           \__TC Interrupt (Almost same time as ARM is executing
> TC interrupt handler, an event got missed and also forgotten
> by clearing the EMR).

Sorry, but I dont see how edma_stop() is coming into picture in the race
you describe?

> The EMR is ultimately being cleared by the Error interrupt
> handler once it is handled so we don't have to do it in edma_stop.

This, I agree with. edma_clean_channel() also there to re-initialize the
channel so doing it in edma_stop() certainly seems superfluous.

Thanks,
Sekhar

> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  arch/arm/common/edma.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index 10995b2..dec772e 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -1328,7 +1328,6 @@ void edma_stop(unsigned channel)
>  		edma_shadow0_write_array(ctlr, SH_EECR, j, mask);
>  		edma_shadow0_write_array(ctlr, SH_ECR, j, mask);
>  		edma_shadow0_write_array(ctlr, SH_SECR, j, mask);
> -		edma_write_array(ctlr, EDMA_EMCR, j, mask);
>  
>  		pr_debug("EDMA: EER%d %08x\n", j,
>  				edma_shadow0_read_array(ctlr, SH_EER, j));
> 

