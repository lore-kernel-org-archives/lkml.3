Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaEETvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:51:52 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35842 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753249AbaEETvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:51:49 -0400
Date: Mon, 5 May 2014 20:50:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 5/7] ARM: dma: Use dma_pfn_offset for dma address
	translation
Message-ID: <20140505195040.GE3693@n2100.arm.linux.org.uk>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <1398353407-2345-6-git-send-email-santosh.shilimkar@ti.com> <20140502145852.GC3693@n2100.arm.linux.org.uk> <5363B42C.4010404@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5363B42C.4010404@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 11:05:16AM -0400, Santosh Shilimkar wrote:
> On Friday 02 May 2014 10:58 AM, Russell King - ARM Linux wrote:
> > On Thu, Apr 24, 2014 at 11:30:05AM -0400, Santosh Shilimkar wrote:
> >>  static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
> >>  {
> >> -	return (void *)__bus_to_virt((unsigned long)addr);
> >> +	if (!dev)
> >> +		return (void *)__bus_to_virt((unsigned long)addr);
> >> +	else
> >> +		return (void *)__bus_to_virt(__pfn_to_bus(dma_to_pfn(dev, addr)));
> > 
> > This is quite horrendous.  There's easier ways to do this...  I assume
> > you haven't looked at the assembler resulting from this at all with
> > stuff like the p2v patching enabled?
> > 
> I haven't. Will check.

	if (dev) {
		unsigned long pfn = dma_to_pfn(dev, addr);

		return phys_to_virt(__pfn_to_phys(pfn));
	}

	return (void *)__bus_to_virt((unsigned long)addr);

> >>  static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
> >>  {
> >> -	return (dma_addr_t)__virt_to_bus((unsigned long)(addr));
> >> +	if (!dev)
> >> +		return (dma_addr_t)__virt_to_bus((unsigned long)(addr));
> >> +	else
> >> +		return pfn_to_dma(dev,
> >> +				__bus_to_pfn(__virt_to_bus((unsigned long)(addr))));
> > 
> > Same here.
> > 
> ok.


	if (dev)
		return pfn_to_dma(dev, virt_to_pfn(addr));

	return (dma_addr_t)__virt_to_bus((unsigned long)(addr));

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
