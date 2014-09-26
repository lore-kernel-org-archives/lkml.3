Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbaIZK6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:58:39 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:44551 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbaIZK6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:58:35 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/6] mfd: fix platform-device id collisions
Date: Fri, 26 Sep 2014 12:55:27 +0200
Message-Id: <1411728933-13351-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hot-pluggable multi-function devices should always be registered with
PLATFORM_DEVID_AUTO to avoid name collisions on the platform bus.

This series fix the two mfd drivers that currently fail to get this
right, and also adds a new helper function to assist any future driver
authors.

Included is also a fix of how mfd core generates the platform ids for
subdevices. Currently, the mfd cell-id is simply added to the id base
that mfd_add_devices is called with. This effectively prevents
mfd-devices from using PLATFORM_DEVID_AUTO (-2) while still having
non-zero cell ids.

In a different thread I mentioned that using for example

	bus_num << 8 | dev_num

as an id-base for USB multi-function devices would also avoid any
collisions, but encoding the bus topology in the id base like this
is not good idea. [1] Not only would it force any new transports to come
up with unique id bases, it would also be very ad-hoc differ from driver
to driver (consider multi-interface USB devices or non-zero cell ids).

Note that if userspace needs to find sibling interfaces it should
never rely on device naming anyway, but rather use the topology already
encoded in sysfs.

The only thing that is currently not possible trough sysfs is to figure
out which sibling interface is which should they have the same name but
unique cell ids (consider an MFD with multiple leds or gpio chips).
Again, parsing device ids is not an option, but if needed we could
simply let driver core export any mfd cell-id for platform devices. Note
that the final patch is a pre-requisite for this.

Johan

[1] http://marc.info/?l=linux-kernel&m=141094514827834&w=2


Johan Hovold (6):
  mfd: viperboard: fix platform-device id collision
  mfd: rtsx_usb: fix platform device-id collision
  mfd: core: add helper function to register hotplug devices
  mfd: use mfd_add_hotplug_devices helper
  HID: hid-sensor-hub: use mfd_add_hotplug_devices helper
  mfd: core: fix platform-device id generation

 drivers/hid/hid-sensor-hub.c | 8 +++-----
 drivers/mfd/mfd-core.c       | 8 +++++++-
 drivers/mfd/rtsx_usb.c       | 4 ++--
 drivers/mfd/viperboard.c     | 4 ++--
 include/linux/mfd/core.h     | 7 +++++++
 5 files changed, 21 insertions(+), 10 deletions(-)

-- 
1.8.5.5

