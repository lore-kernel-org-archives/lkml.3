Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaAFPIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:08:43 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47872 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaAFPIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:08:41 -0500
From: Ethan Zhao <ethan.kernel@gmail.com>
To: hans.verkuil@cisco.com, m.chehab@samsung.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Ethan Zhao <ethan.kernel@gmail.com>
Subject: [PATCH] [media] cx18: introduce a helper function to avoid array overrun
Date: Mon,  6 Jan 2014 23:07:06 +0800
Message-Id: <1389020826-807-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cx18_i2c_register() is called in cx18_init_subdevs() with index
greater than length of hw_bus array, that will cause array overrun,
introduce a helper cx18_get_max_bus_num() to avoid it.

V2: fix a typo and use ARRAY_SIZE macro

Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
---
 drivers/media/pci/cx18/cx18-driver.c | 2 +-
 drivers/media/pci/cx18/cx18-i2c.c    | 5 +++++
 drivers/media/pci/cx18/cx18-i2c.h    | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 6386ced..dadcd4a 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -856,7 +856,7 @@ static void cx18_init_subdevs(struct cx18 *cx)
 	u32 device;
 	int i;
 
-	for (i = 0, device = 1; i < 32; i++, device <<= 1) {
+	for (i = 0, device = 1; i < cx18_get_max_bus_num(); i++, device <<= 1) {
 
 		if (!(device & hw))
 			continue;
diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
index 4af8cd6..1a7b49b 100644
--- a/drivers/media/pci/cx18/cx18-i2c.c
+++ b/drivers/media/pci/cx18/cx18-i2c.c
@@ -108,6 +108,11 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 	       -1 : 0;
 }
 
+int cx18_get_max_bus_num(void)
+{
+	return ARRAY_SIZE(hw_bus);
+}
+
 int cx18_i2c_register(struct cx18 *cx, unsigned idx)
 {
 	struct v4l2_subdev *sd;
diff --git a/drivers/media/pci/cx18/cx18-i2c.h b/drivers/media/pci/cx18/cx18-i2c.h
index 1180fdc..6f2ceb5 100644
--- a/drivers/media/pci/cx18/cx18-i2c.h
+++ b/drivers/media/pci/cx18/cx18-i2c.h
@@ -21,6 +21,7 @@
  *  02111-1307  USA
  */
 
+int cx18_get_max_bus_num(void);
 int cx18_i2c_register(struct cx18 *cx, unsigned idx);
 struct v4l2_subdev *cx18_find_hw(struct cx18 *cx, u32 hw);
 
-- 
1.8.3.4 (Apple Git-47)

