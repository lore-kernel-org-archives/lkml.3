Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaI3M0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:26:36 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:55699 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaI3M0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:26:30 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC v2 0/4] ARM: hw_breakpoint: Avoid undef instruction exceptions on wake-up
Date: Tue, 30 Sep 2014 14:26:23 +0200
Message-Id: <1412079987-1827-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,

If power area D4, which contains the Coresight-ETM hardware block, is
powered down on R-Mobile A1 (r8a7740), the kernel crashes when
suspending from s2ram with:

    Internal error: Oops - undefined instruction: 0 [#1] ARM

This happens because dbg_cpu_pm_notify() calls reset_ctrl_regs(), which
can't access the debug registers as the debug module is powered down.

As suggested by Russell King, track whether the ETM block is powered down
to fix this.

The availability of the debug registers depends on the platform and its
state.  Hence provide a mechanism for platform code to indicate that the
debug registers are available or not, using a boolean flag that
defaults to true.

This is an alternative solution for "[PATCH] ARM: hw_breakpoint: Trap undef
instruction exceptions on wake-up" (https://lkml.org/lkml/2014/9/17/190).

Thanks for your comments!

Geert Uytterhoeven (4):
  [RFC] ARM: hw_breakpoint: Add arm_dbg_regs_available flag
  [RFC] ARM: shmobile: r8a7740 legacy: Sync arm_dbg_regs_available with
    D4 PM domain
  [RFC] ARM: shmobile: R-Mobile: Sync arm_dbg_regs_available with D4 PM
    domain
  [RFC] ARM: shmobile: r8a7740 dtsi: Add minimal device node for
    Coresight-ETM

 arch/arm/boot/dts/r8a7740.dtsi       |  5 +++++
 arch/arm/include/asm/hw_breakpoint.h |  2 ++
 arch/arm/kernel/hw_breakpoint.c      |  7 +++++++
 arch/arm/mach-shmobile/pm-r8a7740.c  | 19 +++++++++++++++++++
 arch/arm/mach-shmobile/pm-rmobile.c  | 35 ++++++++++++++++++++++++++++++++---
 5 files changed, 65 insertions(+), 3 deletions(-)

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
