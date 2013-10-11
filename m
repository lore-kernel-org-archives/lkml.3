Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab3JKKms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:42:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58423 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab3JKKmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Kriwanek <mail@stefankriwanek.de>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 021/100] HID: Fix Speedlink VAD Cezanne support for some devices
Date: Fri, 11 Oct 2013 11:40:51 +0100
Message-Id: <1381488130-30235-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Kriwanek <dev@stefankriwanek.de>

commit 06bb5219118fb098f4b0c7dcb484b28a52bf1c14 upstream.

Some devices of the "Speedlink VAD Cezanne" model need more aggressive fixing
than already done.

I made sure through testing that this patch would not interfere with the proper
working of a device that is bug-free. (The driver drops EV_REL events with
abs(val) >= 256, which are not achievable even on the highest laser resolution
hardware setting.)

Signed-off-by: Stefan Kriwanek <mail@stefankriwanek.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-speedlink.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-speedlink.c b/drivers/hid/hid-speedlink.c
index 6020137..2b03c9b 100644
--- a/drivers/hid/hid-speedlink.c
+++ b/drivers/hid/hid-speedlink.c
@@ -3,7 +3,7 @@
  *  Fixes "jumpy" cursor and removes nonexistent keyboard LEDS from
  *  the HID descriptor.
  *
- *  Copyright (c) 2011 Stefan Kriwanek <mail@stefankriwanek.de>
+ *  Copyright (c) 2011, 2013 Stefan Kriwanek <dev@stefankriwanek.de>
  */
 
 /*
@@ -48,8 +48,13 @@ static int speedlink_event(struct hid_device *hdev, struct hid_field *field,
 		struct hid_usage *usage, __s32 value)
 {
 	/* No other conditions due to usage_table. */
-	/* Fix "jumpy" cursor (invalid events sent by device). */
-	if (value == 256)
+
+	/* This fixes the "jumpy" cursor occuring due to invalid events sent
+	 * by the device. Some devices only send them with value==+256, others
+	 * don't. However, catching abs(value)>=256 is restrictive enough not
+	 * to interfere with devices that were bug-free (has been tested).
+	 */
+	if (abs(value) >= 256)
 		return 1;
 	/* Drop useless distance 0 events (on button clicks etc.) as well */
 	if (value == 0)
-- 
1.8.3.2

