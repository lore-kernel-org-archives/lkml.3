Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160999AbaDSQZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 12:25:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37762 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751453AbaDSQZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 12:25:37 -0400
Date: Sat, 19 Apr 2014 18:25:28 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Gregory =?UTF-8?B?Q2zDqW1lbnQ=?= 
	<gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>
Subject: Re: [PATCH v2 0/7] of: setup dma parameters using dma-ranges and
 dma-coherent
Message-ID: <20140419182528.414b9b2e@skate>
In-Reply-To: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Santosh Shilimkar,

On Sat, 19 Apr 2014 10:32:45 -0400, Santosh Shilimkar wrote:
> Here is an updated version of [2] based on discussion. Series introduces
> support for setting up dma parameters based on device tree properties
> like 'dma-ranges' and 'dma-coherent' and also update to ARM 32 bit port.
> Earlier version of the same series is here [1].
> 
> The 'dma-ranges' helps to take care of few DMAable system memory restrictions
> by use of dma_pfn_offset which we maintain now per device. Arch code then
> uses it for dma address translations for such cases. We update the
> dma_pfn_offset accordingly during DT the device creation process.The
> 'dma-coherent' property is used to setup arch's coherent dma_ops.
> 
> After some off-list discussion with RMK and Arnd, I have now dropped the
> controversial dma_mask setup code from the series which actually isn't blocking
> me as such. Considering rest of the parts of the series are already aligned,
> am hoping to get this version merged for 3.16 merge window.
> 
> We agreed in last discussion that drivers have the ultimate
> responsibility to setup the correct dma mask but then we need to have some
> means to see if bus can support what driver has requested for a case where
> driver request for bigger mask than what bus supports. I can follow up on
> the mask topic if we have broken drivers.

I am not sure whether there is an intersection or not, but I wanted to
mention that the mvebu platform (in mach-mvebu) supports hardware I/O
coherency, which makes it a coherent DMA platform. However, we are not
able to use arm_coherent_dma_ops for this platform, because when a
transfer is being made DMA_FROM_DEVICE, at the end of the transfer, we
need to perform an I/O barrier to wait for the snooping unit to
complete its coherency work. So we're coherent, but not with
arm_coherent_dma_ops: we have our own dma operation implementation (see
arch/arm/mach-mvebu/coherency.c).

However, it seems that your patch series, at least in PATCH 6/7 makes
the assumption that for all DMA coherent platforms,
arm_coherent_dma_ops is going to be OK.

Also, I haven't followed all the discussions, but what is the intended
usage of of_dma_is_coherent() and set_arch_dma_coherent_ops() (device
drivers? platform code?).

In mach-mvebu, what we do is that we register a bus notifier on the
platform bus, so that we can set our custom DMA operations for all
platform devices in the system. Should this be done in a different way
after your series?

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
