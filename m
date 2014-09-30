Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaI3RSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:18:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbaI3RSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:46 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 00/13] HID: add support of Logitech touchpads and special devices
Date: Tue, 30 Sep 2014 13:18:22 -0400
Message-Id: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Well this patch series is really an old guy:
- I started on this back in 2011 during my short appearance at Logitech
- it has been updated a few time since
- part of it is already shipped in ChromeOS
- now is the time to push it upstream (hopefully)

So, basically, this patch series aims at supporting the touchpads made by
Logitech (i.e. report the raw multi touch events), plus it also gives a driver
to enable special "features" of other various Logitech devices as reported
here[1].

There are couple of changes I introduced in this submission compared to what
Logitech and ChromeOS used to see:
- there will be only one driver for HID++ devices: hid-logitech-hidpp (this way,
  we are trying to stay in the line of the HID subsystem, one HID driver per
  vendor)
- hid-logitech-dj only deals with the transport layer, so it does not depend on
  hid-logitech-hidpp
- there is no more callbacks mechanism in hidpp and the specific drivers, all
  is handled in one place
- there is no need of a blacklist in hid-logitech-dj to decide if the device has
  a subdriver or not.
- there is no support of the mice with raw touch. This can be added in a future
  patch series.

I am finally finding this ready to be sent upstream, so I hope some of you would
be kind enough to review the code.

Regarding the features, here is what end user will expect/see:
- all the DJ devices (connected through the unifying wirelees receiver) have a
  proper name now (T400, M325, ...). This name is retrieved from the receiver
  which has a short buffer for it, thus the short name.
- the touchpads input devices will be created once the device is actually
  connected. For bluetooth device, it's a normal HID process. For DJ devices,
  the receiver is created, the hidraw device of the touchpad is created, but the
  input device, with the full name (asked from the device) appears on the first
  connection (or events).
- The TK820 - keyboard/touchpad combo presents now 2 input devices. One for the
  keyboard part, one for the touchpad. So X and libinput can deal with it
  easily.

Jiri, This patch series can be split in 2 if you would like:
- patches 1 to 4 can be scheduled easily for 3.18 IMO
- patches 5 to 13 might need some more reviews, so either 3.18 or 3.19

Cheers,
Benjamin

[1] https://www.mail-archive.com/linux-input@vger.kernel.org/msg11831.html

Benjamin Tissoires (13):
  HID: fix merge from wacom into the HID tree
  HID: core: do not scan reports if the group is already set
  HID: logitech-dj: rely on hid groups to separate receivers from dj
    devices
  HID: logitech-dj: merge header file into the source
  HID: Introduce hidpp, a module to handle Logitech hid++ devices
  HID: logitech: move dj devices to the HID++ module
  HID: logitech-dj: allow transfer of HID++ reports from/to the correct
    dj device
  HID: logitech: allow the DJ device to request the unifying name
  HID: logitech-dj: enable notifications on connect/disconnect
  HID: logitech-hidpp: late bind the input device on wireless connection
  HID: logitech-hidpp: Add Wireless Touchpad T650 support
  HID: logitech-hidpp: add support of the first Logitech Wireless
    Touchpad
  HID: logitech-hidpp: support combo keyboard touchpad TK820

 drivers/hid/Kconfig              |   12 +
 drivers/hid/Makefile             |    1 +
 drivers/hid/hid-core.c           |   21 +-
 drivers/hid/hid-ids.h            |    1 +
 drivers/hid/hid-logitech-dj.c    |  397 ++++++++++---
 drivers/hid/hid-logitech-dj.h    |  125 ----
 drivers/hid/hid-logitech-hidpp.c | 1201 ++++++++++++++++++++++++++++++++++++++
 include/linux/hid.h              |    5 +-
 8 files changed, 1526 insertions(+), 237 deletions(-)
 delete mode 100644 drivers/hid/hid-logitech-dj.h
 create mode 100644 drivers/hid/hid-logitech-hidpp.c

-- 
2.1.0

