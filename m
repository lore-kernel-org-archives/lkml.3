Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab3FEFnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 01:43:37 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38987 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3FEFnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 01:43:31 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 2/3] firmware loader: simplify holding module for request_firmware
Date: Wed,  5 Jun 2013 13:42:48 +0800
Message-Id: <1370410969-15328-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370410969-15328-1-git-send-email-ming.lei@canonical.com>
References: <1370410969-15328-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module reference doesn't cover direct loading path, so this patch
simply holds the module in the whole life time of request_firmware()
to fix the problem.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 34d47e3..c743409 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -523,8 +523,6 @@ static void fw_dev_release(struct device *dev)
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 
 	kfree(fw_priv);
-
-	module_put(THIS_MODULE);
 }
 
 static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
@@ -852,9 +850,6 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 
 	dev_set_uevent_suppress(f_dev, true);
 
-	/* Need to pin this module until class device is destroyed */
-	__module_get(THIS_MODULE);
-
 	retval = device_add(f_dev);
 	if (retval) {
 		dev_err(f_dev, "%s: device_register failed\n", __func__);
@@ -1127,7 +1122,13 @@ int
 request_firmware(const struct firmware **firmware_p, const char *name,
                  struct device *device)
 {
-	return _request_firmware(firmware_p, name, device, true, false);
+	int ret;
+
+	/* Need to pin this module until return */
+	__module_get(THIS_MODULE);
+	ret = _request_firmware(firmware_p, name, device, true, false);
+	module_put(THIS_MODULE);
+	return ret;
 }
 EXPORT_SYMBOL(request_firmware);
 
-- 
1.7.9.5

