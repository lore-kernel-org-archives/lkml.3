Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3KKX4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:56:50 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:32327 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3KKX4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:56:45 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-be-52816ebbc64a
Date: Tue, 12 Nov 2013 08:57:00 +0900
From: Kyungmin Park <kmpark@infradead.org>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org, kay@vrfy.org
Subject: [PATCH] video: backlight: Remove backlight sysfs uevent
Message-id: <20131111235700.GA29987@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQd3deY1BBvNvCltcXniJ1eLWqufs
	Fif6PrBaXN41h81i966nrA6sHnvm/2D16NuyitHj8yY5j4/rPQNYorhsUlJzMstSi/TtErgy
	Xj9pYivYwF8xZcJm5gbG9zxdjJwcEgImEvv2fWSHsMUkLtxbz9bFyMUhJDCdUWJ7YxsjhPOF
	UWLF7x1sIFVCAr4SZ6ZtAOtgEVCVWH/xGlicTUBL4sqHPWBxEQEPienPjjKB2MwC3hKHp8xi
	BbGFBRwkPvZeYASxeQU0Jd7s3soMYQtK/Jh8jwWiXkti/c7jUL3SEo/+zgCbKSqgIjHl5Da2
	CYz8s5C0zELSMgtJywJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYweH6THoH46oGi0OM
	AhyMSjy8O7gag4RYE8uKK3MPMUpwMCuJ8JrnAoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1
	DhQSSE8sSc1OTS1ILYLJMnFwSjUwtmWyugipyH+WPff57Jwnl+Ltlu/1TSjIqHr5fr3xuU07
	f3sZSFfP8m3XtrE32dG4rWW7UfsHz1r/yW92bL7Za2lhsSzlDZvM4XDHS6dWRfyQO/zv1K2s
	lzck35hN7ttwVuH1nr/vVT/H/7RYWPLu37+tmeesY0vMkyX+v1Be/nij8Ny7ERe1/JRYijMS
	DbWYi4oTAag9n5NTAgAA
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
