Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab3GHJui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:50:38 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:16161
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108Ab3GHJuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:50:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: <akhil.goyal@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>, <lars@metafoo.de>,
        <robin.getz@analog.com>, <Michael.Hennerich@analog.com>,
        <lars-peter.clausen@analog.com>
CC: <linux-kernel@vger.kernel.org>, <pankaj.chauhan@freescale.com>,
        Akhil Goyal <akhil.goyal@freescale.com>
Subject: [PATCH v2 0/4] Radio device framework
Date: Mon, 8 Jul 2013 15:19:58 +0530
Message-ID: <1373277002-14009-1-git-send-email-akhil.goyal@freescale.com>
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
4. Device tree bindings for AIC.
5. Device tree changes for BSC9131-AIC

changes in v2:
1. incorporated comments for handling pointers in user space API structures.
2. Removed patches for AD9361 phy driver. It shall be sent once a proper
driver is in place for AD9361 chip
3. Removed Device tree nodes/bindings for AD9361
4. Incorporated comments for proper handling of wait_events
5. Added Documentation for IOCTL APIs and the structures used.
6. Inserted paddings in user space structures.
7. Reorganized code for rfdev.c to remove forward declaration and broke the
rf_ioctl() function to handle local structures correctly.
8. Corrected the error handling for mutex used.

Akhil Goyal (4):
  drivers/misc: Support for RF interface device framework
  drivers/misc/rf: AIC: Freescale Antenna Interface controller driver
  binding: Add device tree bindings for freescale AIC
  BSC9131rdb/dts: Add nodes for supporting AIC

 Documentation/devicetree/bindings/rf/fsl-aic.txt |   47 +
 Documentation/misc-devices/rf_framework          |  422 ++++++
 arch/powerpc/boot/dts/bsc9131rdb.dts             |    4 +
 arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi    |   38 +
 drivers/misc/Kconfig                             |    1 +
 drivers/misc/Makefile                            |    1 +
 drivers/misc/rf/Kconfig                          |   30 +
 drivers/misc/rf/Makefile                         |    6 +
 drivers/misc/rf/controllers/Makefile             |    1 +
 drivers/misc/rf/controllers/fsl_aic.c            | 1560 ++++++++++++++++++++++
 drivers/misc/rf/controllers/fsl_aic.h            |  450 +++++++
 drivers/misc/rf/core/Makefile                    |    2 +
 drivers/misc/rf/core/rf_channel.c                |  211 +++
 drivers/misc/rf/core/rfdev.c                     | 1384 +++++++++++++++++++
 include/linux/rf_channel.h                       |   25 +
 include/linux/rfdev.h                            |  251 ++++
 include/uapi/linux/rfdev.h                       |  367 +++++
 17 files changed, 4800 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rf/fsl-aic.txt
 create mode 100644 Documentation/misc-devices/rf_framework
 create mode 100644 drivers/misc/rf/Kconfig
 create mode 100644 drivers/misc/rf/Makefile
 create mode 100644 drivers/misc/rf/controllers/Makefile
 create mode 100644 drivers/misc/rf/controllers/fsl_aic.c
 create mode 100644 drivers/misc/rf/controllers/fsl_aic.h
 create mode 100644 drivers/misc/rf/core/Makefile
 create mode 100644 drivers/misc/rf/core/rf_channel.c
 create mode 100644 drivers/misc/rf/core/rfdev.c
 create mode 100644 include/linux/rf_channel.h
 create mode 100644 include/linux/rfdev.h
 create mode 100644 include/uapi/linux/rfdev.h



