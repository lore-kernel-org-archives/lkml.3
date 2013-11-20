Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3KTVcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:32:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab3KTVcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:32:42 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Antonio Ospite <ospite@studenti.unina.it>, simon@mungewell.org,
        case@corpsmoderne.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Fixes for multitouch / generic gamepads interaction
Date: Wed, 20 Nov 2013 16:32:18 -0500
Message-Id: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I have been reported recently a problem with the Sixaxis controller
(http://www.spinics.net/lists/linux-input/msg28098.html).
The root of the problem comes from hid-input, which maps unknown axis to
ABS_MISC. However, when an event code is already in use, hid-input uses the one
after, leading to uses of ABS_MISC + N, where N is the number of unknown axis.

We are encountering a problem with the multitouch protocol here because if a
device has more than 7 unknown axis (which is the case for the PS3 Sixaxis
controller), then the unknown axis get maps to ABS_MT_SLOT and beyond.

This infers two problems:
- the axis currently mapped on ABS_MT_SLOT is a special case in the kernel,
and it is not updated
- the axis after ABS_MT_SLOT are not filtered anymore, as the kernel things
the device is using a multitouch protocol A.

The patch 0001 solves the first problem, whereas the patches 0002 and 0003
fix the second. Bonus point: the userspace is now correctly notified that one of
the multitouch protocols is in used, so it does not have to rely on bad designed
heuristics.

Cheers,
Benjamin

Antonio Ospite (1):
  Only process ABS_MT_SLOT where there are slots available

Benjamin Tissoires (2):
  input: Introduce INPUT_PROP_MT
  input: reintroduce filtering of mt axis when the device is not
    multitouch

 Documentation/input/event-codes.txt          | 7 +++++++
 Documentation/input/multi-touch-protocol.txt | 6 ++++++
 drivers/hid/hid-ntrig.c                      | 1 +
 drivers/input/input-mt.c                     | 2 ++
 drivers/input/input.c                        | 7 ++++---
 drivers/input/touchscreen/auo-pixcir-ts.c    | 1 +
 drivers/input/touchscreen/bu21013_ts.c       | 1 +
 drivers/input/touchscreen/pixcir_i2c_ts.c    | 1 +
 drivers/input/touchscreen/st1232.c           | 1 +
 include/uapi/linux/input.h                   | 1 +
 10 files changed, 25 insertions(+), 3 deletions(-)

-- 
1.8.3.1

