Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3CMD3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 23:29:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39901 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3CMD3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 23:29:01 -0400
From: Suman Anna <s-anna@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Benoit Cousson <b-cousson@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCHv3 00/14] drivers: mailbox: framework creation
Date: Tue, 12 Mar 2013 22:23:41 -0500
Message-ID: <1363145021-14339-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Please find the updated mailbox patch series for pulling into linux-next.
The series is rebased on top of 3.9-rc2, and includes one new patch to
rename an existing mailbox.h added as part of the highbank cpufreq
support for 3.9 merge window [1]. 

The rest of the patches are mostly unchanged from the previous version,
other than the required changes as part of rebasing. The main changes
are:
- a new patch to rename existing mailbox.h to pl320-ipc.h (patch 1)
- updated patch to fix cleanup issues in probe & remove of omap2 mailbox
  file including minor variable name changes in hwmod files (patch 2)
- includes the updated dbx500 mailbox patch addressing review
  comments, same as [2] (patch 11)
- removes the MULTIPLATFORM Kconfig dependencies added to mailbox and
  remoteproc drivers for 3.9
- minor rebase changes include whitespace formatting

I am wondering if Patch 1 can be absorbed into 3.9 itself, since the
PL320 IPC and associated header file is introduced in 3.9-rc1.

Stephen,
I have hosted the series at [3]. Can you pull this into linux-next
sometime next week?

v2: [4]
After commit e8d3d47 (ARM: OMAP2+: Drop plat/cpu.h for omap2plus), the
cpu_is_xxx() checks for OMAP are restricted to arch/arm/mach-omap2. The
series includes 4 new patches, first patch removes these arch specific
calls of OMAP mailbox driver code (dependencies with soc.h), and the
last three patches include minor fixes in mailbox driver code.

This series is based on v3.8-rc7 and includes the necessary updates/fixes
required for validating remoteproc on OMAP4 and tidspbridge on OMAP3.

Other changes include:
- adaptations to remoteproc and tidspbridge to use the new mailbox
  api, and relying on the pdata field in the mailbox_msg structure
  instead of the previous header field (addressing review comments)
- ST-Ericsson driver update
- Kconfig fixes to fix build errors and choose proper ARCH dependencies
- 3 new patches for minor fixes in mailbox driver code
- rebased to include the devinit/devexit cleanup changes
- checkpatch errors/warnings fixes

v1:
OMAP and ST-Ericsson platforms are both using mailbox to communicate with some coprocessors.
Based on OMAP existing mailbox framework, this series proposes a generic framework, living under drivers/mailbox.

This series:
- moves omap-mailbox framework to a newly drivers/mailbox folder
  (part of plat-omap code cleaning)
- creates API header file
- replaces "omap" prefix by "mailbox"
- opens interface and make framework independent from omap HW
- adapts existing omap1 and omap2 drivers to new changes
- creates dbx500 mailbox driver for ST-Ericsson platforms

[1] http://www.spinics.net/lists/cpufreq/msg04031.html
[2] http://marc.info/?l=linux-omap&m=136079313704751&w=2
[3] https://github.com/sumananna/mailbox/commits/dbx500-prcmu-mailbox
[4] http://marc.info/?l=linux-omap&m=136064540007076&w=2

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

Suman Anna (5):
  mailbox: rename pl320-ipc specific mailbox.h
  ARM: OMAP2+: mbox: remove dependencies with soc.h
  mailbox/omap: check iomem resource before dereferencing it
  mailbox: check for NULL nb in mailbox_put
  mailbox: call request_irq after mbox queues are allocated

 .../devicetree/bindings/mailbox/dbx500-mailbox.txt |  27 +
 arch/arm/configs/omap1_defconfig                   |   3 +-
 arch/arm/mach-omap1/Makefile                       |   4 -
 arch/arm/mach-omap1/mailbox.c                      | 199 -------
 arch/arm/mach-omap2/Makefile                       |   3 -
 arch/arm/mach-omap2/devices.c                      |  13 +-
 arch/arm/mach-omap2/mailbox.c                      | 430 --------------
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |  12 +
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |  11 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  11 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  13 +
 arch/arm/plat-omap/Kconfig                         |  16 -
 arch/arm/plat-omap/Makefile                        |   3 -
 arch/arm/plat-omap/include/plat/mailbox.h          | 105 ----
 arch/arm/plat-omap/mailbox.c                       | 435 --------------
 drivers/cpufreq/highbank-cpufreq.c                 |   2 +-
 drivers/mailbox/Kconfig                            |  41 ++
 drivers/mailbox/Makefile                           |   5 +
 drivers/mailbox/mailbox-dbx500.c                   | 648 +++++++++++++++++++++
 drivers/mailbox/mailbox-omap1.c                    | 229 ++++++++
 drivers/mailbox/mailbox-omap2.c                    | 370 ++++++++++++
 drivers/mailbox/mailbox.c                          | 552 ++++++++++++++++++
 drivers/mailbox/mailbox_internal.h                 |  70 +++
 drivers/mailbox/pl320-ipc.c                        |   2 +-
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
 include/linux/mailbox.h                            |  52 +-
 include/linux/pl320-ipc.h                          |  17 +
 include/linux/platform_data/mailbox-dbx500.h       |  12 +
 include/linux/platform_data/mailbox-omap.h         |  53 ++
 38 files changed, 2170 insertions(+), 1248 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mailbox/dbx500-mailbox.txt
 delete mode 100644 arch/arm/mach-omap1/mailbox.c
 delete mode 100644 arch/arm/mach-omap2/mailbox.c
 delete mode 100644 arch/arm/plat-omap/include/plat/mailbox.h
 delete mode 100644 arch/arm/plat-omap/mailbox.c
 create mode 100644 drivers/mailbox/mailbox-dbx500.c
 create mode 100644 drivers/mailbox/mailbox-omap1.c
 create mode 100644 drivers/mailbox/mailbox-omap2.c
 create mode 100644 drivers/mailbox/mailbox.c
 create mode 100644 drivers/mailbox/mailbox_internal.h
 create mode 100644 include/linux/pl320-ipc.h
 create mode 100644 include/linux/platform_data/mailbox-dbx500.h
 create mode 100644 include/linux/platform_data/mailbox-omap.h

-- 
1.8.1.2

