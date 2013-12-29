Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3L2VzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:55:14 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:31758 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010Ab3L2Vv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:51:57 -0500
X-IronPort-AV: E=Sophos;i="4.95,570,1384297200"; 
   d="scan'208";a="50832532"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jiri Kosina <jkosina@suse.cz>
Cc: kernel-janitors@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/25] HID: sony: fix error return code
Date: Sun, 29 Dec 2013 23:47:27 +0100
Message-Id: <1388357260-4843-13-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Currently the return variable ret is always 0.  Set it to other values in
error cases, as used in the direct return.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/hid/hid-sony.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index b60bc38..f57ab5e 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -585,6 +585,7 @@ static int sony_leds_init(struct hid_device *hdev)
 		led = kzalloc(sizeof(struct led_classdev) + name_sz, GFP_KERNEL);
 		if (!led) {
 			hid_err(hdev, "Couldn't allocate memory for LED %d\n", n);
+			ret = -ENOMEM;
 			goto error_leds;
 		}
 
@@ -596,7 +597,8 @@ static int sony_leds_init(struct hid_device *hdev)
 		led->brightness_get = sony_led_get_brightness;
 		led->brightness_set = sony_led_set_brightness;
 
-		if (led_classdev_register(&hdev->dev, led)) {
+		ret = led_classdev_register(&hdev->dev, led);
+		if (ret) {
 			hid_err(hdev, "Failed to register LED %d\n", n);
 			kfree(led);
 			goto error_leds;

