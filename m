Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3KZSbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:31:19 -0500
Received: from mail-ie0-f201.google.com ([209.85.223.201]:53560 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab3KZSbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:31:07 -0500
From: Doug Anderson <dianders@chromium.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Doug Anderson <dianders@chromium.org>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] watchdog: core: Make dt "timeout-sec" property work on drivers w/out min/max
Date: Tue, 26 Nov 2013 10:22:52 -0800
Message-Id: <1385490173-7511-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is valid for a watchdog driver to have 0 for a "min" and "max"
timeout if the driver doesn't need the core to enforce the concepts of
min and max.  The s3c2410_wdt driver is one such driver.  Specifically
it can be hard for that driver to come up with a static "max" on all
platforms without a lot more information since the input clock on
S3C2410 and S3C2440 can change with DVFS.

As written, watchdog_init_timeout() will not ever read "timeout-sec"
on these drivers since watchdog_timeout_invalid() will _never_ return
true.  Change to not consider a timeout_parm of 0 as valid even if
min/max aren't specified by the driver.  Also handle the case when
there is no min/max and no "timeout-sec" property.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/watchdog/watchdog_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index 461336c..cec9b55 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -78,7 +78,7 @@ int watchdog_init_timeout(struct watchdog_device *wdd,
 	watchdog_check_min_max_timeout(wdd);
 
 	/* try to get the timeout module parameter first */
-	if (!watchdog_timeout_invalid(wdd, timeout_parm)) {
+	if (!watchdog_timeout_invalid(wdd, timeout_parm) && timeout_parm) {
 		wdd->timeout = timeout_parm;
 		return ret;
 	}
@@ -89,7 +89,7 @@ int watchdog_init_timeout(struct watchdog_device *wdd,
 	if (dev == NULL || dev->of_node == NULL)
 		return ret;
 	of_property_read_u32(dev->of_node, "timeout-sec", &t);
-	if (!watchdog_timeout_invalid(wdd, t))
+	if (!watchdog_timeout_invalid(wdd, t) && t)
 		wdd->timeout = t;
 	else
 		ret = -EINVAL;
-- 
1.8.4.1

