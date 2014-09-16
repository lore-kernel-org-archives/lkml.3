Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaIPSxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:53:16 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:33977 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbaIPStW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:49:22 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC v2 00/12] ARM: shmobile: R-Mobile: Prototype DT PM domain support
Date: Tue, 16 Sep 2014 20:48:47 +0200
Message-Id: <1410893339-6361-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,

This patch series contains prototype code to enable DT support for PM domains
on Renesas R-Mobile SoCs.

Currently it's limited to R-Mobile A1 (r8a7740), but given the similarity of
the SYSC System-Controller on the various SH-Mobile/R-Mobile SoCs, and the
abstraction of PM domains in DT, it should be sufficiently generic to handle
other SoCs in the future (e.g. SH-Mobile AP4 (sh7372), SH-Mobile AG5 (sh73a0),
R-Mobile APE6 (r8a73a4)).

Changes compared to v1 (more detailed changelogs in the individual patches):
  - Several new patches: [02], [04], [05], [06], [07], [11], [12],
  - Run-Time management of the module clocks, making the hack in
    drivers/sh/pm_runtime.c obsolete for DT platforms using genpd.
    More about this below[*].
  - Addition of PM QoS device latencies, specified from DT.
  - Addition of build glue, so this builds and runs without additional
    changes, incl. s2ram.

This means that functionality-wise, the DT version is now on par with the
legacy version, so I can continue focussing on fixing the common limitations,
and the quirks in rmobile_pm_quirks() in a DT-friendly way.

Thanks for your comments!

Dependencies:
  - "[PATCH 00/11] ARM: shmobile: r8a7740/armadillo legacy prototype pm domain
    support", sent by me (www.spinics.net/lists/arm-kernel/msg358037.html),
  - "[PATCH v4 0/9] PM / Domains: Generic OF-based support", sent by Ulf
    Hansson (http://www.spinics.net/lists/arm-kernel/msg360672.html),
  - Simon Horman's renesas-devel-20140916v2-v3.17-rc5,
  - Rafael J. Wysocki's linux-pm.git#linux-next,
  - Jason Cooper's linux.git#irqchip/for-next.

For your convenience, I've also pushed this to
git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git#rmobile-genpd

Geert Uytterhoeven (12):
  [01] PM / Domains: Add DT bindings for power-on/off latencies
  [02] PM / Domains: Add DT bindings for PM QoS device latencies
  [03] PM / Domains: Add DT bindings for the R-Mobile System Controller
  [04] PM / Domains: Add genpd attach/detach callbacks
  [05] PM / Domains: Add helper variable np = dev->of_node
  [06] PM / Domains: Retrieve PM QoS device latencies from DT
  [07] ARM: shmobile: R-Mobile: Use generic_pm_domain.attach_dev() for pm_clk
    setup
  [08] ARM: shmobile: R-Mobile: Store SYSC base address in rmobile_pm_domain
  [09] ARM: shmobile: R-Mobile: Add DT support for PM domains
  [10] ARM: shmobile: r8a7740 dtsi: Add PM domain support
  [11] ARM: shmobile: r8a7740 dtsi: Add PM QoS device latencies
  [12] drivers: sh: Disable PM runtime for multi-platform r8a7740 with genpd

 .../devicetree/bindings/power/power_domain.txt     |  16 ++
 .../bindings/power/renesas,sysc-rmobile.txt        | 111 +++++++++
 arch/arm/boot/dts/r8a7740.dtsi                     | 257 +++++++++++++++++++++
 arch/arm/mach-shmobile/Kconfig                     |   3 +-
 arch/arm/mach-shmobile/pm-r8a7740.c                |  14 ++
 arch/arm/mach-shmobile/pm-rmobile.c                | 187 +++++++++++++--
 arch/arm/mach-shmobile/pm-rmobile.h                |   3 +-
 arch/arm/mach-shmobile/pm-sh7372.c                 |  11 +
 drivers/base/power/domain.c                        |  38 ++-
 drivers/sh/pm_runtime.c                            |   2 +
 include/linux/pm_domain.h                          |   2 +
 11 files changed, 620 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt

-- 
1.9.1

[*] Run-Time management of the module clocks is a continuing story...

  - The hack in drivers/sh/pm_runtime.c used the pm_clk_notifier on the
    platform bus. This (a) is not compatible with genpd (and thus with SoCs
    where we want to use genpd to manage the power areas), as there can be only
    one PM domain attached to a device, and (b) affects all platform devices,
    not only the on-SoC devices we want to manage.

  - This series uses genpd to handle the module clocks. This works fine for
    R-Mobile, as it has fine-grained power areas. It does require representing
    the (documented) C5 always-on power area in DT, as now all on-SoC devices
    need a phandle to a PM domain to manage their clocks.
    For R-Car SoCs, this will be more complicated, as there are only power
    areas for CPU cores and co-processors (e.g. SH-4A and SGX), so I'll have
    to "invent" an always-on area, and put it in DT?
    While genpd is touted as the solution for complex Run-Time management of
    clocks, I feel like it's forcing a Linux-solution in DT, which should
    represent the hardware. On Renesas SoCs, the module clocks are not related
    to the power areas, but they're a property of the Clock Pulse Generator's
    Module Standby functionality, hence my earlier proposal [A] below.

  - Related discussions:
      [A] "[PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core", by
          me (https://lkml.org/lkml/2014/4/24/1118),
      [B] "[RFC PATCH 0/3] PM / clock_ops: allow to specify custom
	  pm_clk_notifier callback", by Grygorii Strashko
	  (https://lkml.org/lkml/2014/7/25/630).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
