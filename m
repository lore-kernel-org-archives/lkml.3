Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3JFU2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 16:28:25 -0400
Received: from ring0.de ([91.143.88.219]:45466 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab3JFU2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 16:28:21 -0400
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?UTF-8?q?=27Beno=C3=AEt=20Cousson=27?= <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        =?UTF-8?q?=27Pali=20Roh=C3=A1r=27?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=27=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2=27?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv3 0/7] OMAP SSI driver
Date: Sun,  6 Oct 2013 22:27:08 +0200
Message-Id: <1381091235-18293-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the third round of the OMAP SSI driver patches.

Changes since RFCv2:
* Move DT data from omap34xx.dtsi to omap3.dtsi
  Nokia N9 uses an omap3630 and ssi for modem connection, thus SSI
  seems to be part of all OMAP3 SoCs.
* Move DT documentation to the driver patch
* Update wording in DT documentation
  I just applied Stephen Warrens suggestions
* Removal of omap_pm_get_dev_context_loss_count as demanded by Tony Lindgren
  For now there is no context loss support in the driver, since I do not
  have enough information about the chip to support this via registers.
* Dropped useless "default n" from KConfig
* Add support for HSI client registration via DT
* Register hsi-char as ssi client for Nokia N900
  Currently only hsi-char client is available in the mainline kernel,
  but for the Nokia N900 two more clients will be needed: ssi-protocol
  and cmt-speech. Those will be added with their own patchset.
* Use ida_simple_get for device id, since DT does not setup pd->id
* Fixed SSI interrupt numbers in omap3.dtsi
  I subtracted OMAP_INTC_START before, but the original patch did
  not yet have OMAP_INTC_START added.
* Fixed compilation as kernel modules
* Fixed reload of kernel modules
* Added module dependency: omap_ssi_port needs omap_port

TODO:
* Central Message Queue
  I did not yet implement a central message queue in the HSI framework.
  I will do this after Nokia N900 modem is working in the mainline kernel,
  since that makes testing easier.
* Get clock data from DT
  This depends on a patchset, which is not yet part of any kernel tree.
  Apart from that I don't know which clocks will be needed. That depends
  on the implementation of the hwmod DTification (see next point)
* Remove the hwmod DT hack
  This depends on some future work merging hwmod data into DT.

Version 2 of the patchset: https://lkml.org/lkml/2013/9/15/98

-- Sebastian

Sebastian Reichel (7):
  ARM: OMAP2+: hwmod-data: Add SSI information
  HSI: add Device Tree support for HSI clients
  HSI: method to unregister clients from an hsi port
  HSI: hsi-char: add Device Tree support
  HSI: hsi-char: fix driver for multiport scenarios
  ARM: OMAP2+: HSI: Introduce OMAP SSI driver
  ARM: dts: N900: Add SSI information

 Documentation/devicetree/bindings/hsi/omap_ssi.txt |   69 +
 .../devicetree/bindings/hsi/trivial-devices.txt    |   36 +
 arch/arm/boot/dts/omap3-n900.dts                   |   12 +
 arch/arm/boot/dts/omap3.dtsi                       |   47 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   48 +
 drivers/hsi/Kconfig                                |    1 +
 drivers/hsi/Makefile                               |    1 +
 drivers/hsi/clients/hsi_char.c                     |   15 +-
 drivers/hsi/controllers/Kconfig                    |   19 +
 drivers/hsi/controllers/Makefile                   |    6 +
 drivers/hsi/controllers/omap_ssi.c                 |  618 +++++++++
 drivers/hsi/controllers/omap_ssi.h                 |  166 +++
 drivers/hsi/controllers/omap_ssi_port.c            | 1400 ++++++++++++++++++++
 drivers/hsi/controllers/omap_ssi_regs.h            |  171 +++
 drivers/hsi/hsi.c                                  |   80 +-
 include/dt-bindings/hsi/hsi.h                      |   17 +
 include/linux/hsi/hsi.h                            |    3 +
 17 files changed, 2707 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hsi/omap_ssi.txt
 create mode 100644 Documentation/devicetree/bindings/hsi/trivial-devices.txt
 create mode 100644 drivers/hsi/controllers/Kconfig
 create mode 100644 drivers/hsi/controllers/Makefile
 create mode 100644 drivers/hsi/controllers/omap_ssi.c
 create mode 100644 drivers/hsi/controllers/omap_ssi.h
 create mode 100644 drivers/hsi/controllers/omap_ssi_port.c
 create mode 100644 drivers/hsi/controllers/omap_ssi_regs.h
 create mode 100644 include/dt-bindings/hsi/hsi.h

-- 
1.8.4.rc3

