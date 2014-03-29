Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaC2Ack (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:32:40 -0400
Received: from ring0.de ([5.45.105.125]:42836 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbaC2Aci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:32:38 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
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
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 00/14] OMAP SSI driver / N900 modem support
Date: Sat, 29 Mar 2014 01:31:36 +0100
Message-Id: <1396053110-21639-1-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the seventh round of the OMAP SSI driver patches. The plan is
to get it merged into 3.16.

Changes since PATCHv2 [0]:
 * Readded generic HSI client binding and Nokia N900 modem support.
   They are also intended to be added in 3.16 and useful for testing
   the SSI driver, so I think it makes sense to keep them in one
   patchset.
 * Updated the DT binding for the modem. A HSI port has only a single
   child now, which describes the connected remote device. This better
   fits the DT model of strictly describing hardware, since a HSI port
   is a point2point interface.  The driver can instantiate other
   drivers as needed.
 * Moved channel description from the drivers into DT.
 * I added Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com> to the
   omap-ssi and ssi-protocol driver addtions, since the initial driver
   was from him.
 * I updated my email address.
 * Added DTS changes to ease reviewing/testing the patchset.

I did *not* implement proper PM for the Nokia N900 modem in kernel
space, since that would break all existing userlands (ofono, fso-gsmd
and Nokia's closed source binaries). I think this should be implemented
later.

Please send feedback (e.g. Tested-By or Reviewed-By :)), so that I can
send a pull request for 3.16. You can either apply this patchset or
use the n900-modem-support branch available on [1].

For testing the patchset you should build the kernel with all config
entries in the HSI subsystem activated and boot using the updated
device tree information, since platform data based booting is not
supported. Testing the patchset with ofono works like this:

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
* Central Message Queue
  I did not yet implement a central message queue in the HSI framework.
  I will do this after Nokia N900 modem is working in the mainline kernel.
* Remove the hwmod DT hack
  This depends on some future work merging hwmod data into DT.
* Implement proper context loss detection
* Implement N900 modem PM

[0] https://lkml.org/lkml/2014/3/9/139
[1] git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-hsi.git

-- Sebastian

Sebastian Reichel (14):
  Documentation: HSI: Add some general description for the HSI subsystem
  MAINTAINERS: update HSI entry
  HSI: hsi-char: fix driver for multiport scenarios
  HSI: method to unregister clients from an hsi port
  HSI: Add channel resource support to HSI clients
  HSI: export method to (un)register clients
  HSI: Add common DT binding for HSI client devices
  HSI: Introduce OMAP SSI driver
  Documentation: DT: omap-ssi binding documentation
  HSI: Introduce driver for SSI Protocol
  HSI: Introduce Nokia N900 modem driver
  ARM: dts: omap3 clocks: simplify ssi aliases
  DTS: ARM: OMAP3-N900: Add SSI support
  DTS: ARM: OMAP3-N900: Add modem support

 .../devicetree/bindings/hsi/client-devices.txt     |   44 +
 .../devicetree/bindings/hsi/nokia-modem.txt        |   58 +
 Documentation/devicetree/bindings/hsi/omap-ssi.txt |   85 ++
 Documentation/hsi.txt                              |   75 ++
 MAINTAINERS                                        |    4 +-
 arch/arm/boot/dts/omap3-n900.dts                   |   65 +
 arch/arm/boot/dts/omap3.dtsi                       |   55 +
 arch/arm/boot/dts/omap3430es1-clocks.dtsi          |   10 +-
 arch/arm/boot/dts/omap34xx.dtsi                    |   11 +
 .../boot/dts/omap36xx-omap3430es2plus-clocks.dtsi  |   10 +-
 arch/arm/boot/dts/omap36xx.dtsi                    |   11 +
 drivers/hsi/Kconfig                                |    1 +
 drivers/hsi/Makefile                               |    1 +
 drivers/hsi/clients/Kconfig                        |   17 +
 drivers/hsi/clients/Makefile                       |    4 +-
 drivers/hsi/clients/hsi_char.c                     |   14 +-
 drivers/hsi/clients/nokia-modem.c                  |  272 ++++
 drivers/hsi/clients/ssi_protocol.c                 | 1188 +++++++++++++++++
 drivers/hsi/controllers/Kconfig                    |   19 +
 drivers/hsi/controllers/Makefile                   |    6 +
 drivers/hsi/controllers/omap_ssi.c                 |  621 +++++++++
 drivers/hsi/controllers/omap_ssi.h                 |  166 +++
 drivers/hsi/controllers/omap_ssi_port.c            | 1401 ++++++++++++++++++++
 drivers/hsi/controllers/omap_ssi_regs.h            |  171 +++
 drivers/hsi/hsi.c                                  |  267 +++-
 include/linux/hsi/hsi.h                            |   30 +-
 include/linux/hsi/ssi_protocol.h                   |   42 +
 27 files changed, 4619 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hsi/client-devices.txt
 create mode 100644 Documentation/devicetree/bindings/hsi/nokia-modem.txt
 create mode 100644 Documentation/devicetree/bindings/hsi/omap-ssi.txt
 create mode 100644 Documentation/hsi.txt
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
1.9.0

