Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaKLGjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 01:39:09 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50464 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaKLGjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 01:39:08 -0500
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
Subject: [RFC v6 0/3] usb: phy: hold wakeupsource on usb phy events.
Date: Wed, 12 Nov 2014 12:08:39 +0530
Message-Id: <1415774319-21682-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set aims to hold wakeupsource per-PHY on usb connect/disconnect
events.

First patch introduces usb_phy_set_event  which just sets
event to phy event.
In second patch, phy drivers call usb_phy_set_event for each phy event.
In third patch, wakeupsource is held when usb is enumerated in 
peripheral mode and wakeupsource held temporarily on disconnect
event(to allow other parts of the system react to disconnect event).

v6:
* Break the patch into three sub patches
  patch 1: Introduce usb_phy_set_event
  patch 2: Call usb_phy_set_event from phy drivers
  patch 3: Hold wakeupsource for connect events and
            temporarily hold wakeupsource for disconnect events.
* Include usb_phy_wsource_init and usb_phy_wource_trash functionality
  in usb_add_phy and usb_remove_phy respectively.

v5:
* with the new approach,i was able to chnage only 5 phy drivers
  as mentioned below to use the wakeupsource funtionality.

drivers/phy/phy-omap-control.c
drivers/usb/phy/phy-ab8500-usb.c
drivers/usb/phy/phy-tahvo.c
drivers/usb/phy/phy-mv-usb.c
drivers/usb/phy/phy-gpio-vbus-usb.c

* Notification method not used any more.
* introduced usb_phy_set_event in phy.c to hold wakeupsource
* introduced usb_phy_wsource_init/usb_phy_wsource_trash in phy.c to
  initialize/relese per-PHY wakeupsource.These interfaces called from
  probe/remove functions of phy drivers.
* usb_phy_set_event called from phy drivers where usb enumeration
  event is handled.
* usb_phy_set_event expects usb_phy handle where as phy-omap-control.c
  provides its own type(omap_control_phy), so directly called __pm_stay_awake
  and  __pm_awake_event from phy-omap-control.c instead of calling
  usb_phy_set_event.

v4:
* Temporarily hold wakeupsource patch integrated into main patch.
* As per feedback,dropped "enabled" module parameter.
* Introduced otgws_otg_usb3_notifications function to handle event
  notifications from usb3 phy.
* Handled wakeupsource initialization,spinlock,registration of notifier block
  per-PHY.
* Updated usb_phy structure.

v3:
* As per the feedback,no global phy pointer used.
* called the one-liner wakeupsource handling calls
  directly instead of indirect functions implemented in v2.
* Removed indirect function get_phy_hook and used usb_get_phy
  to get the phy handle..

v2:
* wakeupsource handling implemeted per-PHY
* Implemented wakeupsource handling calls in phy
* included Todd's refactoring logic.

v1:
* changed to "disabled by default" from "enable by default".
* Kconfig help text modified
* Included better commit text
* otgws_nb moved to otg_wakeupsource_init function
* Introduced get_phy_hook to handle otgws_xceiv per-PHY

Initial RFC:
* Included build fix from Benoit Goby and Arve Hjønnevåg
* Removed lock->held field in driver as this mechanism is
  provided in wakeupsource driver.
* wakelock(wl) terminology replaced with wakeup_source(ws).

Todd Poynor (3):
  usb: phy: introduce usb_phy_set_event interface
  usb: phy: Handle per-PHY event for connect and disconnect events
  usb: phy: Hold wakeupsource when USB is enumerated in peripheral mode

 drivers/usb/phy/phy-ab8500-usb.c    | 15 +++++++++++++++
 drivers/usb/phy/phy-gpio-vbus-usb.c |  2 ++
 drivers/usb/phy/phy-mv-usb.c        |  2 ++
 drivers/usb/phy/phy-tahvo.c         |  2 ++
 drivers/usb/phy/phy.c               | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/usb/phy.h             | 10 ++++++++++
 6 files changed, 68 insertions(+)

-- 
1.8.2.1

