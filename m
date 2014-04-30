Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946142AbaD3V3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:29:06 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:50441 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964975AbaD3V3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:29:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core
Date: Wed, 30 Apr 2014 23:29:17 +0200
Message-ID: <4116377.A5MWbYX2Mh@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Thursday 24 April 2014 12:13:19 Geert Uytterhoeven wrote:
> On SoCs like ARM/SH-mobile, gate clocks are available for modules, allowing
> Runtime PM for a device controlled by a gate clock.
> 
> On legacy shmobile kernels, this is handled by the PM runtime code in
> drivers/sh/pm_runtime.c, which installs a clock notifier for the platform
> bus, registering the "NULL" clock of each platform device with the PM core.
> This approach is also used on davinci, keystone, and omap1.

This requires the device to have the MSTP clock defined as the first clock in 
its DT node. I'm not against that, but the requirement should be clearly 
documented, and we need to check existing DT bindings to make sure they comply 
with that.

I'd like to also take this as an opportunity to discuss how we should name 
clocks in DT bindings for Renesas devices. Most devices have a single MSTP 
clock, in which case we don't specify a name. Other devices need several 
clocks. Names for the non-MSTP clocks will obviously be device-dependent, but 
how should the MSTP clock be called in that time ? Should it have an empty 
name (a "" string in DT) ? Should it have a standard name ? Maybe "fck" for 
"functional clock" ?

> On multi-platform shmobile kernels, this was not handled at all, leading
> to spurious disabled clocks on drivers relying on Runtime PM, depending on
> implicit reset state, or on the bootloader.
> 
> A first solution, enabling the PM runtime code in drivers/sh/pm_runtime.c
> in a multi-platform-safe way, was provided by the patch series
> "[PATCH v2 00/17] ARM: shmobile: Enable drivers/sh/pm_runtime.c on
> multi-platform" (http://www.spinics.net/lists/linux-sh/msg30887.html).
> 
> Here is an alternative approach, avoiding the reliance on C board files,
> which are being phased out.
> 
> This is also related to a patch series by Felipe Balbi ("[RFC/PATCH] base:
> platform: add generic clock handling for platform-bus",
> https://lkml.org/lkml/2014/1/31/290)
> 
> This series:
>   1. Lets the MSTP clock driver indicate that its clocks are suitable for
>      Runtime PM,
>   2. Lets the DT code retrieve clock information when adding a device
>      (it already retrieves information for resources (registers, irq) ---
>      unfortunately clocks are not resources), and registering clocks
>      suitable for Runtime PM with the PM core.
>      If Runtime PM is disabled, the clocks are just enabled.
> 
> Note that this works for devices instantiated from DT only.
> Fortunately the drivers for the remaining platform devices (SCI and CMT)
> handle clocks theirselves, without Runtime PM, so they get properly enabled.
> 
> Patches:
>   - [1/4] clk: Add CLK_RUNTIME_PM and clk_may_runtime_pm()
>   - [2/4] PM / clock_ops: Add pm_clk_add_clk()
>   - [3/4] of/clk: Register clocks suitable for Runtime PM with the
>   - [4/4] clk: shmobile: mstp: Set CLK_RUNTIME_PM flag
> 
> This series was tested on Renesas r8a7791, using the Koelsch development
> board.

-- 
Regards,

Laurent Pinchart

