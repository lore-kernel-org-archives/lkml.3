Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbbA0Mqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:46:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34946 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758359AbbA0MRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 030/126] HID: roccat: potential out of bounds in pyra_sysfs_write_settings()
Date: Tue, 27 Jan 2015 12:15:35 +0000
Message-Id: <1422361031-19364-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 606185b20caf4c57d7e41e5a5ea4aff460aef2ab upstream.

This is a static checker fix.  We write some binary settings to the
sysfs file.  One of the settings is the "->startup_profile".  There
isn't any checking to make sure it fits into the
pyra->profile_settings[] array in the profile_activated() function.

I added a check to pyra_sysfs_write_settings() in both places because
I wasn't positive that the other callers were correct.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-roccat-pyra.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index 1a07e07d99a0..47d7e74231e5 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -35,6 +35,8 @@ static struct class *pyra_class;
 static void profile_activated(struct pyra_device *pyra,
 		unsigned int new_profile)
 {
+	if (new_profile >= ARRAY_SIZE(pyra->profile_settings))
+		return;
 	pyra->actual_profile = new_profile;
 	pyra->actual_cpi = pyra->profile_settings[pyra->actual_profile].y_cpi;
 }
@@ -257,9 +259,11 @@ static ssize_t pyra_sysfs_write_settings(struct file *fp,
 	if (off != 0 || count != PYRA_SIZE_SETTINGS)
 		return -EINVAL;
 
-	mutex_lock(&pyra->pyra_lock);
-
 	settings = (struct pyra_settings const *)buf;
+	if (settings->startup_profile >= ARRAY_SIZE(pyra->profile_settings))
+		return -EINVAL;
+
+	mutex_lock(&pyra->pyra_lock);
 
 	retval = pyra_set_settings(usb_dev, settings);
 	if (retval) {
-- 
2.1.4

