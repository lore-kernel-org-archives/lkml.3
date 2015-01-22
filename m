Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbbAVCol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:44:41 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:59085 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbbAVCoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:44:32 -0500
Date: Thu, 22 Jan 2015 11:44:27 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/4] drivers: bus: Add Simple Power-Managed Bus
Message-ID: <20150122024425.GD31170@verge.net.au>
References: <1420809155-4015-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420809155-4015-1-git-send-email-geert+renesas@glider.be>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 02:12:31PM +0100, Geert Uytterhoeven wrote:
> 	Hi Simon, Magnus,
> 
> The Renesas Bus State Controller (BSC) provides an external bus for
> connecting multiple external devices to an SoC, driving several chip
> select lines, for e.g. NOR FLASH, Ethernet and USB.
> On the kzm9g and ape6evm development boards, an smsc9220 Ethernet
> controller is connnected to the BSC of an SH-Mobile AG5 (sh73a0) resp.
> R-Mobile APE6 (r8a73a4) SoC.

For the record: Olof has asked for review comments for these patches
so I have dropped them from next pending that activity.

> The BSC is a fairly simple memory-mapped bus, hence a "simple-bus"
> compatibility seems suitable.  However, the BSC is special in two
> ways:
>   1. It is part of a PM domain (A4S),
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
> transparent busses, which just enables runtime PM for the bus device.
> Due to the child-parent relationship of devices connected to the bus,
> as long as the device drivers for the child devices are runtime PM
> enabled, the bus's PM domain will be powered, and the bus's clock will
> be enabled automatically when needed, for both runtime PM and s2ram.
> 
> Currently this driver supports the Renesas Bus State Controller only,
> but support for other SoCs and other bus controllers can easily be
> added later by adding more compatible values.
> Note that this driver cannot just bind against "simple-bus", as that
> may prevent a device-specific driver from taking precedence.
> 
> This was tested on sh73a0/kzm9g-multiplatform (by me), and on
> r8a73a4/ape6evm-multiplatform (by Ulrich Hecht). Without this,
> Ethernet doesn't work, as the ZB clock is disabled by
> clk_disable_unused().
> 
> As drivers/bus doesn't have a maintainer, and this driver is needed to
> move two shmobile platforms away from legacy to multiplatform, I think
> this can go in through Simon's shmobile tree.  There are no conflicts
> with today's linux-next.
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
> Thanks for applying!
> 
> Geert Uytterhoeven (4):
>   drivers: bus: Sort Kconfig entries alphabetically
>   drivers: bus: Sort Makefile entries alphabetically
>   drivers: bus: Add Simple Power-Managed Bus DT Bindings
>   drivers: bus: Add Simple Power-Managed Bus Driver
> 
>  .../devicetree/bindings/bus/simple-pm-bus.txt      | 52 +++++++++++++++++++++
>  drivers/bus/Kconfig                                | 53 ++++++++++++++--------
>  drivers/bus/Makefile                               | 15 +++---
>  drivers/bus/simple-pm-bus.c                        | 51 +++++++++++++++++++++
>  4 files changed, 144 insertions(+), 27 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/bus/simple-pm-bus.txt
>  create mode 100644 drivers/bus/simple-pm-bus.c
> 
> -- 
> 1.9.1
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> 
