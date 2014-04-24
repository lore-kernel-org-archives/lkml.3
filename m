Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaDXKNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:13:52 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:60363 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbaDXKNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:13:41 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core
Date: Thu, 24 Apr 2014 12:13:19 +0200
Message-Id: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On SoCs like ARM/SH-mobile, gate clocks are available for modules, allowing
Runtime PM for a device controlled by a gate clock.

On legacy shmobile kernels, this is handled by the PM runtime code in
drivers/sh/pm_runtime.c, which installs a clock notifier for the platform
bus, registering the "NULL" clock of each platform device with the PM core.
This approach is also used on davinci, keystone, and omap1.

On multi-platform shmobile kernels, this was not handled at all, leading
to spurious disabled clocks on drivers relying on Runtime PM, depending on
implicit reset state, or on the bootloader.

A first solution, enabling the PM runtime code in drivers/sh/pm_runtime.c
in a multi-platform-safe way, was provided by the patch series
"[PATCH v2 00/17] ARM: shmobile: Enable drivers/sh/pm_runtime.c on
multi-platform" (http://www.spinics.net/lists/linux-sh/msg30887.html).

Here is an alternative approach, avoiding the reliance on C board files,
which are being phased out.

This is also related to a patch series by Felipe Balbi ("[RFC/PATCH] base:
platform: add generic clock handling for platform-bus",
https://lkml.org/lkml/2014/1/31/290)

This series:
  1. Lets the MSTP clock driver indicate that its clocks are suitable for
     Runtime PM, 
  2. Lets the DT code retrieve clock information when adding a device
     (it already retrieves information for resources (registers, irq) ---
     unfortunately clocks are not resources), and registering clocks
     suitable for Runtime PM with the PM core.
     If Runtime PM is disabled, the clocks are just enabled.

Note that this works for devices instantiated from DT only.
Fortunately the drivers for the remaining platform devices (SCI and CMT)
handle clocks theirselves, without Runtime PM, so they get properly enabled.

Patches:
  - [1/4] clk: Add CLK_RUNTIME_PM and clk_may_runtime_pm()
  - [2/4] PM / clock_ops: Add pm_clk_add_clk()
  - [3/4] of/clk: Register clocks suitable for Runtime PM with the
  - [4/4] clk: shmobile: mstp: Set CLK_RUNTIME_PM flag

This series was tested on Renesas r8a7791, using the Koelsch development
board.

Thanks for your comments!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
