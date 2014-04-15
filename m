Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaDOSQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:16:17 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:60095 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaDOSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:16:13 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chao Xie <xiechao.mail@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] fixing regressions caused by Dove in MULTI_V7
Date: Tue, 15 Apr 2014 20:15:58 +0200
Message-Id: <1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <20140414151236.75f8816d@skate>
References: <20140414151236.75f8816d@skate>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch set fixing regressions in v3.15-rc1 ultimately caused
by adding DT-enabled Marvell Dove to MULTI_V7. There was a fix
introduced late in the merge window to fix a related regression for
non-PJ4 architectures, that turned out to introduce another regression
on PJ4B-based Armada 370/XP.

Therefore, this now takes care of iWMMXt and PJ4[B] related code to
properly fix all regressions observed in v3.15-rc1. At the end, one
patch adding support for iWMMXt on PJ4B as found on Marvell Berlin
BG2 SoCs is added.

Patch 1 reworks iwmmxt.S preprocessor directives to allow to build
it only if a supported platform is enabled. Also, it rewrites them
to explicitly check for all CPUs of the currently supported
architectures.

Patch 2 fixes pj4_cp0_init to only enable iWMMXt capabilities, if
corresponding kernel support code is also enabled by CONFIG_IWMMXT.

Patch 3 fixes pj4_cp0_init to properly perform runtime checks for
absence/presence of iWMMXt coprocessor. This effectively fixes
boot regressions observed on Armada 370/XP.

Patch 4 fixes cpu_is_pj4's cpuid check to check for both PJ4 and
PJ4B. This effectively fixes iWMMXt support on MULTI_V7 Dove.

Patch 5 finally allows PJ4B to also enable iWMMXt support as there
are some PJ4B based SoCs, e.g. Marvell Armada 1500, that have those
coprocessors. This is _not_ a fix but an improvement and should be
treated as such, i.e. taken for v3.16.

As a side note, after looking into this: if XScale based SoCs also
properly perform runtime checks for iWMMXt presence, I'd be
interested on comments if iWMMXt can possibly also be reworked to
be build as a module dynamically adding/removing iWMMXt support?

I expect proper Tested-by's for Armada 370/XP, where some
preliminary patches have been boot tested by Thomas Petazzoni.
I boot tested it on Marvell Dove and Marvell Berlin BG2.
Any Tested-by's from XScale and/or non-PJ4[B] architectures are
also appreciated.

Russell, please let me know if/when you are happy with the fixes
and the improvement. I'll be adding them to your patch tracker then.

Sebastian

Sebastian Hesselbarth (5):
  ARM: iwmmxt: explicitly check for supported architectures
  ARM: pj4: enable iWMMXt only if CONFIG_IWMMXT is set
  ARM: pj4: properly detect existence of iWMMXt coprocessor
  ARM: pj4: fix cpu_is_pj4 check
  ARM: iwmmxt: allow to build iWMMXt on Marvell PJ4B

 arch/arm/Kconfig               |  6 +++---
 arch/arm/include/asm/cputype.h | 14 +++++++-------
 arch/arm/kernel/Makefile       |  1 +
 arch/arm/kernel/iwmmxt.S       |  8 ++++++--
 arch/arm/kernel/pj4-cp0.c      | 42 +++++++++++++++++++++++++++++++++++++++---
 5 files changed, 56 insertions(+), 15 deletions(-)

---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Chao Xie <xiechao.mail@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.9.1

