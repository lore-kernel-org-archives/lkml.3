Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab3KLAo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:44:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35185 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3KLAoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:44:20 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-8e-528179e3e9b4
Date: Tue, 12 Nov 2013 09:44:36 +0900
From: Kyungmin Park <kmpark@infradead.org>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org, kay@vrfy.org
Subject: [PATCH] video: backlight: Remove backlight sysfs uevent
Message-id: <20131112004436.GA30125@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jQd3HlY1BBtPuy1lcXniJ1eLWqufs
	Fif6PrBaXN41h81i966nrA6sHnvm/2D16NuyitHj8yY5j4/rPQNYorhsUlJzMstSi/TtErgy
	Xj9pYivYwF8xZcJm5gbG9zxdjJwcEgImEp9PvmeEsMUkLtxbzwZiCwlMZ5R48lIRwv7CKHH4
	siCE7Stx4/kOdhCbRUBV4tfRA6wgNpuAlsSVD3vA4iICHhLTnx1lArGZBbwlDk+ZBVYjLOAg
	8bH3AtguXgFNiRM7/rNC2IISPybfY4Go15JYv/M4VK+0xKO/M8BmigqoSEw5uY1tAiP/LCQt
	s5C0zELSsoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcKg+k9rBuLLB4hCjAAejEg/v
	Dq7GICHWxLLiytxDjBIczEoivOa5QCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNL
	UrNTUwtSi2CyTBycUg2Mlb9XXw2c7LA7xkFzr1r6pQJ/MecdH/bVGbv0HXJsv/dRadetN0FT
	e0oO3pF4YTP1mEK/QkGn6rnnHGt2uO9f4O939//9728ZLu0+ed+B/RzbFX0z0aqLMk2VIpFf
	Ju27bCXe8MLCurzopvBKPte/VqrWC2/cVEvuY94oNqvM6f2eIw8e3OxWU2Ipzkg01GIuKk4E
	AJo21OZRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

The most mobile phones have Ambient Light Sensors and it changes brightness according lux.
It means it changes backlight brightness frequently by just writing sysfs node, so it generates uevent.
 
Usually there's no user to use this backlight changes. But it forks udev worker threads and it takes about 5ms. The main problem is that it hurts other process activities. so remove it.

Kay said 
"Uevents are for the major, low-frequent, global device state-changes,
 not for carrying-out any sort of measurement data. Subsystems which
 need that should use other facilities like poll()-able sysfs file or
 any other subscription-based, client-tracking interface which does not
 cause overhead if it isn't used. Uevents are not the right thing to
 use here, and upstream udev should not paper-over broken kernel
 subsystems."

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 94a403a..441272d 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -88,9 +88,6 @@ static void backlight_generate_event(struct backlight_device *bd,
 	char *envp[2];
 
 	switch (reason) {
-	case BACKLIGHT_UPDATE_SYSFS:
-		envp[0] = "SOURCE=sysfs";
-		break;
 	case BACKLIGHT_UPDATE_HOTKEY:
 		envp[0] = "SOURCE=hotkey";
 		break;
@@ -172,8 +169,6 @@ static ssize_t brightness_store(struct device *dev,
 	}
 	mutex_unlock(&bd->ops_lock);
 
-	backlight_generate_event(bd, BACKLIGHT_UPDATE_SYSFS);
-
 	return rc;
 }
 static DEVICE_ATTR_RW(brightness);
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 53b7794..d2a27dd 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -29,7 +29,6 @@
 
 enum backlight_update_reason {
 	BACKLIGHT_UPDATE_HOTKEY,
-	BACKLIGHT_UPDATE_SYSFS,
 };
 
 enum backlight_type {
