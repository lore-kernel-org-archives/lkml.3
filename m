Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaJSKWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 06:22:16 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:60426 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaJSKWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 06:22:14 -0400
From: Tomas Melin <tomas.melin@iki.fi>
To: m.chehab@samsung.com, david@hardeman.nu
Cc: james.hogan@imgtec.com, a.seppala@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tomas Melin <tomas.melin@iki.fi>
Subject: [PATCH 1/2] [media] rc-core: fix protocol_change regression in ir_raw_event_register
Date: Sun, 19 Oct 2014 13:21:52 +0300
Message-Id: <1413714113-7456-1-git-send-email-tomas.melin@iki.fi>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IR reciever using nuvoton-cir and lirc was not working anymore after
upgrade from kernel 3.16 to 3.17-rcX.
Bisected regression to commit da6e162d6a4607362f8478c715c797d84d449f8b
("[media] rc-core: simplify sysfs code").

The regression comes from adding empty function change_protocol in
ir-raw.c. It changes behaviour so that only the protocol enabled by driver's
map_name will be active after registration. This breaks user space behaviour,
lirc does not get key press signals anymore.

Changed back to original behaviour by removing empty function
change_protocol in ir-raw.c. Instead only calling change_protocol for
drivers that actually have the function set up.

Signed-off-by: Tomas Melin <tomas.melin@iki.fi>
---
 drivers/media/rc/rc-ir-raw.c |    7 -------
 drivers/media/rc/rc-main.c   |   19 ++++++++-----------
 2 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index e8fff2a..a118539 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -240,12 +240,6 @@ ir_raw_get_allowed_protocols(void)
 	return protocols;
 }
 
-static int change_protocol(struct rc_dev *dev, u64 *rc_type)
-{
-	/* the caller will update dev->enabled_protocols */
-	return 0;
-}
-
 /*
  * Used to (un)register raw event clients
  */
@@ -263,7 +257,6 @@ int ir_raw_event_register(struct rc_dev *dev)
 
 	dev->raw->dev = dev;
 	dev->enabled_protocols = ~0;
-	dev->change_protocol = change_protocol;
 	rc = kfifo_alloc(&dev->raw->kfifo,
 			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
 			 GFP_KERNEL);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index a7991c7..633c682 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1001,11 +1001,6 @@ static ssize_t store_protocols(struct device *device,
 		set_filter = dev->s_wakeup_filter;
 	}
 
-	if (!change_protocol) {
-		IR_dprintk(1, "Protocol switching not supported\n");
-		return -EINVAL;
-	}
-
 	mutex_lock(&dev->lock);
 
 	old_protocols = *current_protocols;
@@ -1013,12 +1008,14 @@ static ssize_t store_protocols(struct device *device,
 	rc = parse_protocol_change(&new_protocols, buf);
 	if (rc < 0)
 		goto out;
-
-	rc = change_protocol(dev, &new_protocols);
-	if (rc < 0) {
-		IR_dprintk(1, "Error setting protocols to 0x%llx\n",
-			   (long long)new_protocols);
-		goto out;
+	/* Only if protocol change set up in driver */
+	if (change_protocol) {
+		rc = change_protocol(dev, &new_protocols);
+		if (rc < 0) {
+			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
+				   (long long)new_protocols);
+			goto out;
+		}
 	}
 
 	if (new_protocols == old_protocols) {
-- 
1.7.10.4

