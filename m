Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaFXTjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:39:53 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:37148 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaFXTjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:39:51 -0400
From: Janne Kanniainen <janne.kanniainen@gmail.com>
To: johan@kernel.org
Cc: greg@kroah.com, bjorn@mork.no, jkosina@suse.cz, cooloney@gmail.com,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Janne Kanniainen <janne.kanniainen@gmail.com>
Subject: [PATCH 1/2] HID: leds: fix race condition in MSI GT683R driver
Date: Tue, 24 Jun 2014 22:38:37 +0300
Message-Id: <1403638718-11448-1-git-send-email-janne.kanniainen@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <20140624145003.GA6607@localhost>
References: <20140624145003.GA6607@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will fix race condition noticed by Oliver Neukum. Sysfs files are created
before mutex and work are initialized.

Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
---
 drivers/hid/hid-gt683r.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-gt683r.c b/drivers/hid/hid-gt683r.c
index 077f7a1..073bd80 100644
--- a/drivers/hid/hid-gt683r.c
+++ b/drivers/hid/hid-gt683r.c
@@ -227,6 +227,9 @@ static int gt683r_led_probe(struct hid_device *hdev,
 	if (!led)
 		return -ENOMEM;
 
+	mutex_init(&led->lock);
+	INIT_WORK(&led->work, gt683r_led_work);
+
 	led->mode = GT683R_LED_NORMAL;
 	led->hdev = hdev;
 	hid_set_drvdata(hdev, led);
@@ -271,9 +274,6 @@ static int gt683r_led_probe(struct hid_device *hdev,
 		goto fail;
 	}
 
-	mutex_init(&led->lock);
-	INIT_WORK(&led->work, gt683r_led_work);
-
 	return 0;
 
 fail:
-- 
1.9.2

