Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaGIKTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:19:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45236 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753137AbaGIKTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:19:47 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] usb: add support for the generic PHY framework
Date: Wed,  9 Jul 2014 12:17:12 +0200
Message-Id: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is an attempt to add more common USB code aware of the generic PHY
framework, while keeping the compatibility for the USB PHY one. It does
not add the full support, some USB PHY specific functions not being
available currently in the generic PHY subsystem (e.g. usb_phy_set_power()).
But it allows to use the generic PHY framework in other cases, and might
help others to convert their USB PHY drivers.

A little background: I submitted a series to support USB on Berlin SoCs[1].
One patch added a new PHY driver in drivers/usb/phy and Felipe asked it to
be in the generic PHY framework instead[2]. This PHY being used by a ChipIdea
driver, changes were needed in ChipIdea, OTG and HCD.

This is done in 3 steps:
	1. moving the OTG state from the USB PHY structure to the OTG one
	2. renaming the field 'phy' to 'usb_phy'
	3. adding a field for the generic framework PHY and dissociating its
	   use from the USB PHY one

Step 1 is in the first patch. Steps 2 and 3 are done in OTG, HCD and CHipIdea
subsystems in patches 2 to 4 (one per subsystem).

I tested it by using the ChipIdea driver I introduced, both with an USB PHY
and a PHY driver successfully. I also compiled a multi_v7 kernel, with every
driver I could enable in the USB section.

I'd like more people to test and your inputs and suggestions on these changes.

Feel free to add Ccs if others might be interested in this. If needed patches
can be squashed or divided, I tried there to group modifications by USB
framework parts (OTG, HCD, ChipIdea).

Patches can also be found at:
git://git.free-electrons.com:users/antoine-tenart/linux.git usb-phy

Thanks a lot!

Antoine

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/265888.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/267981.html

Antoine Ténart (4):
  usb: move the OTG state from the USB PHY to the OTG structure
  usb: add support to the PHY framework for OTG
  usb: add support to the PHY framework for HCD
  usb: chipidea: add support to the PHY framework for ChipIdea

 drivers/phy/phy-omap-usb2.c         | 14 ++----
 drivers/usb/chipidea/ci.h           |  4 +-
 drivers/usb/chipidea/ci_hdrc_imx.c  |  2 +-
 drivers/usb/chipidea/ci_hdrc_msm.c  |  6 +--
 drivers/usb/chipidea/core.c         | 67 +++++++++++++++++++++-----
 drivers/usb/chipidea/debug.c        |  5 +-
 drivers/usb/chipidea/host.c         | 17 ++++---
 drivers/usb/chipidea/otg_fsm.c      | 18 +++----
 drivers/usb/chipidea/udc.c          |  4 +-
 drivers/usb/common/usb-otg-fsm.c    |  8 ++--
 drivers/usb/core/hcd.c              | 61 +++++++++++++++++-------
 drivers/usb/core/hub.c              |  8 ++--
 drivers/usb/host/ehci-fsl.c         | 16 +++----
 drivers/usb/host/ehci-hub.c         |  2 +-
 drivers/usb/host/ehci-msm.c         |  4 +-
 drivers/usb/host/ehci-tegra.c       | 16 +++----
 drivers/usb/host/ohci-omap.c        | 20 ++++----
 drivers/usb/musb/am35x.c            | 28 +++++------
 drivers/usb/musb/blackfin.c         | 18 +++----
 drivers/usb/musb/da8xx.c            | 28 +++++------
 drivers/usb/musb/davinci.c          | 18 +++----
 drivers/usb/musb/musb_core.c        | 94 ++++++++++++++++++-------------------
 drivers/usb/musb/musb_dsps.c        | 26 +++++-----
 drivers/usb/musb/musb_gadget.c      | 36 +++++++-------
 drivers/usb/musb/musb_host.c        |  8 ++--
 drivers/usb/musb/musb_virthub.c     | 22 ++++-----
 drivers/usb/musb/omap2430.c         | 30 ++++++------
 drivers/usb/musb/tusb6010.c         | 40 ++++++++--------
 drivers/usb/musb/ux500.c            | 10 ++--
 drivers/usb/phy/phy-ab8500-usb.c    | 16 +++----
 drivers/usb/phy/phy-fsl-usb.c       | 22 ++++-----
 drivers/usb/phy/phy-generic.c       |  6 +--
 drivers/usb/phy/phy-gpio-vbus-usb.c | 12 ++---
 drivers/usb/phy/phy-isp1301-omap.c  | 10 ++--
 drivers/usb/phy/phy-msm-usb.c       | 93 ++++++++++++++++++------------------
 drivers/usb/phy/phy-mv-usb.c        | 50 ++++++++++----------
 drivers/usb/phy/phy-samsung-usb2.c  |  2 +-
 drivers/usb/phy/phy-tahvo.c         |  8 ++--
 drivers/usb/phy/phy-ulpi.c          |  6 +--
 include/linux/usb/chipidea.h        |  4 +-
 include/linux/usb/hcd.h             |  5 +-
 include/linux/usb/otg.h             |  7 ++-
 include/linux/usb/phy.h             |  1 -
 43 files changed, 481 insertions(+), 391 deletions(-)

-- 
1.9.1

