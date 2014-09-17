Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbaIQVta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:49:30 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:54886 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbaIQVs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:48:28 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] eeepc-laptop: pull out SENSOR_STORE_FUNC and SENSOR_SHOW_FUNC macros
Date: Wed, 17 Sep 2014 23:47:24 +0200
Message-Id: <1410990447-3210-7-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
References: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pull out EEEPC_SENSOR_STORE_FUNC and EEEPC_SENSOR_SHOW_FUNC. These
macros define functions that call store_sys_hwmon() and show_sys_hwmon()
respectively. This helps prevent duplication later on.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index a85da4f..ba251bb 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1038,19 +1038,25 @@ static ssize_t show_sys_hwmon(int (*get)(void), char *buf)
 	return sprintf(buf, "%d\n", get());
 }
 
-#define EEEPC_CREATE_SENSOR_ATTR(_name, _mode, _get, _set)		\
+#define EEEPC_SENSOR_SHOW_FUNC(_name, _get)				\
 	static ssize_t show_##_name(struct device *dev,			\
 				    struct device_attribute *attr,	\
 				    char *buf)				\
 	{								\
 		return show_sys_hwmon(_get, buf);			\
-	}								\
+	}
+
+#define EEEPC_SENSOR_STORE_FUNC(_name, _set)				\
 	static ssize_t store_##_name(struct device *dev,		\
 				     struct device_attribute *attr,	\
 				     const char *buf, size_t count)	\
 	{								\
 		return store_sys_hwmon(_set, buf, count);		\
-	}								\
+	}
+
+#define EEEPC_CREATE_SENSOR_ATTR(_name, _mode, _get, _set)		\
+	EEEPC_SENSOR_SHOW_FUNC(_name, _get)				\
+	EEEPC_SENSOR_STORE_FUNC(_name, _set)				\
 	static DEVICE_ATTR(_name, _mode, show_##_name, store_##_name)
 
 EEEPC_CREATE_SENSOR_ATTR(fan1_input, S_IRUGO, eeepc_get_fan_rpm, NULL);
-- 
2.1.0

