Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaGKV0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:26:01 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:46659 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbaGKVZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:25:59 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: em28xx - fix i2c_xfer to return -ENODEV when dev is removed
Date: Fri, 11 Jul 2014 15:25:55 -0600
Message-Id: <1405113955-17073-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In em28xx usb disconnect code path, some dvb fe and tuner drivers
attempt i2c transfers from their release interfaces. When device
is removed, return -ENODEV instead of attempting to transfer data
over i2c.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index b58d4eb..1048c1a 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -501,6 +501,12 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 	int addr, rc, i;
 	u8 reg;
 
+	/* prevent i2c xfer attempts after device is disconnected
+	   some fe's try to do i2c writes/reads from their release
+	   interfaces when called in disconnect path */
+	if (dev->disconnected)
+		return -ENODEV;
+
 	rc = rt_mutex_trylock(&dev->i2c_bus_lock);
 	if (rc < 0)
 		return rc;
-- 
1.7.10.4

