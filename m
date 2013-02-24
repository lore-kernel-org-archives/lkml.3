Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab3BXUqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 15:46:37 -0500
Received: from ven69-h01-31-33-9-98.dsl.sta.abo.bbox.fr ([31.33.9.98]:54258
	"EHLO laptop-kevin.kbaradon.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757221Ab3BXUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 15:46:35 -0500
From: Kevin Baradon <kevin.baradon@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Baradon <kevin.baradon@gmail.com>
Subject: [PATCH 2/2] media/rc/imon.c: avoid flooding syslog with "unknown keypress" when keypad is pressed
Date: Sun, 24 Feb 2013 21:19:30 +0100
Message-Id: <1361737170-4687-3-git-send-email-kevin.baradon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361737170-4687-1-git-send-email-kevin.baradon@gmail.com>
References: <1361737170-4687-1-git-send-email-kevin.baradon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My 15c2:0036 device floods syslog when a keypad key is pressed:

Feb 18 19:00:57 homeserver kernel: imon 5-1:1.0: imon_incoming_packet: unknown keypress, code 0x100fff2
Feb 18 19:00:57 homeserver kernel: imon 5-1:1.0: imon_incoming_packet: unknown keypress, code 0x100fef2
Feb 18 19:00:57 homeserver kernel: imon 5-1:1.0: imon_incoming_packet: unknown keypress, code 0x100fff2
Feb 18 19:00:57 homeserver kernel: imon 5-1:1.0: imon_incoming_packet: unknown keypress, code 0x100fff2
Feb 18 19:00:57 homeserver kernel: imon 5-1:1.0: imon_incoming_packet: unknown keypress, code 0x100fff2

This patch lowers severity of this message when key appears to be coming from keypad.

Signed-off-by: Kevin Baradon <kevin.baradon@gmail.com>
---
 drivers/media/rc/imon.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index a3e66a0..bca03d4 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1499,7 +1499,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	int i;
 	u64 scancode;
 	int press_type = 0;
-	int msec;
+	int msec, is_pad_key = 0;
 	struct timeval t;
 	static struct timeval prev_time = { 0, 0 };
 	u8 ktype;
@@ -1562,6 +1562,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	    ((len == 8) && (buf[0] & 0x40) &&
 	     !(buf[1] & 0x1 || buf[1] >> 2 & 0x1))) {
 		len = 8;
+		is_pad_key = 1;
 		imon_pad_to_keys(ictx, buf);
 	}
 
@@ -1625,8 +1626,16 @@ static void imon_incoming_packet(struct imon_context *ictx,
 
 unknown_key:
 	spin_unlock_irqrestore(&ictx->kc_lock, flags);
-	dev_info(dev, "%s: unknown keypress, code 0x%llx\n", __func__,
-		 (long long)scancode);
+	/*
+	 * On some devices syslog is flooded with unknown keypresses when keypad
+	 * is pressed. Lower message severity in that case.
+	 */
+	if (!is_pad_key)
+		dev_info(dev, "%s: unknown keypress, code 0x%llx\n", __func__,
+			 (long long)scancode);
+	else
+		dev_dbg(dev, "%s: unknown keypad keypress, code 0x%llx\n",
+			__func__, (long long)scancode);
 	return;
 
 not_input_data:
-- 
1.7.10.4

