Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaIYQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:29:25 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:51789 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaIYQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:28:55 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 00/13] ARM: shmobile: R-Mobile: DT PM domain support
Date: Thu, 25 Sep 2014 18:28:27 +0200
Message-Id: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Rafael, Simon, Magnus,

This patch series enables DT support for PM domains on Renesas R-Mobile SoCs.

Currently it's limited to R-Mobile A1 (r8a7740), but given the similarity of
the SYSC System-Controller on the various SH-Mobile/R-Mobile SoCs, and the
abstraction of PM domains in DT, it should be sufficiently generic to handle
other SoCs in the future (e.g. SH-Mobile AP4 (sh7372), SH-Mobile AG5 (sh73a0),
R-Mobile APE6 (r8a73a4)).

Changes compared to v2 (more detailed changelogs in the individual patches):
  - Minor changes to attach/detach callbacks,
  - Really add the A4MP and D4 PM domains, as fixes are available (see
    dependencies below),
  - Scan DT topology to identify special PM domains (CPUs and console),
  - Move PM domain power-on/off latencies to a separate patch.

Changes compared to v1 (more detailed changelogs in the individual patches):
  - Several new patches: PM QoS device latencies in DT, attach/detach
    callbacks,
  - Run-Time management of the module clocks, making the hack in
    drivers/sh/pm_runtime.c obsolete for DT platforms using genpd,
  - Addition of PM QoS device latencies, specified from DT,
  - Addition of build glue, so this builds and runs without additional
    changes, incl. s2ram.

This means that functionality-wise, the DT version is now on par with the
legacy version ("[PATCH v2 00/11] ARM: shmobile: r8a7740/armadillo800eva legacy
PM domain support").

Dependencies:
  - Simon Horman's renesas-devel-20140924-v3.17-rc6,
  - Rafael J. Wysocki's linux-pm.git#linux-next,
  - Jason Cooper's linux.git#irqchip/for-next.
  - "ARM: shmobile: R-Mobile: Store SYSC base address in rmobile_pm_domain"
    depends on the legacy version of this series, but if the legacy version
    will never be accepted, the conflicts are trivial to resolve (drop changes
    to non-existing PM domains),
  - Working resume from s2ram depends on:
      - "[PATCH/RFC] fbdev: sh_mobile_hdmi: Re-init regs before irq re-enable
	on resume",
      - "[PATCH] ARM: hw_breakpoint: Trap undef instruction exceptions on
	wake-up", or an alternative solution.
  - Working "no_console_suspend" handling depends on "[PATCH 06/13] ARM:
    shmobile: armadillo800eva dts: Add chosen/stdout-path".

For your convenience, I've also pushed this (incl. its dependencies) to
git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git#rmobile-genpd

Rafael: If you accept "PM / Domains: Add genpd attach/detach callbacks", it
would be good to get this patch in v3.18-rc1, as it's the only hard dependency
on linux-pm.git for the rest of this series. The other parts have relaxed
ordering constraints due to the separation of code and DTS.

Question: Can we use the preliminary PM domain power-on/off and QoS device
latencie patches (the last 2) as-is, or should we refine them first?

Thanks!

Geert Uytterhoeven (13):
  PM / Domains: Add genpd attach/detach callbacks
  PM / Domains: Add DT bindings for power-on/off latencies
  PM / Domains: Add DT bindings for PM QoS device latencies
  PM / Domains: Add DT bindings for the R-Mobile System Controller
  PM / Domains: Add helper variable np = dev->of_node
  PM / Domains: Retrieve PM QoS device latencies from DT
  ARM: shmobile: R-Mobile: Use generic_pm_domain.attach_dev() for pm_clk
    setup
  ARM: shmobile: R-Mobile: Store SYSC base address in rmobile_pm_domain
  ARM: shmobile: R-Mobile: Add DT support for PM domains
  ARM: shmobile: r8a7740 dtsi: Add PM domain support
  drivers: sh: Disable PM runtime for multi-platform r8a7740 with genpd
  ARM: shmobile: r8a7740 dtsi: Add preliminary PM domain latencies
  ARM: shmobile: r8a7740 dtsi: Add preliminary PM QoS device latencies

 .../devicetree/bindings/power/power_domain.txt     |  16 ++
 .../bindings/power/renesas,sysc-rmobile.txt        | 111 +++++++++
 arch/arm/boot/dts/r8a7740.dtsi                     | 257 +++++++++++++++++++++
 arch/arm/mach-shmobile/Kconfig                     |   3 +-
 arch/arm/mach-shmobile/pm-r8a7740.c                |  14 ++
 arch/arm/mach-shmobile/pm-rmobile.c                | 236 +++++++++++++++++--
 arch/arm/mach-shmobile/pm-rmobile.h                |   3 +-
 arch/arm/mach-shmobile/pm-sh7372.c                 |  11 +
 drivers/base/power/domain.c                        |  32 ++-
 drivers/sh/pm_runtime.c                            |   2 +
 include/linux/pm_domain.h                          |   2 +
 11 files changed, 663 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
