Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaENTeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:34:21 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59257 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaENTeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:34:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, marc.ceeeee@gmail.com,
        computersforpeace@gmail.com, gregory.0xf0@gmail.com,
        Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Huang Shijie <b32955@freescale.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/3] bus: add Broadcom GISB arbiter bus timeout/error handler
Date: Wed, 14 May 2014 21:33:51 +0200
Message-ID: <8057197.5nM8JDA8pQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400094649-11193-2-git-send-email-f.fainelli@gmail.com>
References: <1400094649-11193-1-git-send-email-f.fainelli@gmail.com> <1400094649-11193-2-git-send-email-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:s6U+gAxH26GYuFg2xICHeylyhikepkmAMe2NtlOVfLw
 1ozkrnjRj14FWxEWhQuEA2TG1VEmys+s1OhuSLLzKfLgIXwASW
 MrnvyplEZKIvtrJKg2KKYZnNDmIiUO8oML49a6gbycGIkE3ByX
 7HSf9E+S/n6djGKlfEPyjqbSvIUjXynsSP04PZuF5R6BDt3kIy
 oc+7ZjTHKVt84Qi/XI3BbZwS6KreQ7F0xB5FE7ucEWTMIZZLKm
 OWmRxe+Cb1rubW7WVmU61QYBEySCmA0+I6B6SWPZ0jot35xuUO
 vD5eSIq4sMc2EE8RQExlakbunU8Pv08e0mUauGmX6xwF6X2O+H
 STC0J/zwB13M9A7QIBXA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 12:10:46 Florian Fainelli wrote:
> This patch adds support for the Broadcom GISB arbiter bus timeout/error
> handler. GISB is a proprietary bus used by Broadcom Set Top Box
> System-on-a-chip devices (BCM7xxx) which allows multiple masters and
> clients to be interfaced with each other.
> 
> The bus arbiter offers support for generating two interrupts towards the
> host CPU, thus allowing us to "catch" clock gated masters, or masters
> being volontarily blocked for powersaving purposes, or do general system
> troubleshooting.
> 
> We also register a hook with the ARM fault exception handling to allow
> printing a more informative message than "imprecise external abort at
> 0x00000000" for instance.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Looks pretty good to me.

> +static int brcmstb_gisb_arb_decode_addr(struct brcmstb_gisb_arb_device *gdev,
> +					const char *reason)
> +{
> +	u32 cap_status;
> +	unsigned long arb_addr;
> +	u32 master;
> +	const char *m_name;
> +	char m_fmt[11];
> +
> +	cap_status = ioread32(gdev->base + ARB_ERR_CAP_STATUS);
> +
> +	/* Invalid captured address, bail out */
> +	if (!(cap_status & ARB_ERR_CAP_STATUS_VALID))
> +		return 1;
> +
> +	/* Read the address and master */
> +	arb_addr = ioread32(gdev->base + ARB_ERR_CAP_ADDR) & 0xffffffff;
> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
> +	arb_addr |= (u64)ioread32(gdev->base + ARB_ERR_CAP_HI_ADDR) << 32;
> +#endif

Can you use 'if (IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))' here, or does that
cause a warning?

> +static int brcmstb_bus_error_handler(unsigned long addr, unsigned int fsr,
> +				     struct pt_regs *regs)
> +{
> +	int ret = 0;
> +	struct brcmstb_gisb_arb_device *gdev;
> +
> +	/* iterate over each GISB arb registered handlers */
> +	list_for_each_entry(gdev, &brcmstb_gisb_arb_device_list, next)
> +		ret |= brcmstb_gisb_arb_decode_addr(gdev, "bus error");
> +	/*
> +	 * If it was an imprecise abort, then we need to correct the
> +	 * return address to be _after_ the instruction.
> +	*/
> +	if (fsr & (1 << 10))
> +		regs->ARM_pc += 4;
> +
> +	return ret;
> +}

This will cause the normal abort handler to trigger if the GISB
arbiter doesn't know what happened, right?

	Arnd

