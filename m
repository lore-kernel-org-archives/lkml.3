Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3J3K7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:59:10 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:43468 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab3J3K7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:59:08 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/sysfs: Do not drop device reference twice
Date: Wed, 30 Oct 2013 11:59:05 +0100
Message-Id: <1383130745-32165-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_unregister() already drops its reference to the struct device, so
explicitly calling put_device() before device_unregister() can cause the
device to have been freed before it can be unregistered.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/drm_sysfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index dae42c7..db1c8f9 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -439,7 +439,6 @@ err_out_files:
 		device_remove_file(connector->kdev, &connector_attrs_opt1[i]);
 	for (i = 0; i < attr_cnt; i++)
 		device_remove_file(connector->kdev, &connector_attrs[i]);
-	put_device(connector->kdev);
 	device_unregister(connector->kdev);
 
 out:
@@ -472,7 +471,6 @@ void drm_sysfs_connector_remove(struct drm_connector *connector)
 	for (i = 0; i < ARRAY_SIZE(connector_attrs); i++)
 		device_remove_file(connector->kdev, &connector_attrs[i]);
 	sysfs_remove_bin_file(&connector->kdev->kobj, &edid_attr);
-	put_device(connector->kdev);
 	device_unregister(connector->kdev);
 	connector->kdev = NULL;
 }
-- 
1.8.4

