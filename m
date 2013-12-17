Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab3LQLxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:53:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55238 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab3LQLxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:53:06 -0500
Date: Tue, 17 Dec 2013 11:51:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, mark.rutland@arm.com,
        s.hauer@pengutronix.de, galak@codeaurora.org, swarren@wwwdotorg.org,
        t.figa@samsung.com, grant.likely@linaro.org, matt.porter@linaro.org,
        rob@landley.net, tomasz.figa@gmail.com, ian.campbell@citrix.com,
        pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv7 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20131217115136.GT4360@n2100.arm.linux.org.uk>
References: <1386925027-16288-1-git-send-email-Li.Xiubo@freescale.com> <1386925027-16288-2-git-send-email-Li.Xiubo@freescale.com> <20131217111020.GF13823@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217111020.GF13823@ulmo.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 12:10:22PM +0100, Thierry Reding wrote:
> On Fri, Dec 13, 2013 at 04:57:04PM +0800, Xiubo Li wrote:
> > +static inline u32 fsl_pwm_readl(struct fsl_pwm_chip *fpc,
> > +		const void __iomem *addr)
> > +{
> > +	u32 val;
> > +
> > +	val = __raw_readl(addr);
> > +
> > +	if (likely(fpc->big_endian))
> 
> The likely() probably isn't very useful in this case. But if you want to
> keep it, it should at least be reversed, since little-endian is actually
> the default (you have to specify the big-endian property to activate the
> big endian mode).
> 
> > +		val = be32_to_cpu(val);
> > +	else
> > +		val = le32_to_cpu(val);

This will also cause sparse errors, because when sparse is enabled, these
expect __le32 or __be32 arguments, not u32.

> > +	rmb();
> 
> I'd prefer the rmb() to follow the __raw_readl() immediately to make the
> relationship more explicit.

A better question to ask is: why is this barrier here?  What memory
ordering operations is it trying to serialise?

> > +static inline void fsl_pwm_writel(struct fsl_pwm_chip *fpc,
> > +		u32 val, void __iomem *addr)
> > +{
> > +	wmb();
> > +	if (likely(fpc->big_endian))
> > +		val = cpu_to_be32(val);
> > +	else
> > +		val = cpu_to_le32(val);
> > +
> > +	__raw_writel(val, addr);
> 
> Same here. wmb() should precede __raw_writel() immediately.

Same comments here - what memory operations is the wmb() trying to
serialise?  Does this PWM driver somehow end up doing DMA?
