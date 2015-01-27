Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbbA0RmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:42:10 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50596 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbbA0RmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:42:07 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Felipe Balbi <balbi@ti.com>,
        Olof Johansson <olof@lixom.net>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] drivers: bus: Add Simple Power-Managed Bus
References: <1422288977-20353-1-git-send-email-geert+renesas@glider.be>
Date: Tue, 27 Jan 2015 09:42:03 -0800
In-Reply-To: <1422288977-20353-1-git-send-email-geert+renesas@glider.be>
	(Geert Uytterhoeven's message of "Mon, 26 Jan 2015 17:16:12 +0100")
Message-ID: <7htwzcyvbo.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert+renesas@glider.be> writes:

>         Hi all,
>
> The Renesas Bus State Controller (BSC) provides an external bus for
> connecting multiple external devices to an SoC, driving several chip
> select lines, for e.g. NOR FLASH, Ethernet and USB.
> On the kzm9g and ape6evm development boards, an smsc9220 Ethernet
> controller is connnected to the BSC of an SH-Mobile AG5 (sh73a0) resp.
> R-Mobile APE6 (r8a73a4) SoC.
>
> The BSC is a fairly simple memory-mapped bus, hence a "simple-bus"
> compatibility seems suitable.  However, the BSC is special in two
> ways:
>   1. It is part of a PM domain (A4S on sh73a0),
>   2. It has a gateable functional clock (ZB).
> Before a device connected to the BSC can be accessed, the PM domain
> containing the BSC must be powered on, and the functional clock
> driving the BSC must be enabled.
>
> Both special properties can be described in DT in a standardized way
> ("power-domains = <&pd_a4s>" and "clocks = <&zb_clk>", cfr. the
> example in the DT binding documentation).  Externally connected
> devices are described as children of the BSC node.
>
> Unfortunately this doesn't mean everything will work out-of-the-box.
> There are two problems:
>   1. Without a device driver bound to the bus device, this device is
>      not attached to the PM domain. And although a child device is
>      present and active, the PM domain may be powered down, as it's
>      considered unused by the PM domain core.
>   2. Without a device driver calling pm_runtime_enable(), its
>      functional clock is not enabled. Once runtime PM is enabled, the
>      R-Mobile PM domain platform driver manages the functional clock
>      using runtime PM.
>
> As none of the above is really bus hardware-specific (PM domains and
> functional clocks in clock domains are handled from genpd and platform
> code), this series adds a Simple Power-Managed Bus driver for
> transparent busses, which matches against "simple-pm-bus", enables
> runtime PM for the bus device, and calls of_platform_populate() to
> probe for child devices.
> Due to the child-parent relationship of devices connected to the bus,
> as long as the device drivers for the child devices are runtime PM
> enabled, the bus's PM domain will be powered, and the bus's clock will
> be enabled automatically when needed, for both runtime PM and s2ram.
>
> This was tested on sh73a0/kzm9g-multiplatform (by me), and (v3) on
> r8a73a4/ape6evm-multiplatform (by Ulrich Hecht). Without this,
> Ethernet doesn't work, as the ZB clock is disabled by
> clk_disable_unused().
>
> Felipe: It looks like drivers/usb/musb/musb_am335x.c can be removed, if
> "ti,am33xx-usb" claims compatibility with "simple-pm-bus"?
>
> As drivers/bus doesn't have a maintainer, and this driver is needed to
> move two shmobile platforms away from legacy to multiplatform, I think
> this can go in through Simon's shmobile tree.
>
> Changes compared to v3:
>   - Replace "simple-bus" by "simple-pm-bus" in the bindings,
>   - Move the "renesas,bsc" bindings to a separate document,
>   - Bind against the generic "simple-pm-bus" instead of "renesas,bsc",
>   - Explicitly call of_platform_populate() after pm_runtime_enable() to
>     enforce ordering, instead of depending on claimed compatibility with
>     "simple-bus".
>
> Changes compared to v2:
>   - Document required properties inherited from "simple-bus",
>   - Document required "reg" property for "renesas,bsc",
>   - Move "ranges" before "reg" in the example,
>   - Add Tested-by,
>   - Split-off sh73a0/kzm9g and r8a73a4/ape6evm DTS updates.
>
> Changes compared to v1 (more detailed change logs in the individual
> patches):
>   - Added sorting of drivers/bus Kconfig and Makefile entries,
>   - Added DT binding documentation,
>   - Rename from "Renesas Bus State Controller Driver" (renesas-bsc) to
>     "Simple Power-Managed Bus Driver" (simple-pm-bus),
>   - Postponed adding power-domains properties to the dtsi,
>   - Added updates for r8a73a4/ape6evm.
>
> Thanks for your comments!

Reviewed-by: Kevin Hilman <khilman@linaro.org>
