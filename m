Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3KGMqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:46:52 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:63505 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3KGMqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:46:49 -0500
Message-ID: <527B8BB4.3050200@gmail.com>
Date: Thu, 07 Nov 2013 13:46:44 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Jisheng Zhang <jszhang@marvell.com>, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, linux@arm.linux.org.uk
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] ARM: l2x0: add prefetch and power ctrl registers configuration
 support
References: <1383800872-7982-1-git-send-email-jszhang@marvell.com>
In-Reply-To: <1383800872-7982-1-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/13 06:07, Jisheng Zhang wrote:
> PL310 supports Prefetch offset/control register from r2p0 and Power
> control register from r3p0. This patch adds the support to configure
> these two registers if there are. The dt binding document is also updated.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>   Documentation/devicetree/bindings/arm/l2cc.txt |  4 ++++
>   arch/arm/mm/cache-l2x0.c                       | 19 +++++++++++++++++++
>   2 files changed, 23 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
> index c0c7626..32cd08c 100644
> --- a/Documentation/devicetree/bindings/arm/l2cc.txt
> +++ b/Documentation/devicetree/bindings/arm/l2cc.txt
> @@ -39,6 +39,10 @@ Optional properties:
>   - arm,filter-ranges : <start length> Starting address and length of window to
>     filter. Addresses in the filter window are directed to the M1 port. Other
>     addresses will go to the M0 port.
> +- arm,prefetch-ctrl : The value for Prefetch Offset/Control Register if there
> +  is. This is a single cell.
> +- arm,pwr-ctrl : The value for Power Control Register if there is. This is a
> +  single cell.

Jisheng,

I did some research over L2x0/L310 aux-ctrl registers and possible
properties for them. Both properties introduced here, just allow you
to put in a magic number, while IMHO properties should better reflect
the actual function rather than hard-coded values.

A quick look at L310 TRM for Power Control Register gives:

Bit 1: dynamic_clk_gating_en (1=enabled, 0=masked)
Bit 0: standby mode en (1=enabled, 0=masked)

So, properties should one of:

(a) arm,dynamic-clock-gating = <0/1>
     arm,standby-mode = <0/1>
(b) arm,dynamic-clock-gating-enable/-disable;
     arm,standby-mode-enable/-disable

If we want to have set/clear/don't touch behavior, I'd prefer (a) as
it is easier to deal with in code. Moreover, -enable/-disable of (b)
may not always fit the property name, so there will also be
arm,no-feature-foo or arm,force-feature-bar.

The same also applies for Prefetch Control register, too.

Sebastian

>   - interrupts : 1 combined interrupt.
>   - cache-id-part: cache id part number to be used if it is not present
>     on hardware
> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index 447da6f..8f536ea 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -704,6 +704,8 @@ static void __init pl310_of_setup(const struct device_node *np,
>   	u32 data[3] = { 0, 0, 0 };
>   	u32 tag[3] = { 0, 0, 0 };
>   	u32 filter[2] = { 0, 0 };
> +	u32 l2x0_revision = readl_relaxed(l2x0_base + L2X0_CACHE_ID) &
> +		L2X0_CACHE_ID_RTL_MASK;
>
>   	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
>   	if (tag[0] && tag[1] && tag[2])
> @@ -730,6 +732,23 @@ static void __init pl310_of_setup(const struct device_node *np,
>   		writel_relaxed((filter[0] & ~(SZ_1M - 1)) | L2X0_ADDR_FILTER_EN,
>   			       l2x0_base + L2X0_ADDR_FILTER_START);
>   	}
> +
> +	if (l2x0_revision >= L2X0_CACHE_ID_RTL_R2P0) {
> +		u32 prefetch_ctrl = 0;
> +
> +		of_property_read_u32(np, "arm,prefetch-ctrl",
> +				     &prefetch_ctrl);
> +		if (prefetch_ctrl)
> +			writel_relaxed(prefetch_ctrl, l2x0_base +
> +					L2X0_PREFETCH_CTRL);
> +		if (l2x0_revision >= L2X0_CACHE_ID_RTL_R3P0) {
> +			u32 pwr_ctrl = 0;
> +			of_property_read_u32(np, "arm,pwr-ctrl", &pwr_ctrl);
> +			if (pwr_ctrl)
> +				writel_relaxed(pwr_ctrl, l2x0_base +
> +						L2X0_POWER_CTRL);
> +		}
> +	}
>   }
>
>   static void __init pl310_save(void)
>

