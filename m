Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaKCUsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:48:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:22902 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbaKCUsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:48:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,308,1413270000"; 
   d="scan'208";a="616329141"
From: Stephanie Wallick <stephanie.s.wallick@intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Subject: [PATCH 00/10] MA USB drivers cover letter
Date: Mon,  3 Nov 2014 12:42:47 -0800
Message-Id: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <MA USB drivers>
References: <MA USB drivers>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Media Agnostic (MA) USB enables the USB protocol to be used over a wide
range of physical media. MA USB is a relatively new protocol and is
currently unsupported in the Linux kernel. This patch set adds the
following drivers with the following capabilities:

1) MA USB Host:
        - provides functionality of a USB Host Controller.
        - implements MA USB protocol for a MA USB host.
        - provides MA USB packet transport over TCP

2) MA USB Device:
        - provides functionality of a USB Device Controller.
        - implements MA USB protocol for a MA USB device.
        - provides MA USB packet transport over TCP


Driver overview:

The MA USB Host and Device stacks each consists of two drivers. The first
driver is the Media Agnostic (MA) layer, which interfaces with the existing
USB stack and implements the MA USB protocol as defined in the MA USB
Specification Release 1.0. The second driver is the Media Specific (MS) layer.
The MS layer interfaces with the network stack to send and receive MA USB
packets via TCP.

When an MA USB driver is loaded, the MA layer loads first and registers
itself as a USB host controller with the USB Core. The MS layer then loads
and registers itself with the MA layer. Once the MS layer is registered,
the MA layer initiates creation of a communication channel for managment/control
packets. In the case of the MA USB host, the driver the opens a TCP socket
and polls periodically for a device. In the case of the MA USB device, the
driver identifies the MA USB host by IP address, then looks for and binds to
the open TCP socket of the MA USB host. When a connection event is initiated,
the MA USB host notifies the USB core and normal USB enumeration and
configuration results with each respective USB packet translated into its
MA USB equivalent.

Tools:

1) various scripts are included to help load and unload the MA USB host and
   device drivers.

2) a utility is included to help connect, disconnect, and test the MA USB 
   host and device drivers.

References:

MA USB Specification v1.0 available at www.usb.org/developers/docs/devclass_docs/


Stephanie Wallick (10):
  added media agnostic (MA) USB HCD driver
  added media agnostic (MA) USB HCD roothubs
  added media agnostic (MA) data structures and handling
  added media agnostic (MA) USB packet handling
  added media specific (MS) TCP drivers
  added media agnostic (MA) UDC
  added media agnostic (MA) USB management packet handling
  added media agnostic (MA) USB data packet handling
  added tools for building/loading media agnostic (MA) USB drivers
  added kernel build, configuration, and TODO files

 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/mausb/Kconfig                      |   16 +
 drivers/staging/mausb/Makefile                     |    3 +
 drivers/staging/mausb/TODO                         |   14 +
 drivers/staging/mausb/drivers/Kconfig              |   34 +
 drivers/staging/mausb/drivers/Makefile             |   20 +
 drivers/staging/mausb/drivers/mausb_const.h        |  109 ++
 drivers/staging/mausb/drivers/mausb_hcd.c          |  970 +++++++++++++
 drivers/staging/mausb/drivers/mausb_hcd.h          |  171 +++
 drivers/staging/mausb/drivers/mausb_hub.c          |  851 +++++++++++
 drivers/staging/mausb/drivers/mausb_hub.h          |  128 ++
 drivers/staging/mausb/drivers/mausb_ioctl.c        |  373 +++++
 drivers/staging/mausb/drivers/mausb_ioctl.h        |   99 ++
 drivers/staging/mausb/drivers/mausb_mem-host.c     |  404 ++++++
 drivers/staging/mausb/drivers/mausb_mem-host.h     |   74 +
 drivers/staging/mausb/drivers/mausb_mem.c          |  844 +++++++++++
 drivers/staging/mausb/drivers/mausb_mem.h          |  509 +++++++
 drivers/staging/mausb/drivers/mausb_mgmt.c         |  888 ++++++++++++
 drivers/staging/mausb/drivers/mausb_mgmt.h         |   90 ++
 drivers/staging/mausb/drivers/mausb_msapi.c        |  110 ++
 drivers/staging/mausb/drivers/mausb_msapi.h        |  232 +++
 drivers/staging/mausb/drivers/mausb_pkt.c          | 1038 ++++++++++++++
 drivers/staging/mausb/drivers/mausb_pkt.h          |  914 ++++++++++++
 drivers/staging/mausb/drivers/mausb_state.h        |  184 +++
 drivers/staging/mausb/drivers/mausb_tcp-device.c   |  147 ++
 drivers/staging/mausb/drivers/mausb_tcp-host.c     |  144 ++
 drivers/staging/mausb/drivers/mausb_tcp.c          |  446 ++++++
 drivers/staging/mausb/drivers/mausb_tcp.h          |  129 ++
 drivers/staging/mausb/drivers/mausb_tx-device.c    |  847 +++++++++++
 drivers/staging/mausb/drivers/mausb_tx-host.c      | 1211 ++++++++++++++++
 drivers/staging/mausb/drivers/mausb_tx.c           |  318 +++++
 drivers/staging/mausb/drivers/mausb_tx.h           |  129 ++
 drivers/staging/mausb/drivers/mausb_udc.c          | 1488 ++++++++++++++++++++
 drivers/staging/mausb/drivers/mausb_udc.h          |  147 ++
 .../staging/mausb/scripts/build_load_connect.sh    |   69 +
 drivers/staging/mausb/scripts/load_gzero.sh        |    5 +
 drivers/staging/mausb/scripts/load_script.sh       |  125 ++
 drivers/staging/mausb/scripts/modprobify.sh        |   10 +
 drivers/staging/mausb/scripts/unload_all.sh        |   15 +
 drivers/staging/mausb/scripts/unload_gzero.sh      |    5 +
 drivers/staging/mausb/tools/mausb-util/Makefile    |   14 +
 drivers/staging/mausb/tools/mausb-util/README      |   30 +
 drivers/staging/mausb/tools/mausb-util/config.mk   |   17 +
 .../staging/mausb/tools/mausb-util/src/Android.mk  |   13 +
 .../staging/mausb/tools/mausb-util/src/Makefile    |   18 +
 .../staging/mausb/tools/mausb-util/src/connect.c   |   72 +
 .../staging/mausb/tools/mausb-util/src/connect.h   |   22 +
 drivers/staging/mausb/tools/mausb-util/src/mausb.c |  200 +++
 drivers/staging/mausb/tools/mausb-util/src/mausb.h |   64 +
 .../mausb/tools/mausb-util/src/mausb_ioctl.h       |   37 +
 drivers/staging/mausb/tools/mausb-util/src/utils.c |   94 ++
 52 files changed, 13894 insertions(+)
 create mode 100644 drivers/staging/mausb/Kconfig
 create mode 100644 drivers/staging/mausb/Makefile
 create mode 100644 drivers/staging/mausb/TODO
 create mode 100644 drivers/staging/mausb/drivers/Kconfig
 create mode 100644 drivers/staging/mausb/drivers/Makefile
 create mode 100755 drivers/staging/mausb/drivers/mausb_const.h
 create mode 100755 drivers/staging/mausb/drivers/mausb_hcd.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_hcd.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_hub.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_hub.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_ioctl.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_ioctl.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_mem-host.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_mem-host.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_mem.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_mem.h
 create mode 100755 drivers/staging/mausb/drivers/mausb_mgmt.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_mgmt.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_msapi.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_msapi.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_pkt.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_pkt.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_state.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_tcp-device.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_tcp-host.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_tcp.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_tcp.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_tx-device.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_tx-host.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_tx.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_tx.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_udc.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_udc.h
 create mode 100644 drivers/staging/mausb/scripts/build_load_connect.sh
 create mode 100644 drivers/staging/mausb/scripts/load_gzero.sh
 create mode 100644 drivers/staging/mausb/scripts/load_script.sh
 create mode 100644 drivers/staging/mausb/scripts/modprobify.sh
 create mode 100644 drivers/staging/mausb/scripts/unload_all.sh
 create mode 100644 drivers/staging/mausb/scripts/unload_gzero.sh
 create mode 100644 drivers/staging/mausb/tools/mausb-util/Makefile
 create mode 100644 drivers/staging/mausb/tools/mausb-util/README
 create mode 100644 drivers/staging/mausb/tools/mausb-util/config.mk
 create mode 100644 drivers/staging/mausb/tools/mausb-util/src/Android.mk
 create mode 100644 drivers/staging/mausb/tools/mausb-util/src/Makefile
 create mode 100644 drivers/staging/mausb/tools/mausb-util/src/connect.c
 create mode 100644 drivers/staging/mausb/tools/mausb-util/src/connect.h
 create mode 100644 drivers/staging/mausb/tools/mausb-util/src/mausb.c
 create mode 100644 drivers/staging/mausb/tools/mausb-util/src/mausb.h
 create mode 100644 drivers/staging/mausb/tools/mausb-util/src/mausb_ioctl.h
 create mode 100644 drivers/staging/mausb/tools/mausb-util/src/utils.c

-- 
1.9.1

