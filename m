Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab3LWQYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:24:08 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39229 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab3LWQYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:04 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [RFC 02/18] power/reset: vexpress: Use sched_clock as the time source
Date: Mon, 23 Dec 2013 16:23:34 +0000
Message-Id: <1387815830-8794-3-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:00.0837 (UTC) FILETIME=[634FC750:01CEFFFB]
X-MC-Unique: 113122316240202701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGSVMo026662

At this stage of system shutdown procedure the jiffies may
not be updated anymore, so have to base on raw sched_clock
values.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/reset/vexpress-poweroff.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/power/reset/vexpress-poweroff.c b/drivers/power/reset/vexpress-poweroff.c
index 476aa49..d752233 100644
--- a/drivers/power/reset/vexpress-poweroff.c
+++ b/drivers/power/reset/vexpress-poweroff.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/vexpress.h>
 
@@ -27,12 +28,12 @@ static void vexpress_reset_do(struct device *dev, const char *what)
 			vexpress_config_func_get_by_dev(dev);
 
 	if (func) {
-		unsigned long timeout;
+		unsigned long long timeout_ns;
 
 		err = vexpress_config_write(func, 0, 0);
 
-		timeout = jiffies + HZ;
-		while (time_before(jiffies, timeout))
+		timeout_ns = sched_clock() + 50000000;
+		while (!err && time_before64(sched_clock(), timeout_ns))
 			cpu_relax();
 	}
 
-- 
1.8.3.2


