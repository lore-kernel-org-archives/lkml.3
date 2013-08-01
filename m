Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab3HAUtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:49:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49836 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab3HAUti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:49:38 -0400
Message-ID: <51FAC9B9.3050903@ti.com>
Date: Thu, 1 Aug 2013 15:48:57 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: <joelf@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Tony Lindgren <tony@atomide.com>,
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
Subject: Re: [PATCH 4/9] dma: edma: Find missed events and issue them
References: <1375104595-16018-1-git-send-email-joelf@ti.com> <1375104595-16018-5-git-send-email-joelf@ti.com> <51F7659E.3040302@ti.com> <51F89763.1010102@ti.com> <51F8D667.2040406@ti.com> <51F9C793.2000001@ti.com> <51F9FC87.3020706@ti.com> <51FAC50A.2020507@ti.com>
In-Reply-To: <51FAC50A.2020507@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some corrections here..

On 08/01/2013 03:28 PM, Joel Fernandes wrote:

>>> 2. If the interrupt handler for some reason doesn't complete or get
>>> service in time, we will end up DMA'ing incorrect data as events
>>> wouldn't stop coming in even if interrupt is not yet handled (in your
>>> example linked sets P1 or P2 would be old ones being repeated). Where as
>>> with my method, we are not doing any DMA once we finish the current
>>> MAX_NR_SG set even if events continue to come.
>>
>> Where is repetition and possibility of wrong data being transferred? We
>> have a linear list of PaRAM sets - not a loop. You would link the end to
>> PaRAM set chain to dummy PaRAM set which BTW will not cause missed
>> events. The more number of PaRAM sets you add to the chain, the more
> 
> There would have to be a loop, how else would you ensure continuity and
> uninterrupted DMA?
> 
> Consider if you have 2 sets of linked sets:
> L1 is the first set of Linked sets and L2 is the second.
> 
> When L1 is done, EDMA continues with L2 (due to the link) while
> interrupt handler prepares L1. The continuity depends on L1 being linked
> to L2. Only the absolute last break up of the MAX_NR_SG linked set will
> be linked to Dummy.
> 
> So consider MAX_NR_SG=10, and sg_len = 35
> 
> L1 - L2 - L1 - L1 - Dummy

Should be,
L1 - L2 - L1 - L2 - Dummy

> 
> The split would be in number of slots,
> 10 - 10 - 10 -  5 - Dummy
> 
>> time CPU gets to intervene before DMA eventually stalls. This is a
>> tradeoff system designers can manage.
> 
> Consider what happens in the case where MAX_SG_NR=1 or 2. In that case,
> there's a change we might not get enough time for the interrupt handler
> to setup next series of linked set.
> 
> Some how this limitation has to be overcome by advising in comments than
> MAX_SG_NR should always be greater than a certain number to ensure
> proper operation.

s/than/that/


Thanks,

-Joel

