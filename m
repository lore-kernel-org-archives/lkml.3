Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaKCPfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:35:10 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:58299 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaKCPfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:35:02 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v4 0/9] ARM: shmobile: R-Mobile: DT PM domain support
Date: Mon,  3 Nov 2014 16:34:47 +0100
Message-Id: <1415028896-9005-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
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

Functionality-wise, this behaves the same as the legacy (non-DT) version
(modulo missing DT support in some device drivers).

Dependencies:
  - This is based on Simon Horman's renesas-devel-20141030-v3.18-rc2, and
    Rafael J. Wysocki's linux-pm.git#linux-next,
  - This depends on "PM / Domains: Change prototype for the ->attach_dev()
    callback" from Ulf hanson, which is intended to still enter v3.18-rcX
    through the linux-pm tree.
    As this is a one-line change, I included this patch as the first patch of
    this series.  Perhaps it's even acceptable for Simon to (also) apply it, so
    we don't have to wait for the v3.18-rcX that will include it?

For your convenience, I've also pushed this to
git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git#rmobile-genpd

Changes compared to v3 (more detailed changelogs in the individual patches):
  - I dropped the patch to add preliminary PM domain latencies, as I want to do
    more measurements for PM domains that are currently never powered off.
    Values seem to range between 8.5 and 26 us, depending on the PM domain.
  - I dropped all patches related to QoS device latencies, as these need more
    discussion,
  - The power-{on,off}-latency properties have been changed from a single value
    to a list,
  - Device save/restore state latencies have been dropped, as they're Linux
    driver-specific, and thus don't belong in DT,
  - Use proper pm_clk_create()/pm_clk_destroy(), and update for attach_dev()
    returning an error code again,
  - New patch to enable module clocks if !CONFIG_PM_RUNTIME,
  - Always keep D4 powered, until the new Coresight code handles runtime
    PM,
  - Remove bogus power-domains properties from clock nodes, as these will not
    be instantiated as platform devices,
  - Add power-domains properties to the recently added TMU nodes,
  - Added Acked-by, Reviewed-by.

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

Thanks!

Geert Uytterhoeven (8):
  PM / Domains: Add DT bindings for power-on/off latencies
  PM / Domains: Add DT bindings for the R-Mobile System Controller
  ARM: shmobile: R-Mobile: Use generic_pm_domain.attach_dev() for pm_clk
    setup
  ARM: shmobile: R-Mobile: Enable module clocks if !CONFIG_PM_RUNTIME
  ARM: shmobile: R-Mobile: Store SYSC base address in rmobile_pm_domain
  ARM: shmobile: R-Mobile: Add DT support for PM domains
  ARM: shmobile: r8a7740 dtsi: Add PM domain support
  drivers: sh: Disable PM runtime for multi-platform r8a7740 with genpd

Ulf Hansson (1):
  PM / Domains: Change prototype for the ->attach_dev() callback

 .../devicetree/bindings/power/power_domain.txt     |  14 +-
 .../bindings/power/renesas,sysc-rmobile.txt        | 107 ++++++++
 arch/arm/boot/dts/r8a7740.dtsi                     |  99 +++++++
 arch/arm/mach-shmobile/Kconfig                     |   3 +-
 arch/arm/mach-shmobile/pm-r8a7740.c                |  14 +
 arch/arm/mach-shmobile/pm-rmobile.c                | 284 +++++++++++++++++++--
 arch/arm/mach-shmobile/pm-rmobile.h                |   3 +-
 arch/arm/mach-shmobile/pm-sh7372.c                 |  11 +
 drivers/sh/pm_runtime.c                            |   2 +
 include/linux/pm_domain.h                          |   2 +-
 10 files changed, 519 insertions(+), 20 deletions(-)
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
