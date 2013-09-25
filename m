Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3IYAdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:33:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab3IYAUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Kriwanek <mail@stefankriwanek.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 074/117] HID: Fix Speedlink VAD Cezanne support for some devices
Date: Tue, 24 Sep 2013 17:19:00 -0700
Message-Id: <20130925001749.035910690@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-speedlink.c |   11 ++++++++---
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
@@ -46,8 +46,13 @@ static int speedlink_event(struct hid_de
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


