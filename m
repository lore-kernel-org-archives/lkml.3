Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3LOX23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 18:28:29 -0500
Received: from ring0.de ([91.143.88.219]:40047 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab3LOX20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 18:28:26 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?UTF-8?q?=27Beno=C3=AEt=20Cousson=27?= <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv4 00/11] OMAP SSI driver / N900 modem support
Date: Mon, 16 Dec 2013 00:27:53 +0100
Message-Id: <1387150085-23173-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the fourth round of the OMAP SSI driver patches.

I added some more patches on top of the actual OMAP SSI driver, so that one can
get the overall picture of the planned architecture. This patchset contains
everything, that is needed to get the N900's modem running (without audio
support, which requires another hsi client driver).

After applying the patches one can use ofono with the N900's modem.
This is what I did to test the modem:

 # get ofono and mdbus2 to send some dbus commands
 apt-get install ofono mdbus2
 # ofono assumes, that gpios are available in /dev/cmt. Previously
 # a init script exported the gpios and symlinked them to this
 # directory. I added support for the gpio export directly into
 # nokia-cmt and I plan to write a patch for ofono to check for
 # the cmt gpios directly in /sys. For now this hack can be used
 # to test the modem.
 ln -sf /sys/devices/nokia-cmt.5 /dev/cmt
 # start ofono in debug mode
 export OFONO_ISI_DEBUG
 export OFONO_AT_DEBUG=1
 ofono --nodetach --debug
 # enable the modem
 mdbus2 -s org.ofono /n900_0 org.ofono.Modem.SetProperty Powered true
 # enable modem's RF parts
 mdbus2 -s org.ofono /n900_0 org.ofono.Modem.SetProperty Online true
 # scan for available networks
 mdbus2 -s org.ofono /n900_0 org.ofono.NetworkRegistration.Scan

Changes since RFCv3 [0]:
* Added new patches for nokia-cmt driver
* Added new patches for ssi protocol driver
* Removal of ti,hwmods description from DT Documentation
* Removed the hwmod patch, since it has already been applied
* Misc. bug fixes

TODO (short-term):
* Find a DT maintainer, who has time to review the updated DT bindings
* Push nokia-cmt driver through gregkh's linux-misc queue
* Push hsi/ssi drivers through my new linux-hsi queue [1]
* Push DTS patches through benoits queue once the other patches are queued

TODO (long-term):
* Central Message Queue
  I did not yet implement a central message queue in the HSI framework.
  I will do this after Nokia N900 modem is working in the mainline kernel.
* Get clock data from DT
  This depends on a patchset, which is not yet part of any kernel tree.
  Apart from that I don't know which clocks will be needed. That depends
  on the implementation of the hwmod DTification (see next point)
* Remove the hwmod DT hack
  This depends on some future work merging hwmod data into DT.

[0] https://lkml.org/lkml/2013/10/6/127
[1] https://git.kernel.org/cgit/linux/kernel/git/sre/linux-hsi.git/

-- Sebastian

Sebastian Reichel (11):
  HSI: method to unregister clients from an hsi port
  HSI: hsi-char: add Device Tree support
  HSI: hsi-char: fix driver for multiport scenarios
  ARM: OMAP2+: HSI: Introduce OMAP SSI driver
  Documentation: DT: omap-ssi binding documentation
  misc: Introduce Nokia CMT driver
  Documentation: DT: nokia-cmt binding documentation
  HSI: Introduce driver for SSI Protocol
  DTS: ARM: OMAP3-N900: Add SSI support
  DTS: ARM: OMAP3-N900: Add CMT support
  DTS: ARM: OMAP3-N900: Add SSI protocol support

 Documentation/devicetree/bindings/hsi/omap_ssi.txt |   69 +
 .../devicetree/bindings/misc/nokia-cmt.txt         |   28 +
 arch/arm/boot/dts/omap3-n900.dts                   |   72 +
 arch/arm/boot/dts/omap3.dtsi                       |   47 +
 drivers/hsi/Kconfig                                |    1 +
 drivers/hsi/Makefile                               |    1 +
 drivers/hsi/clients/Kconfig                        |    8 +
 drivers/hsi/clients/Makefile                       |    3 +-
 drivers/hsi/clients/hsi_char.c                     |   13 +-
 drivers/hsi/clients/ssi_protocol.c                 | 1201 +++++++++++++++++
 drivers/hsi/controllers/Kconfig                    |   19 +
 drivers/hsi/controllers/Makefile                   |    6 +
 drivers/hsi/controllers/omap_ssi.c                 |  619 +++++++++
 drivers/hsi/controllers/omap_ssi.h                 |  166 +++
 drivers/hsi/controllers/omap_ssi_port.c            | 1401 ++++++++++++++++++++
 drivers/hsi/controllers/omap_ssi_regs.h            |  171 +++
 drivers/hsi/hsi.c                                  |   10 +
 drivers/misc/Kconfig                               |    7 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/nokia-cmt.c                           |  298 +++++
 include/linux/hsi/hsi.h                            |    1 +
 include/linux/hsi/ssi_protocol.h                   |   41 +
 include/linux/nokia-cmt.h                          |   46 +
 23 files changed, 4227 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hsi/omap_ssi.txt
 create mode 100644 Documentation/devicetree/bindings/misc/nokia-cmt.txt
 create mode 100644 drivers/hsi/clients/ssi_protocol.c
 create mode 100644 drivers/hsi/controllers/Kconfig
 create mode 100644 drivers/hsi/controllers/Makefile
 create mode 100644 drivers/hsi/controllers/omap_ssi.c
 create mode 100644 drivers/hsi/controllers/omap_ssi.h
 create mode 100644 drivers/hsi/controllers/omap_ssi_port.c
 create mode 100644 drivers/hsi/controllers/omap_ssi_regs.h
 create mode 100644 drivers/misc/nokia-cmt.c
 create mode 100644 include/linux/hsi/ssi_protocol.h
 create mode 100644 include/linux/nokia-cmt.h

-- 
1.8.5.1

