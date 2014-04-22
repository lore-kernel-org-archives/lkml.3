Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbaDVPQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:16:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44747 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbaDVPQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:16:39 -0400
Message-ID: <535687A5.2070105@ti.com>
Date: Tue, 22 Apr 2014 11:15:49 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>,
        =?ISO-8859-1?Q?Gregory_Cl=E9ment?= 
	<gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>
Subject: Re: [PATCH v2 0/7] of: setup dma parameters using dma-ranges and
 dma-coherent
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com> <20140419182528.414b9b2e@skate> <201404221702.19842.arnd@arndb.de>
In-Reply-To: <201404221702.19842.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2014 11:02 AM, Arnd Bergmann wrote:
> On Saturday 19 April 2014, Thomas Petazzoni wrote:
>>
>> I am not sure whether there is an intersection or not, but I wanted to
>> mention that the mvebu platform (in mach-mvebu) supports hardware I/O
>> coherency, which makes it a coherent DMA platform. However, we are not
>> able to use arm_coherent_dma_ops for this platform, because when a
>> transfer is being made DMA_FROM_DEVICE, at the end of the transfer, we
>> need to perform an I/O barrier to wait for the snooping unit to
>> complete its coherency work. So we're coherent, but not with
>> arm_coherent_dma_ops: we have our own dma operation implementation (see
>> arch/arm/mach-mvebu/coherency.c).
> 
> I had completely missed the fact that this support was merged already.
> 
> It's an interesting question if this should actually be called
> 'coherent' or not. It's certainly more coherent than without that
> support, but then again, you still can't rely on incoming data to
> be visible after a readl() from the device has returned or an MSI
> interrupt has been delivered, which is what we normally expect.
> 
> In particular, it means you can't really use arm_coherent_dma_alloc(),
> which is a shame, since that is a significante performance overhead.
> 
> I would hope we can find a way to avoid the platform notifiers for
> mvebu as well and come up with a generic way to express this
> 'semi-coherent' mode. I believe x-gene has a similar issue, and
> I wouldn't be surprised if there are others like this.
> 
As Catalin already pointed out, the mvebu issue really the barrier
than dma coherency. Infact for all the correct operations, they
need the __io_*mb() to be patched up same way as we patched up
the outer_sync() for Cortex-A9 implementation. With that in place
and the other dma streaming barrier patch [1] I posted, mvebu
case should work.

I don't think, the 'semi-coherent' makes much sense because
you can many parameters influencing that. Thanks to per
device property, we already do say" PCIE is not cohenernt
but USB, NETWORK drivers are on same SOC". Anything beyond
that will be non-scalable and won't be generic enough.

[1] http://www.spinics.net/lists/arm-kernel/msg324109.html


