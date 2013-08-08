Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828Ab3HHLu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:50:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58484 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934065Ab3HHLux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:50:53 -0400
Message-ID: <520385D3.1060408@ti.com>
Date: Thu, 8 Aug 2013 17:19:39 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
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
Subject: Re: [PATCH v3 02/12] ARM: edma: Don't clear EMR of channel in edma_stop
References: <1375719297-12871-1-git-send-email-joelf@ti.com> <1375719297-12871-3-git-send-email-joelf@ti.com>
In-Reply-To: <1375719297-12871-3-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 August 2013 09:44 PM, Joel Fernandes wrote:
> We certainly don't want error conditions to be cleared any other
> place but the EDMA error handler, as this will make us 'forget'
> about missed events we might need to know errors have occurred.
> 
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
> 
> This causes the following  problems:
> 
> 1.
> If error interrupt is also pending and TC interrupt clears the EMR
> by calling edma_stop as has been observed in the edma_callback function,
> the ARM will execute the error interrupt even though the EMR is clear.
> As a result, the  dma_ccerr_handler returns IRQ_NONE. If this happens
> enough number of times, IRQ subsystem disables the interrupt thinking
> its spurious which makes error handler never execute again.
> 
> 2.
> Also even if error handler doesn't return IRQ_NONE, the removing of EMR
> removes the knowledge about which channel had a missed event, and thus
> a manual trigger on such channels cannot be performed.
> 
> The EMR is ultimately being cleared by the Error interrupt handler
> once it is handled so we remove code that does it in edma_stop and
> allow it to happen there.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>

Queuing this for v3.11 fixes. While committing, I changed the headline
to remove capitalization and made it more readable by removing register
level details. The new headline is:

ARM: edma: don't clear missed events in edma_stop()

Thanks,
Sekhar

