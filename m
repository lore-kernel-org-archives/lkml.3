Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaK1JTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:19:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53104 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaK1JTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:19:32 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-33-54783e1c3250
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC v8 04/14] v4l2-async: change custom.match callback argument
 type
Date: Fri, 28 Nov 2014 10:17:56 +0100
Message-id: <1417166286-27685-5-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t9jQV0Zu4oQgw8TTCw2zljPanF050Qm
	i/cb5zFZLPm5i8mi9+pzRouzTW/YLTonLmG3uLxrDpvF1jfrGC16Nmxltbh76iibxe5dT1kt
	Dr9pZ7U4s38lmwOfx5TfG1k9ds66y+7x4WOcx+yOmaweh78uZPHYM/8Hq0ffllWMHitWf2f3
	+LxJLoAzissmJTUnsyy1SN8ugStj5a497AVfJCq23ittYHwg0sXIySEhYCKxdO0hdghbTOLC
	vfVsXYxcHEIC0xklPr6fxArhtDNJLL0+hQWkik3AUOLni9dMXYwcHCIC0RKXjtWD1DAL3GGS
	+HjtIRtIjbBAmMSObxBTWQRUJY7/uMUEYvMKeEjMnfGTHaRXQkBBYs4kG5Awp4CnxNzPa1lA
	wkJAJYtepUxg5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzh4n0nvYFzVYHGIUYCD
	UYmH9+e/8hAh1sSy4srcQ4wSHMxKIrynvgKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8964mRsi
	JJCeWJKanZpakFoEk2Xi4JRqYBRU+a01NTnstqX2H8XUcP2EI40uYbfn8Rw6cphhw9TaF47T
	BOOy9BX2Va5JZb2R0R7cuPZ4nCAPu9qKJ6KPM2ec0D/a9FXK9dvZ70+AIe2+UfChrLK8n+6h
	GdzrOadJ7Eq5yNRsO7tdrUaX1+Emv3U57/EdjGwlp2ZsqWGVvGtYfmzVeYNsJZbijERDLeai
	4kQAzLpjDFoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful to have an access to the async sub-device
being matched, not only to the related struct device.
Change match callback argument from struct device
to struct v4l2_subdev. It will allow e.g. for matching
a sub-device by its "name" property.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-async.c |   16 ++++++++--------
 include/media/v4l2-async.h           |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 85a6a34..8140992 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -22,10 +22,10 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 
-static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
+static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
 #if IS_ENABLED(CONFIG_I2C)
-	struct i2c_client *client = i2c_verify_client(dev);
+	struct i2c_client *client = i2c_verify_client(sd->dev);
 	return client &&
 		asd->match.i2c.adapter_id == client->adapter->nr &&
 		asd->match.i2c.address == client->addr;
@@ -34,14 +34,14 @@ static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
 #endif
 }
 
-static bool match_devname(struct device *dev, struct v4l2_async_subdev *asd)
+static bool match_devname(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	return !strcmp(asd->match.device_name.name, dev_name(dev));
+	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
 }
 
-static bool match_of(struct device *dev, struct v4l2_async_subdev *asd)
+static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	return dev->of_node == asd->match.of.node;
+	return sd->dev->of_node == asd->match.of.node;
 }
 
 static LIST_HEAD(subdev_list);
@@ -52,7 +52,7 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 						    struct v4l2_subdev *sd)
 {
 	struct v4l2_async_subdev *asd;
-	bool (*match)(struct device *, struct v4l2_async_subdev *);
+	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
 
 	list_for_each_entry(asd, &notifier->waiting, list) {
 		/* bus_type has been verified valid before */
@@ -79,7 +79,7 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 		}
 
 		/* match cannot be NULL here */
-		if (match(sd->dev, asd))
+		if (match(sd, asd))
 			return asd;
 	}
 
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 7683569..1c0b586 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -51,7 +51,7 @@ struct v4l2_async_subdev {
 			unsigned short address;
 		} i2c;
 		struct {
-			bool (*match)(struct device *,
+			bool (*match)(struct v4l2_subdev *,
 				      struct v4l2_async_subdev *);
 			void *priv;
 		} custom;
-- 
1.7.9.5

