Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3JUIxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:53:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39889 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592Ab3JUIxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Stefan Kriwanek" <mail@stefankriwanek.de>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Stefan Kriwanek" <dev@stefankriwanek.de>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.252123479@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 136/149] HID: Fix Speedlink VAD Cezanne support for
 some devices
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-speedlink.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

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
@@ -48,8 +48,13 @@ static int speedlink_event(struct hid_de
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

