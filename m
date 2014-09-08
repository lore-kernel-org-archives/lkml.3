Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaIHNgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:36:00 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:39485 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaIHNf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:35:57 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC 0/5] ARM: shmobile: R-Mobile: Prototype DT PM domain support
Date: Mon,  8 Sep 2014 15:35:39 +0200
Message-Id: <1410183344-14756-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
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

Despite my request to add support for non-contiguous arrays for onecell PM
domain providers, I went for representing the SoC's power area hierarchy as a
hierarchy in DT, with multiple PM domain nodes, and using "#power-domain-cells
= <0>" (see also the P.S. below).  The code to support a proper hiearchy turned
out to be surprisingly clean and simple(r).

Dependencies:
  - "[PATCH 00/11] ARM: shmobile: r8a7740/armadillo legacy prototype pm domain
    support", sent by me (www.spinics.net/lists/arm-kernel/msg358037.html),
  - "[PATCH v3 0/9] PM / Domains: Generic OF-based support", sent by Ulf
    Hansson (www.spinics.net/lists/arm-kernel/msg357003.html),
  - "[PATCH 00/15] PM / Domains: Cleanups and remove superfluous APIs", sent by
    Ulf Hansson (www.spinics.net/lists/linux-samsung-soc/msg36407.html).

Note that this still won't work as-is, this is just an RFC.
More fixes are needed in sh-mobile platform glue, and to resolve the bad
interaction with drivers/sh/pm_runtime.c and clk_disable_unused().
But none of these matter for e.g. discussing DT bindings.
With those fixed/worked around, functionality is almost equivalent to the
non-DT case.  Missing are Run-Time management of the module clocks
(pm_clk_*()), and device latencies.

Thanks for your comments!

Geert Uytterhoeven (5):
  PM / Domains: Add DT bindings for power-on/off latencies
  PM / Domains: Add DT bindings for the R-Mobile System Controller
  ARM: shmobile: R-Mobile: Store SYSC base address in rmobile_pm_domain
  ARM: shmobile: R-Mobile: Add DT support for PM domains
  ARM: shmobile: r8a7740 dtsi: Add PM domain support

 .../devicetree/bindings/power/power_domain.txt     |   6 +
 .../bindings/power/renesas,sysc-rmobile.txt        | 106 +++++++++++++
 arch/arm/boot/dts/r8a7740.dtsi                     | 121 +++++++++++++++
 arch/arm/mach-shmobile/Kconfig                     |   3 +-
 arch/arm/mach-shmobile/pm-r8a7740.c                |  14 ++
 arch/arm/mach-shmobile/pm-rmobile.c                | 169 +++++++++++++++++++--
 arch/arm/mach-shmobile/pm-rmobile.h                |   1 +
 arch/arm/mach-shmobile/pm-sh7372.c                 |  11 ++
 8 files changed, 417 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt

P.S. I did try "#power-domain-cells = <1>", but the hassle with sparse
     definitions and error-prone multiple arrays (not unlikely, but even worse
     than with the SMTP clock specifiers) was just too much. Not to mention
     representing the C5 "always-on" power area...

	renesas,pm-domain-indices = <
		R8A7740_PD_A4LC R8A7740_PD_A4MP R8A7740_PD_D4
		R8A7740_PD_A4R R8A7740_PD_A3RV R8A7740_PD_A4S
		R8A7740_PD_A3SP R8A7740_PD_A3SM R8A7740_PD_A3SG
		R8A7740_PD_A4SU
	>;
	renesas,pm-domain-names =
		"A4LC", "A4MP", "D4", "A4R", "A3RV", "A4S", "A3SP",
		"A3SM", "A3SG", "A4SU";
	renesas,pm-domain-parents =
		"", "", "", "", "A4R", "", "A4S", "A4S", "A4S", "";

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
