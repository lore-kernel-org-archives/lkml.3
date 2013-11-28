Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab3K1Dlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 22:41:31 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40282 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756119Ab3K1Dl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 22:41:27 -0500
Date: Thu, 28 Nov 2013 11:38:45 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: l2x0: add prefetch and power ctrl registers
 configuration support
Message-ID: <20131128113845.27d0176b@xhacker>
In-Reply-To: <20131127174204.GD27879@e106331-lin.cambridge.arm.com>
References: <1383800872-7982-1-git-send-email-jszhang@marvell.com>
	<20131127174204.GD27879@e106331-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.72,1.0.14,0.0.0000
 definitions=2013-11-28_02:2013-11-28,2013-11-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311270231
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, 27 Nov 2013 09:42:04 -0800
Mark Rutland <mark.rutland@arm.com> wrote:

> On Thu, Nov 07, 2013 at 05:07:52AM +0000, Jisheng Zhang wrote:
> > PL310 supports Prefetch offset/control register from r2p0 and Power
> > control register from r3p0. This patch adds the support to configure
> > these two registers if there are. The dt binding document is also updated.
> 
> I'd like to see a reasoning as to _why_ these should be in the DT.
> 
> While we have tag and data RAM latency information, those are hardware
> properties that we cannot probe. I'm not so clear on the filter-ranges
> property.
> 
> These bits seem to be configuration rather than a hardware description.
> If there are some portions of this that we can describe with higher
> level properties, I'd prefer to do that.
> 
> But primarily, the question to answer is do we need these, and if so do
> they belong in the DT?


After more consideration, configuring these two registers in bootloader or
TrustZone firmware is more reasonable since the prefetch controller can only be
written in Secure World.

PS: the tag/ram latency must also be written in secure world, and IMHO, the
latency and filter-ranges are also configurations

Thanks for having look at this patch,
Jisheng

> 
> > 
> > Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> > ---
> >  Documentation/devicetree/bindings/arm/l2cc.txt |  4 ++++
> >  arch/arm/mm/cache-l2x0.c                       | 19 +++++++++++++++++++
> >  2 files changed, 23 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt
> > b/Documentation/devicetree/bindings/arm/l2cc.txt index c0c7626..32cd08c
> > 100644 --- a/Documentation/devicetree/bindings/arm/l2cc.txt
> > +++ b/Documentation/devicetree/bindings/arm/l2cc.txt
> > @@ -39,6 +39,10 @@ Optional properties:
> >  - arm,filter-ranges : <start length> Starting address and length of
> > window to filter. Addresses in the filter window are directed to the M1
> > port. Other addresses will go to the M0 port.
> > +- arm,prefetch-ctrl : The value for Prefetch Offset/Control Register if
> > there
> > +  is. This is a single cell.
> > +- arm,pwr-ctrl : The value for Power Control Register if there is. This
> > is a
> > +  single cell.
> >  - interrupts : 1 combined interrupt.
> >  - cache-id-part: cache id part number to be used if it is not present
> >    on hardware
> > diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> > index 447da6f..8f536ea 100644
> > --- a/arch/arm/mm/cache-l2x0.c
> > +++ b/arch/arm/mm/cache-l2x0.c
> > @@ -704,6 +704,8 @@ static void __init pl310_of_setup(const struct
> > device_node *np, u32 data[3] = { 0, 0, 0 };
> >  	u32 tag[3] = { 0, 0, 0 };
> >  	u32 filter[2] = { 0, 0 };
> > +	u32 l2x0_revision = readl_relaxed(l2x0_base + L2X0_CACHE_ID) &
> > +		L2X0_CACHE_ID_RTL_MASK;
> >  
> >  	of_property_read_u32_array(np, "arm,tag-latency", tag,
> > ARRAY_SIZE(tag)); if (tag[0] && tag[1] && tag[2])
> > @@ -730,6 +732,23 @@ static void __init pl310_of_setup(const struct
> > device_node *np, writel_relaxed((filter[0] & ~(SZ_1M - 1)) |
> > L2X0_ADDR_FILTER_EN, l2x0_base + L2X0_ADDR_FILTER_START);
> >  	}
> > +
> > +	if (l2x0_revision >= L2X0_CACHE_ID_RTL_R2P0) {
> > +		u32 prefetch_ctrl = 0;
> > +
> > +		of_property_read_u32(np, "arm,prefetch-ctrl",
> > +				     &prefetch_ctrl);
> > +		if (prefetch_ctrl)
> > +			writel_relaxed(prefetch_ctrl, l2x0_base +
> > +					L2X0_PREFETCH_CTRL);
> 
> Some of the prefetch control regsiter bits are reserved, and the
> prefetch offset may only take a subset of possible values. I wouldn't
> want to poke the hardware without performing some sanity checking on
> these values.
> 
> > +		if (l2x0_revision >= L2X0_CACHE_ID_RTL_R3P0) {
> > +			u32 pwr_ctrl = 0;
> > +			of_property_read_u32(np, "arm,pwr-ctrl",
> > &pwr_ctrl);
> > +			if (pwr_ctrl)
> > +				writel_relaxed(pwr_ctrl, l2x0_base +
> > +						L2X0_POWER_CTRL);
> 
> Similarly, all but the lower 2 bits are reserved...
> 
> Thanks,
> Mark.

