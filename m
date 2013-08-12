Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3HLE0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 00:26:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43334 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab3HLE0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 00:26:11 -0400
Message-ID: <5208639F.8070406@ti.com>
Date: Mon, 12 Aug 2013 09:55:03 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Mark Brown <broonie@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sricharan R <r.sricharan@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Chris Ball <cjb@laptop.org>, Arnd Bergmann <arnd@arndb.de>,
        Rajendra Nayak <rnayak@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Balaji TK <balajitk@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dan Williams <djbw@fb.com>, Olof Johansson <olof@lixom.net>,
        Benoit Cousson <benoit.cousson@linaro.org>
Subject: Re: [PATCH v3 02/12] ARM: edma: Don't clear EMR of channel in edma_stop
References: <1375719297-12871-1-git-send-email-joelf@ti.com> <1375719297-12871-3-git-send-email-joelf@ti.com> <520385D3.1060408@ti.com>
In-Reply-To: <520385D3.1060408@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/2013 5:19 PM, Sekhar Nori wrote:
> On Monday 05 August 2013 09:44 PM, Joel Fernandes wrote:
>> We certainly don't want error conditions to be cleared any other
>> place but the EDMA error handler, as this will make us 'forget'
>> about missed events we might need to know errors have occurred.
>>
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
>>
>> This causes the following  problems:
>>
>> 1.
>> If error interrupt is also pending and TC interrupt clears the EMR
>> by calling edma_stop as has been observed in the edma_callback function,
>> the ARM will execute the error interrupt even though the EMR is clear.
>> As a result, the  dma_ccerr_handler returns IRQ_NONE. If this happens
>> enough number of times, IRQ subsystem disables the interrupt thinking
>> its spurious which makes error handler never execute again.
>>
>> 2.
>> Also even if error handler doesn't return IRQ_NONE, the removing of EMR
>> removes the knowledge about which channel had a missed event, and thus
>> a manual trigger on such channels cannot be performed.
>>
>> The EMR is ultimately being cleared by the Error interrupt handler
>> once it is handled so we remove code that does it in edma_stop and
>> allow it to happen there.
>>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
> 
> Queuing this for v3.11 fixes. While committing, I changed the headline
> to remove capitalization and made it more readable by removing register
> level details. The new headline is:
> 
> ARM: edma: don't clear missed events in edma_stop()

Forgot to ask, should this be tagged for stable? IOW, how serious is
this race in current kernel (without the entire series applied)? I have
never observed it myself - so please provide details how easy/difficult
it is to hit this condition.

Thanks,
Sekhar
