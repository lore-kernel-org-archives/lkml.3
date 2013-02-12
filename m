Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab3BLFDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 00:03:17 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36486 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab3BLFDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 00:03:14 -0500
From: Suman Anna <s-anna@ti.com>
To: Greg Kroah-Hartman <greg@linuxfoundation.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, Omar Ramirez Luna <omar.luna@linaro.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCH v2 00/13] drivers: mailbox: framework creation
Date: Mon, 11 Feb 2013 22:56:59 -0600
Message-ID: <1360645032-9668-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please find below the updated patch series for mailbox framework creation.
After commit e8d3d47 (ARM: OMAP2+: Drop plat/cpu.h for omap2plus), the
cpu_is_xxx() checks for OMAP are restricted to arch/arm/mach-omap2. The
series includes 4 new patches, first patch removes these earch specific
calls of OMAP mailbox driver code (dependencies with soc.h), and the last
three patches include minor fixes in mailbox driver code. 

This series is based on v3.8-rc7 and includes the necessary updates/fixes
required for validating remoteproc on OMAP4 and tidspbridge on OMAP3. The
series is an updated version of [2], a branch created with build fixes
for [1] based on offline reviews.

Other changes include:
- adaptations to remoteproc and tidspbridge to use the new mailbox
  api, and relying on the pdata field in the mailbox_msg structure
  instead of the previous header field (addressing review comments)
- ST-Ericsson driver update
- Kconfig fixes to fix build errors and choose proper ARCH dependencies
- 3 new patches for minor fixes in mailbox driver code
- rebased to include the devinit/devexit cleanup changes
- checkpatch errors/warnings fixes

I have hosted the series at [3].

v1:
OMAP and ST-Ericsson platforms are both using mailbox to communicate
with some coprocessors.
Based on OMAP existing mailbox framework, this series proposes a
generic framework, living under drivers/mailbox.

This series:
- moves omap-mailbox framework to a newly drivers/mailbox folder
  (part of plat-omap code cleaning)
- creates API header file
- replaces "omap" prefix by "mailbox"
- opens interface and make framework independent from omap HW
- adapts existing omap1 and omap2 drivers to new changes
- creates dbx500 mailbox driver for ST-Ericsson platforms

[1] http://git.kernel.org/?p=linux/kernel/git/linusw/linux-stericsson.git;a=shortlog;h=refs/heads/dbx500-prcmu-mailbox
[2] https://github.com/sumananna/mailbox/commits/mailbox-3.8-rc5
[3] https://github.com/sumananna/mailbox/commits/dbx500-prcmu-mailbox

Loic Pallardy (7):
  mailbox: rename omap_mbox in mailbox
  mailbox: create opened message type
  mailbox: change protection mechanisms
  mailbox: add shared memory mailbox type
  mailbox: add IRQF_NO_SUSPEND flag
  mailbox: add no_irq send message
  mailbox: create dbx500 mailbox driver

Omar Ramirez Luna (2):
  mailbox: OMAP: introduce mailbox framework
  mailbox: split internal header from API header

Suman Anna (4):
  ARM: OMAP2+: mbox: remove dependencies with soc.h
  mailbox/omap: check iomem resource before dereferencing it
  mailbox: check for NULL nb in mailbox_put
  mailbox: call request_irq after mbox queues are allocated

 arch/arm/configs/omap1_defconfig                   |   3 +-
 arch/arm/mach-omap1/Makefile                       |   4 -
 arch/arm/mach-omap1/mailbox.c                      | 199 -------
 arch/arm/mach-omap2/Makefile                       |   3 -
 arch/arm/mach-omap2/devices.c                      |  17 +-
 arch/arm/mach-omap2/mailbox.c                      | 430 ---------------
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |  12 +
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |  11 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  11 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  13 +
 arch/arm/plat-omap/Kconfig                         |  16 -
 arch/arm/plat-omap/Makefile                        |   3 -
 arch/arm/plat-omap/include/plat/mailbox.h          | 105 ----
 arch/arm/plat-omap/mailbox.c                       | 435 ---------------
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/mailbox/Kconfig                            |  52 ++
 drivers/mailbox/Makefile                           |   5 +
 drivers/mailbox/mailbox-dbx500.c                   | 611 +++++++++++++++++++++
 drivers/mailbox/mailbox-omap1.c                    | 229 ++++++++
 drivers/mailbox/mailbox-omap2.c                    | 368 +++++++++++++
 drivers/mailbox/mailbox.c                          | 552 +++++++++++++++++++
 drivers/mailbox/mailbox_internal.h                 |  72 +++
 drivers/remoteproc/Kconfig                         |   3 +-
 drivers/remoteproc/omap_remoteproc.c               |  36 +-
 drivers/staging/tidspbridge/Kconfig                |   3 +-
 drivers/staging/tidspbridge/core/_tiomap.h         |   2 +-
 drivers/staging/tidspbridge/core/chnl_sm.c         |   8 +-
 drivers/staging/tidspbridge/core/io_sm.c           |   5 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |   6 +-
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |   6 +-
 drivers/staging/tidspbridge/core/tiomap_io.c       |   9 +-
 .../tidspbridge/include/dspbridge/host_os.h        |   2 +-
 include/linux/mailbox.h                            |  43 ++
 include/linux/platform_data/mailbox-dbx500.h       |  12 +
 include/linux/platform_data/mailbox-omap.h         |  53 ++
 36 files changed, 2109 insertions(+), 1233 deletions(-)
 delete mode 100644 arch/arm/mach-omap1/mailbox.c
 delete mode 100644 arch/arm/mach-omap2/mailbox.c
 delete mode 100644 arch/arm/plat-omap/include/plat/mailbox.h
 delete mode 100644 arch/arm/plat-omap/mailbox.c
 create mode 100644 drivers/mailbox/Kconfig
 create mode 100644 drivers/mailbox/Makefile
 create mode 100644 drivers/mailbox/mailbox-dbx500.c
 create mode 100644 drivers/mailbox/mailbox-omap1.c
 create mode 100644 drivers/mailbox/mailbox-omap2.c
 create mode 100644 drivers/mailbox/mailbox.c
 create mode 100644 drivers/mailbox/mailbox_internal.h
 create mode 100644 include/linux/mailbox.h
 create mode 100644 include/linux/platform_data/mailbox-dbx500.h
 create mode 100644 include/linux/platform_data/mailbox-omap.h

-- 
1.8.1.2

