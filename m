Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaIOKfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:35:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36813 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752451AbaIOKfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:35:13 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sergei.shtylyov@cogentembedded.com, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/9] usb: add support for the generic PHY framework
Date: Mon, 15 Sep 2014 12:35:00 +0200
Message-Id: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
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

Step 1 is in the first patch. Steps 2 and 3 are done for OTG, and ChipIdea
subsystems in patches 2-3, 7 and 9.

HCD generic PHY support was made by Sergei and Yoshihiro[1]. I added some
modifications to make this support consistent with this series in patches
4-6.

The usb_otg has been moved into the ci_hdrc structure in ChipIdea, in patch 8.

I tested it by using the ChipIdea driver I introduced, both with an USB PHY
and a PHY driver successfully. I also compiled a multi_v7 kernel (ARM), with
every driver I could enable in the USB section.

Patches can also be found at:
git://git.free-electrons.com:users/antoine-tenart/linux.git usb-phy

The series applies on top of Sergei and Yoshihiro generic PHY support in
HCD[2] and on top of Peter Chen's ci-for-usb-next branch[3].

Thanks a lot!

Antoine


Changes since v4:
	- reworked the PHY handling in ci_hdrc_probe()
	- fixed a rebase error
	- rebased on top of [3]

Changes since v3:
        - moved phy_exit() after phy_power_on()
        - fixed the PHY handling in ci_hdrc_probe()
        - some little fixes

Changes since v2:
        - rebased the series on top of v3.17-rc1 (and [2])
        - switched to devm_phy_get() to handle non DT cases
        - moved usb_otg into the ci_hdrc structure

Changes since v1:
        - rebased the series on top of [2] (generic PHY support for HCD)
        - split s/phy/usb_phy/ renaming and generic PHY support in separate
          patches

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/272840.html
[2] https://www.mail-archive.com/linux-usb@vger.kernel.org/msg43471.html
[3] git://github.com/hzpeterchen/linux-usb.git ci-for-usb-next

Antoine Tenart (9):
  usb: move the OTG state from the USB PHY to the OTG structure
  usb: rename phy to usb_phy in OTG
  usb: add support to the generic PHY framework in OTG
  usb: rename phy to usb_phy in HCD
  usb: rename gen_phy to phy in HCD
  usb: allow to supply the PHY in the drivers when using HCD
  usb: rename transceiver and phy to usb_phy in ChipIdea
  usb: chipidea: move usb_otg into struct ci_hdrc
  usb: chipidea: add support to the generic PHY framework in ChipIdea

 drivers/phy/phy-omap-usb2.c         | 14 ++----
 drivers/usb/chipidea/ci.h           |  8 +++-
 drivers/usb/chipidea/ci_hdrc_imx.c  |  2 +-
 drivers/usb/chipidea/ci_hdrc_msm.c  |  8 ++--
 drivers/usb/chipidea/core.c         | 89 ++++++++++++++++++++++++++--------
 drivers/usb/chipidea/debug.c        |  2 +-
 drivers/usb/chipidea/host.c         | 10 ++--
 drivers/usb/chipidea/otg_fsm.c      | 30 +++++-------
 drivers/usb/chipidea/udc.c          |  4 +-
 drivers/usb/common/usb-otg-fsm.c    |  8 ++--
 drivers/usb/core/hcd.c              | 45 +++++++++---------
 drivers/usb/core/hub.c              |  8 ++--
 drivers/usb/host/ehci-fsl.c         | 16 +++----
 drivers/usb/host/ehci-hub.c         |  2 +-
 drivers/usb/host/ehci-msm.c         |  4 +-
 drivers/usb/host/ehci-tegra.c       | 16 +++----
 drivers/usb/host/ohci-omap.c        | 20 ++++----
 drivers/usb/misc/lvstest.c          |  8 ++--
 drivers/usb/musb/am35x.c            | 28 +++++------
 drivers/usb/musb/blackfin.c         | 18 +++----
 drivers/usb/musb/da8xx.c            | 28 +++++------
 drivers/usb/musb/davinci.c          | 18 +++----
 drivers/usb/musb/musb_core.c        | 94 ++++++++++++++++++------------------
 drivers/usb/musb/musb_dsps.c        | 26 +++++-----
 drivers/usb/musb/musb_gadget.c      | 36 +++++++-------
 drivers/usb/musb/musb_host.c        |  8 ++--
 drivers/usb/musb/musb_virthub.c     | 22 ++++-----
 drivers/usb/musb/omap2430.c         | 30 ++++++------
 drivers/usb/musb/tusb6010.c         | 40 ++++++++--------
 drivers/usb/musb/ux500.c            | 10 ++--
 drivers/usb/phy/phy-ab8500-usb.c    | 16 +++----
 drivers/usb/phy/phy-fsl-usb.c       | 23 ++++-----
 drivers/usb/phy/phy-generic.c       |  6 +--
 drivers/usb/phy/phy-gpio-vbus-usb.c | 14 +++---
 drivers/usb/phy/phy-isp1301-omap.c  | 10 ++--
 drivers/usb/phy/phy-msm-usb.c       | 95 +++++++++++++++++++------------------
 drivers/usb/phy/phy-mv-usb.c        | 50 +++++++++----------
 drivers/usb/phy/phy-samsung-usb2.c  |  2 +-
 drivers/usb/phy/phy-tahvo.c         |  8 ++--
 drivers/usb/phy/phy-ulpi.c          |  6 +--
 include/linux/usb/chipidea.h        |  4 +-
 include/linux/usb/hcd.h             |  6 ++-
 include/linux/usb/otg.h             |  7 ++-
 include/linux/usb/phy.h             |  1 -
 44 files changed, 480 insertions(+), 420 deletions(-)

-- 
1.9.1

