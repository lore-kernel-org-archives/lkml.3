Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab3ETCah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 22:30:37 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:51498 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3ETCag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 22:30:36 -0400
Message-ID: <51998AAF.6060709@huawei.com>
Date: Mon, 20 May 2013 10:30:07 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <jlee@suse.com>, <matthew.garrett@nebula.com>
CC: <platform-driver-x86@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 1/3] x86: msi-laptop: fix memleak
References: <1368889004-5520-2-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1368889004-5520-2-git-send-email-libo.chen@huawei.com>
X-Forwarded-Message-Id: <1368889004-5520-2-git-send-email-libo.chen@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1. fix two visible mistakes:
    * when load_scm_model_init faild, we should call platform_device_del(msipf_device)
    * msipf_attribute_group should be remove in err case

2. change some tags, give them real meaning.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/platform/x86/msi-laptop.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)
 mode change 100644 => 100755 drivers/platform/x86/msi-laptop.c

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
old mode 100644
new mode 100755
index 6b22938..62f8030
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -1098,29 +1098,29 @@ static int __init msi_init(void)

 	ret = platform_device_add(msipf_device);
 	if (ret)
-		goto fail_platform_device1;
+		goto fail_device_add;

 	if (quirks->load_scm_model && (load_scm_model_init(msipf_device) < 0)) {
 		ret = -EINVAL;
-		goto fail_platform_device1;
+		goto fail_scm_model_init;
 	}

 	ret = sysfs_create_group(&msipf_device->dev.kobj,
 				 &msipf_attribute_group);
 	if (ret)
-		goto fail_platform_device2;
+		goto fail_create_group;

 	if (!quirks->old_ec_model) {
 		if (threeg_exists)
 			ret = device_create_file(&msipf_device->dev,
 						&dev_attr_threeg);
 		if (ret)
-			goto fail_platform_device2;
+			goto fail_create_attr;
 	} else {
 		ret = sysfs_create_group(&msipf_device->dev.kobj,
 					 &msipf_old_attribute_group);
 		if (ret)
-			goto fail_platform_device2;
+			goto fail_create_attr;

 		/* Disable automatic brightness control by default because
 		 * this module was probably loaded to do brightness control in
@@ -1134,26 +1134,22 @@ static int __init msi_init(void)

 	return 0;

-fail_platform_device2:
-
+fail_create_attr:
+	sysfs_remove_group(&msipf_device->dev.kobj, &msipf_attribute_group);
+fail_create_group:
 	if (quirks->load_scm_model) {
 		i8042_remove_filter(msi_laptop_i8042_filter);
 		cancel_delayed_work_sync(&msi_rfkill_dwork);
 		cancel_work_sync(&msi_rfkill_work);
 		rfkill_cleanup();
 	}
+fail_scm_model_init:
 	platform_device_del(msipf_device);
-
-fail_platform_device1:
-
+fail_device_add:
 	platform_device_put(msipf_device);
-
 fail_platform_driver:
-
 	platform_driver_unregister(&msipf_driver);
-
 fail_backlight:
-
 	backlight_device_unregister(msibl_device);

 	return ret;
-- 
1.8.1.2






