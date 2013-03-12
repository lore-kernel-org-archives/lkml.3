Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab3CLKN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:13:27 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3852 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab3CLKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:13:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 12 Mar 2013 03:06:32 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 00/17] Remove GENERIC_GPIO from architecture code
Date: Tue, 12 Mar 2013 19:12:13 +0900
Message-ID: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series makes sure the GENERIC_GPIO option can only be set through GPIOLIB 
(and not by individual architectures), as a first step towards its removal.

It is targeted at getting feedback from architecture maintainers (and complains
if this is deemed too bold a move - however, I hope the rationale  behind this
will be convincing).

AFAICT every GPIO driver that implement the generic GPIO API support gpiolib at 
least optionally, and the overwhelming majority actually requires it. Using the 
generic GPIO API alone has become a marginal practice, and the benefit of 
retaining this option is rather uncertain when compared to the confusion and 
complexity it induces:
* More and more GPIO features are built around gpiolib. The sysfs interface is 
one of them ; the future gpiod API is another one. Platforms that only implement 
the generic GPIO API cannot benefit from these and the split between those who 
only implement the generic GPIO API and full-fledge users of gpiolib is becoming 
wider and wider.
* Having two layers of GPIO support is confusing to both GPIO users and 
providers, and it is easy to e.g. only depend on GENERIC_GPIO when one actually 
needs gpiolib. This series actually fixes a few of these cases.
* Simplicity and consistency is always a good thing - features in the kernel are 
typically implemented through well-defined frameworks, and similarly GPIO 
support could be consolidated around gpiolib.

Arguments against using gpiolib:
* Memory footprint of gpiolib. According to my tests a gpiolib with 256 GPIOs 
induces an overhead of ~15KB, which sounds rather reasonable.
* Performance. gpiolib introduces another layer of indirection compared to 
drivers that only implement the generic GPIO API. However, a fast path is 
available to platforms for which GPIO performance matters through the 
implementation of custom gpio_set_value() and gpio_get_value() functions which 
test for a given GPIO range and shortcut gpiolib.

For most platforms, this change should be a no-op. However I would like to make 
sure that everyone is ok with it and that nothing gets broken, as the effect of 
changing configuration options are sometimes difficult to predict.

Alexandre Courbot (17):
  arm: remove unneeded select GENERIC_GPIO
  arm: remove redundant GENERIC_GPIO selection
  arm: plat-orion: use GPIO driver on CONFIG_GPIOLIB
  mips: remove redundant GENERIC_GPIO select
  mips: loongson: use GPIO driver on CONFIG_GPIOLIB
  mips: txx9: change GENERIC_GPIO to GPIOLIB
  unicore32: remove unneeded select GENERIC_GPIO
  powerpc: remove redundant GENERIC_GPIO selection
  sh: replace CONFIG_GENERIC_GPIO by CONFIG_GPIOLIB
  xtensa: remove explicit selection of GENERIC_GPIO
  mips: alchemy: require gpiolib
  mips: pnx833x: remove requirement for GENERIC_GPIO
  avr32: default GENERIC_GPIO to false
  m68k: coldfire: use gpiolib
  avr32: default GENERIC_GPIO to false
  openrisc: default GENERIC_GPIO to false
  unicore32: default GENERIC_GPIO to false

 arch/arm/Kconfig                     | 2 --
 arch/arm/plat-orion/Makefile         | 2 +-
 arch/avr32/Kconfig                   | 2 +-
 arch/blackfin/Kconfig                | 2 +-
 arch/m68k/Kconfig.cpu                | 3 +--
 arch/mips/Kconfig                    | 7 +------
 arch/mips/loongson/common/Makefile   | 2 +-
 arch/mips/txx9/generic/setup.c       | 2 +-
 arch/openrisc/Kconfig                | 2 +-
 arch/powerpc/platforms/40x/Kconfig   | 1 -
 arch/powerpc/platforms/44x/Kconfig   | 1 -
 arch/powerpc/platforms/85xx/Kconfig  | 1 -
 arch/powerpc/platforms/86xx/Kconfig  | 3 ---
 arch/powerpc/platforms/8xx/Kconfig   | 1 -
 arch/powerpc/platforms/Kconfig       | 4 ----
 arch/sh/boards/mach-sdk7786/Makefile | 2 +-
 arch/sh/boards/mach-x3proto/Makefile | 2 +-
 arch/sh/kernel/cpu/sh2a/Makefile     | 2 +-
 arch/sh/kernel/cpu/sh3/Makefile      | 2 +-
 arch/sh/kernel/cpu/sh4a/Makefile     | 2 +-
 arch/unicore32/Kconfig               | 3 +--
 arch/xtensa/configs/iss_defconfig    | 1 -
 arch/xtensa/configs/s6105_defconfig  | 1 -
 23 files changed, 14 insertions(+), 36 deletions(-)

-- 
1.8.1.5

