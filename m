Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbaEJQiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 12:38:19 -0400
Received: from ring0.de ([5.45.105.125]:43954 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbaEJQiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 12:38:13 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCHv5 00/10] OMAP SSI driver / N900 modem support
Date: Sat, 10 May 2014 18:37:40 +0200
Message-Id: <1399739870-13526-1-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the ninth round of the OMAP SSI driver patches. I plan
to move all the whole patchset (except DTS changes) to for-next
on 2014-05-15 23:42 if nobody objects until then. @Tony: Is this
sufficiently early to get the DTS changes into 3.16 via your
tree?

Changes since PATCHv4 [0]:
 * Removed first three patches (HSI Documentation, MAINTAINER file
   update and hsi-char fix) from the patchset. I added them to
   for-next already.
 * Added module parameter pm to the nokia-modem kernel module, which
   can be used to disable requesting the gpios (needed by fremantle).
   The same parameter will be used later to enable full-kernel
   based power management. This is not yet implemented in the driver
   and would break all existing userspace applications.
 * Added Tested-By from Ivaylo Dimitrov, who successfully tested it
   with Maemo fremantle (with some additional patches not directly
   touching the modem, but needed to boot Maemo).
 * Export ssi-protocol reset function, so that nokia-n900 can call
   it if ssi-protocol is built as module.
 * Updated KConfig, so that n900-modem / ssi-protocol and omap-ssi
   can be built independently.
 * Updated KConfig omap-ssi entry to depend on omap3 or compile-test.
 * Fix build for disabled CONFIG_OF

For testing you can either apply this patchset to current mainline
kernel or use the n900-modem-support-4 branch available on [1].
Feedback is highly appreciated :)

For testing the patchset you should build the kernel with all config
entries in the HSI subsystem activated and boot using the updated
device tree information (platform data based booting is not
supported!). Testing the patchset with ofono works like this:

 # provide cmt device for ofono
 ln -sf /sys/bus/hsi/n900-modem /dev/cmt
 # start ofono
 ofono --nodetach --debug
 # enable the modem
 mdbus2 -s org.ofono /n900_0 org.ofono.Modem.SetProperty Powered true
 # enable modem's RF parts
 mdbus2 -s org.ofono /n900_0 org.ofono.Modem.SetProperty Online true
 # scan for available networks (takes some time)
 mdbus2 -s org.ofono /n900_0 org.ofono.NetworkRegistration.Scan

TODO (post-merge):
* Central Message Queue in HSI framework
* Remove the hwmod DT hack
* Implement proper context loss detection
* Implement full N900 modem PM (in-kernel)
* Remove wakeline checks (thus removing the FIXMEs)

[0] https://lkml.org/lkml/2014/4/25/520
[1] git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-hsi.git

-- Sebastian

Sebastian Reichel (10):
  HSI: method to unregister clients from an hsi port
  HSI: Add channel resource support to HSI clients
  HSI: export method to (un)register clients
  HSI: Add common DT binding for HSI client devices
  HSI: Introduce OMAP SSI driver
  Documentation: DT: omap-ssi binding documentation
  HSI: Introduce driver for SSI Protocol
  HSI: Introduce Nokia N900 modem driver
  DTS: ARM: OMAP3-N900: Add SSI support
  DTS: ARM: OMAP3-N900: Add modem support

 .../devicetree/bindings/hsi/client-devices.txt     |   44 +
 .../devicetree/bindings/hsi/nokia-modem.txt        |   57 +
 Documentation/devicetree/bindings/hsi/omap-ssi.txt |   97 ++
 arch/arm/boot/dts/omap3-n900.dts                   |   65 +
 arch/arm/boot/dts/omap3.dtsi                       |   45 +
 arch/arm/boot/dts/omap34xx.dtsi                    |   11 +
 arch/arm/boot/dts/omap36xx.dtsi                    |   11 +
 drivers/hsi/Kconfig                                |    1 +
 drivers/hsi/Makefile                               |    1 +
 drivers/hsi/clients/Kconfig                        |   17 +
 drivers/hsi/clients/Makefile                       |    4 +-
 drivers/hsi/clients/hsi_char.c                     |   12 +-
 drivers/hsi/clients/nokia-modem.c                  |  285 ++++
 drivers/hsi/clients/ssi_protocol.c                 | 1191 +++++++++++++++++
 drivers/hsi/controllers/Kconfig                    |   19 +
 drivers/hsi/controllers/Makefile                   |    6 +
 drivers/hsi/controllers/omap_ssi.c                 |  625 +++++++++
 drivers/hsi/controllers/omap_ssi.h                 |  166 +++
 drivers/hsi/controllers/omap_ssi_port.c            | 1399 ++++++++++++++++++++
 drivers/hsi/controllers/omap_ssi_regs.h            |  171 +++
 drivers/hsi/hsi.c                                  |  275 +++-
 include/linux/hsi/hsi.h                            |   39 +-
 include/linux/hsi/ssi_protocol.h                   |   42 +
 23 files changed, 4566 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hsi/client-devices.txt
 create mode 100644 Documentation/devicetree/bindings/hsi/nokia-modem.txt
 create mode 100644 Documentation/devicetree/bindings/hsi/omap-ssi.txt
 create mode 100644 drivers/hsi/clients/nokia-modem.c
 create mode 100644 drivers/hsi/clients/ssi_protocol.c
 create mode 100644 drivers/hsi/controllers/Kconfig
 create mode 100644 drivers/hsi/controllers/Makefile
 create mode 100644 drivers/hsi/controllers/omap_ssi.c
 create mode 100644 drivers/hsi/controllers/omap_ssi.h
 create mode 100644 drivers/hsi/controllers/omap_ssi_port.c
 create mode 100644 drivers/hsi/controllers/omap_ssi_regs.h
 create mode 100644 include/linux/hsi/ssi_protocol.h

-- 
2.0.0.rc0

