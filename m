Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3LDIJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:09:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43655 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3LDIJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:09:10 -0500
Message-ID: <529EE305.70001@ti.com>
Date: Wed, 4 Dec 2013 13:38:37 +0530
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Subject: Re: [PATCH] ARM: OMAP2+: omap_device: add fail hook for runtime_pm
 when bad data is detected
References: <1386121153-32351-1-git-send-email-nm@ti.com>
In-Reply-To: <1386121153-32351-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 07:09 AM, Nishanth Menon wrote:
> Due to the cross dependencies between hwmod for automanaged device
> information for OMAP and dts node definitions, we can run into scenarios
> where the dts node is defined, however it's hwmod entry is yet to be
> added. In these cases:
> a) omap_device does not register a pm_domain (since it cannot find
>    hwmod entry).
> b) driver does not know about (a), does a pm_runtime_get_sync which
>    never fails
> c) It then tries to do some operation on the device (such as read the
>   revision register (as part of probe) without clock or adequate OMAP
>   generic PM operation performed for enabling the module.
> 
> This causes a crash such as that reported in:
> https://bugzilla.kernel.org/show_bug.cgi?id=66441
> 
> When 'ti,hwmod' is provided in dt node, it is expected that the device
> will not function without the OMAP's power automanagement. Hence, when
> we hit a fail condition (due to hwmod entries not present or other
> similar scenario), fail at pm_domain level due to lack of data, provide
> enough information for it to be fixed, however, it allows for the driver
> to take appropriate measures to prevent crash.
> 
> Reported-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  arch/arm/mach-omap2/omap_device.c |   24 ++++++++++++++++++++++++
>  arch/arm/mach-omap2/omap_device.h |    1 +
>  2 files changed, 25 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
> index 53f0735..e0a398c 100644
> --- a/arch/arm/mach-omap2/omap_device.c
> +++ b/arch/arm/mach-omap2/omap_device.c
> @@ -183,6 +183,10 @@ static int omap_device_build_from_dt(struct platform_device *pdev)
>  odbfd_exit1:
>  	kfree(hwmods);
>  odbfd_exit:
> +	/* if data/we are at fault.. load up a fail handler */
> +	if (ret)
> +		pdev->dev.pm_domain = &omap_device_fail_pm_domain;
> +
>  	return ret;
>  }
>  

Just wondering, can't we just print the warning here instead of registering new
pm_domain callbacks?

Concerned that all this LOC may end up being dead code when the "ti,hwmods"
property becomes obsolete anyway.

-Joel
