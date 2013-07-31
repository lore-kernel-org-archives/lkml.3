Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab3GaFWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 01:22:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53964 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758743Ab3GaFWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 01:22:42 -0400
Message-ID: <51F89B0B.4080803@ti.com>
Date: Wed, 31 Jul 2013 00:05:15 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
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
References: <1375104595-16018-1-git-send-email-joelf@ti.com> <1375104595-16018-8-git-send-email-joelf@ti.com> <51F77982.7030601@ti.com>
In-Reply-To: <51F77982.7030601@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 03:29 AM, Sekhar Nori wrote:
> On Monday 29 July 2013 06:59 PM, Joel Fernandes wrote:
>> We certainly don't want error conditions to be cleared anywhere
> 
> 'anywhere' is a really loaded term.
> 
>> as this will make us 'forget' about missed events. We depend on
>> knowing which events were missed in order to be able to reissue them.
> 
>> This fixes a race condition where the EMR was being cleared
>> by the transfer completion interrupt handler.
>>
>> Basically, what was happening was:
>>
>>             Missed event
>>              |
>>              |
>>              V
>> SG1-SG2-SG3-Null
>>          \
>>           \__TC Interrupt (Almost same time as ARM is executing
>> TC interrupt handler, an event got missed and also forgotten
>> by clearing the EMR).
> 
> Sorry, but I dont see how edma_stop() is coming into picture in the race
> you describe?

In edma_callback function, for the case of DMA_COMPLETE (Transfer
completion interrupt), edma_stop() is called when all sets have been
processed. This had the effect of clearing the EMR.

This has 2 problems:

1.
If error interrupt is also pending and TC interrupt clears the EMR.

Due to this the ARM will execute the error interrupt even though the EMR
is clear. As a result, the following if condition in dma_ccerr_handler
will be true and IRQ_NONE is returned.

        if ((edma_read_array(ctlr, EDMA_EMR, 0) == 0) &&
            (edma_read_array(ctlr, EDMA_EMR, 1) == 0) &&
            (edma_read(ctlr, EDMA_QEMR) == 0) &&
            (edma_read(ctlr, EDMA_CCERR) == 0))
                return IRQ_NONE;

If this happens enough number of times, IRQ subsystem disables the
interrupt thinking its spurious which creates serious problems.

2.
If the above if statement condition is removed, then EMR is 0 so the
callback function will not be called in dma_ccerr_handler thus the event
is forgotten, never triggered manually or never sets missed flag of the
channel.

So about the race: TC interrupt handler executing before the error
interrupt handler can result in clearing the EMR and creates these problems.

>> The EMR is ultimately being cleared by the Error interrupt
>> handler once it is handled so we don't have to do it in edma_stop.
> 
> This, I agree with. edma_clean_channel() also there to re-initialize the
> channel so doing it in edma_stop() certainly seems superfluous.

Sure.

Thanks,

-Joel
