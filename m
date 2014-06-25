Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbaFYRJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:09:56 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:53024 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbaFYRJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:09:54 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org,
        Janne Kanniainen <janne.kanniainen@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 00/13] leds: fix attribute-creation races
Date: Wed, 25 Jun 2014 19:08:43 +0200
Message-Id: <1403716136-32694-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED-class device attributes should be created using the attribute groups
of struct device, rather than be added manually after the device has
been registered in order to avoid racing with userspace.

The first patch adds an attribute groups field to struct led_classdev,
which is used during registration to add device attributes in a
race-free manner.  

The remaining patches convert the current racy LED-device attribute
creations to use the new facility. Hopefully my grep-patterns have
caught most instances. Note that this also tends to simplify probe error
paths.

The lp55xx-common failed to remove the attribute group it is currently
creating, something which is fixed separately.

Note that this series include one driver from drivers/input/keyboard.

The individual led-driver patches have been compile tested only.

Johan


Johan Hovold (13):
  leds: add led-class attribute-group support
  leds: lm3550: fix attribute-creation race
  leds: lm3533: fix attribute-creation race
  leds: lm355x: fix attribute-creation race
  leds: lm3642: fix attribute-creation race
  leds: max8997: fix attribute-creation race
  leds: netxbig: fix attribute-creation race
  leds: ns2: fix attribute-creation race
  leds: ss4200: fix attribute-creation race
  leds: wm831x-status: fix attribute-creation race
  input: lm8323: fix attribute-creation race
  leds: lp55xx-common: fix sysfs entry leak
  leds: lp55xx-common: fix attribute-creation race

 drivers/input/keyboard/lm8323.c   | 22 +++++++++-------------
 drivers/leds/led-class.c          |  5 +++--
 drivers/leds/leds-lm3530.c        | 20 +++++++-------------
 drivers/leds/leds-lm3533.c        | 20 ++++++++------------
 drivers/leds/leds-lm355x.c        | 21 +++++++++------------
 drivers/leds/leds-lm3642.c        | 30 ++++++++++++++----------------
 drivers/leds/leds-lp55xx-common.c | 20 +++-----------------
 drivers/leds/leds-max8997.c       | 16 +++++++---------
 drivers/leds/leds-netxbig.c       | 26 ++++++++++++--------------
 drivers/leds/leds-ns2.c           | 16 +++++++---------
 drivers/leds/leds-ss4200.c        | 14 +++++++++-----
 drivers/leds/leds-wm831x-status.c | 23 +++++++++--------------
 include/linux/leds.h              |  2 ++
 13 files changed, 99 insertions(+), 136 deletions(-)

-- 
1.8.5.5

