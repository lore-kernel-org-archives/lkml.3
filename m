Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab3FQIKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:10:38 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:6626 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932350Ab3FQIKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:10:34 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: <akhil.goyal@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <pankaj.chauhan@freescale.com>,
        Akhil Goyal <akhil.goyal@freescale.com>
Subject: [PATCH 0/5] Radio device framework
Date: Mon, 17 Jun 2013 13:39:21 +0530
Message-ID: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com>
X-Mailer: git-send-email 1.6.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akhil Goyal <akhil.goyal@freescale.com>

RF signal path is integral part of any system that transmits/receives RF
(radio frequency) signals. In these systems Data is processed/converted
to IQ samples (digital representation a RF signal) and passed to a RFIC
(RF PHY) which converts the digital RF signal (IQ samples) to analog and
transmits over antenna.

Typically The signal path consists of multiple components: 

Antenna controller <-> vector signal processors <-> RFIC <-> Antenna

Each of these components have specific functionalities: 

1. Antenna controller: Framing of digital IQ data into protocol specific frames.
2. vector signal processors: For conditioning of signal.
3. RFIC : converts digital IQ data to analog signal which is transmitted/received on/from Air.

Also it is desirable to control the complete signal path, for example:
bringing the complete signal path up/down etc. 

The radio device framework introduces a way to accommodate the RF signal
paths.  One signal path is represented as a RF device (rf0, rf1 etc), and
it can contain multiple components which have their individual vendor
specific drivers. The framework provides mechanism by which individual
components can register with RF framework, and the framework will handle the binding
of individual component devices to a RF device. RF device exports the control
interfaces to user space, and this user space interface is independent of
component (vendor specific) drivers.

This patch set include
1. RF Interface: Independent of phy or antenna controller.
2. AIC driver: Antenna interface Controller(AIC) of Hetrogenous SOC's
like BSC9131, BSC9132
3. AD9361 driver: RF Phy driver for Analog Devices(ADI) chip(AD9361)
4. Device tree bindings for AIC and ADI nodes.
5. Device tree changes for BSC9131

Akhil Goyal (5):
  drivers/misc: Support for RF interface device framework
  drivers/misc/rf: AIC: Freescale Antenna Interface controller driver
  drivers/misc: rf/ad9361: AD9361 device driver for Radio phy
  binding: Add device tree bindings for freescale AIC and AD phy
  BSC9131rdb/dts: Add nodes for supporting AIC and AD PHY

 .../devicetree/bindings/rf/ad9361-phy.txt          |   53 +
 Documentation/devicetree/bindings/rf/fsl-aic.txt   |   47 +
 Documentation/misc-devices/rf_framework            |  110 ++
 arch/powerpc/boot/dts/bsc9131rdb.dts               |    4 +
 arch/powerpc/boot/dts/bsc9131rdb.dtsi              |   38 +
 arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi      |   53 +-
 arch/powerpc/boot/dts/fsl/pq3-espi-0.dtsi          |    1 +
 arch/powerpc/boot/dts/fsl/pq3-espi-1.dtsi          |   42 +
 arch/powerpc/boot/dts/fsl/pq3-gpio-0.dtsi          |    1 +
 arch/powerpc/boot/dts/fsl/pq3-gpio-1.dtsi          |   42 +
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/rf/Kconfig                            |   37 +
 drivers/misc/rf/Makefile                           |    7 +
 drivers/misc/rf/controllers/Makefile               |    1 +
 drivers/misc/rf/controllers/fsl_aic.c              | 1560 ++++++++++++++++
 drivers/misc/rf/controllers/fsl_aic.h              |  450 +++++
 drivers/misc/rf/core/Makefile                      |    2 +
 drivers/misc/rf/core/rf_channel.c                  |  207 +++
 drivers/misc/rf/core/rfdev.c                       | 1263 +++++++++++++
 drivers/misc/rf/phy/Makefile                       |    2 +
 drivers/misc/rf/phy/ad9361.c                       | 1918 ++++++++++++++++++++
 drivers/misc/rf/phy/ad9361.h                       |  353 ++++
 include/linux/rf_channel.h                         |   26 +
 include/linux/rfdev.h                              |  250 +++
 include/uapi/linux/rfdev.h                         |  392 ++++
 26 files changed, 6858 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rf/ad9361-phy.txt
 create mode 100644 Documentation/devicetree/bindings/rf/fsl-aic.txt
 create mode 100644 Documentation/misc-devices/rf_framework
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-espi-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-gpio-1.dtsi
 create mode 100644 drivers/misc/rf/Kconfig
 create mode 100644 drivers/misc/rf/Makefile
 create mode 100644 drivers/misc/rf/controllers/Makefile
 create mode 100644 drivers/misc/rf/controllers/fsl_aic.c
 create mode 100644 drivers/misc/rf/controllers/fsl_aic.h
 create mode 100644 drivers/misc/rf/core/Makefile
 create mode 100644 drivers/misc/rf/core/rf_channel.c
 create mode 100644 drivers/misc/rf/core/rfdev.c
 create mode 100644 drivers/misc/rf/phy/Makefile
 create mode 100644 drivers/misc/rf/phy/ad9361.c
 create mode 100644 drivers/misc/rf/phy/ad9361.h
 create mode 100644 include/linux/rf_channel.h
 create mode 100644 include/linux/rfdev.h
 create mode 100644 include/uapi/linux/rfdev.h



