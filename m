Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3KTVcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:32:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab3KTVcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:32:47 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Antonio Ospite <ospite@studenti.unina.it>, simon@mungewell.org,
        case@corpsmoderne.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] input: reintroduce filtering of mt axis when the device is not multitouch
Date: Wed, 20 Nov 2013 16:32:21 -0500
Message-Id: <1384983141-31019-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices (like the PS3 Sixaxis) have a lot of absolute axis which
are mapped by hid-input on ABS_MISC and beyond. These axis interfere
with the multitouch protocol.
The kernel considers those device to be following the multitouch protocol
A, and removes the filtering of such events.

We can rely on INPUT_PROP_MT to know if the device is multitouch or not,
and then rely on mt to know if the device uses the protocol B.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 Documentation/input/multi-touch-protocol.txt | 3 ++-
 drivers/input/input.c                        | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index 420444f..b476845 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -55,7 +55,8 @@ surface. The order in which the packets appear in the event stream is not
 important.  Event filtering and finger tracking is left to user space [3].
 
 Note that type A device are requested to manually set the property
-INPUT_PROP_MT.
+INPUT_PROP_MT. If this property is not set, the absolute multitouch axis
+will be statefull, so this step is now mandatory.
 Type B devices does not need to set INPUT_PROP_MT manually, as this is done
 by calling input_mt_init_slot().
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 1198785..239639e 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -224,7 +224,8 @@ static int input_handle_abs_event(struct input_dev *dev,
 		return INPUT_IGNORE_EVENT;
 	}
 
-	is_mt_event = input_is_mt_value(code);
+	is_mt_event = test_bit(INPUT_PROP_MT, dev->propbit) &&
+			input_is_mt_value(code);
 
 	if (!is_mt_event) {
 		pold = &dev->absinfo[code].value;
-- 
1.8.3.1

