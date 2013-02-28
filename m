Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab3B1EuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:50:14 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62522 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3B1EuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:50:11 -0500
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v3 0/5] common clk framework reentrancy & dvfs, take 3
Date: Wed, 27 Feb 2013 20:49:24 -0800
Message-Id: <1362026969-11457-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series implements reentrancy for the common clk implementation of
the clk.h api.  Making reentrant calls into the clock framework is both
necessary and desirable for many use cases such as enabling off-chip
clocks via i2c.  The first patch in the series implements this.

A neat side effect of reentrancy is that it is possible for platforms
using voltage regulators controlled via i2c to register rate-change
notifier handlers to scale voltage as a function of clock rate.  This is
an effective way to implement dynamic voltage & frequency scaling.
Patch #2 implements a helper function for registering such a notifier
handler.

The third patch in the series demonstrates dvfs on OMAP platforms by
modifying the cpufreq-omap driver; it migrates the voltage scaling logic
out of the cpufreq driver's .target callback and registers callbacks via
the helper introduced in patch #2.

Patches four and five are purely test coverage.  And what better way to
test than to muck with fragile PLL programming code?  These patches test
out a lot of the aforementioned reentrancy in the OMAP3+ DPLL code.
They are not for merging, but as a demonstration of what is now
possible.

Finally, I know that Documentation/clk.txt needs an update for these
changes but I wanted this on the list before I flew out to LCA 2013.
I'll provide that update during or after the conference.

Two previous (and considerably more insane) attempts at this,
v1: http://article.gmane.org/gmane.linux.kernel/1327866
v2: http://marc.info/?l=linux-kernel&m=134507429302463&w=2

Mike Turquette (5):
  clk: allow reentrant calls into the clk framework
  clk: notifier handler for dynamic voltage scaling
  cpufreq: omap: scale regulator from clk notifier
  HACK: set_parent callback for OMAP4 non-core DPLLs
  HACK: omap: opp: add fake 400MHz OPP to bypass MPU

 arch/arm/mach-omap2/cclock44xx_data.c |    1 +
 arch/arm/mach-omap2/clock.h           |    1 +
 arch/arm/mach-omap2/dpll3xxx.c        |  107 ++++++++++----
 arch/arm/mach-omap2/opp4xxx_data.c    |   18 +++
 drivers/clk/Makefile                  |    1 +
 drivers/clk/clk.c                     |  254 ++++++++++++++++++++++++---------
 drivers/clk/dvfs.c                    |  125 ++++++++++++++++
 drivers/cpufreq/omap-cpufreq.c        |   82 +++--------
 include/linux/clk.h                   |   27 +++-
 9 files changed, 459 insertions(+), 157 deletions(-)
 create mode 100644 drivers/clk/dvfs.c

-- 
1.7.10.4

