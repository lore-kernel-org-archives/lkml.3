Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935045AbaDJDWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:22:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934654AbaDJDVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Jiri Kosina <jkosina@suse.cz>, Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 022/134] HID: hidraw: improve error handling in hidraw_init()
Date: Wed,  9 Apr 2014 20:22:18 -0700
Message-Id: <20140410032302.762006795@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit bcb4a75bde3821cecb17a71d287abfd6ef9bd68d upstream.

Several improvements in error handling:
- do not report success if alloc_chrdev_region() failed
- check for error code of cdev_add()
- use unregister_chrdev_region() instead of unregister_chrdev()
  if class_create() failed

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hidraw.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -559,21 +559,28 @@ int __init hidraw_init(void)
 
 	if (result < 0) {
 		pr_warn("can't get major number\n");
-		result = 0;
 		goto out;
 	}
 
 	hidraw_class = class_create(THIS_MODULE, "hidraw");
 	if (IS_ERR(hidraw_class)) {
 		result = PTR_ERR(hidraw_class);
-		unregister_chrdev(hidraw_major, "hidraw");
-		goto out;
+		goto error_cdev;
 	}
 
         cdev_init(&hidraw_cdev, &hidraw_ops);
-        cdev_add(&hidraw_cdev, dev_id, HIDRAW_MAX_DEVICES);
+	result = cdev_add(&hidraw_cdev, dev_id, HIDRAW_MAX_DEVICES);
+	if (result < 0)
+		goto error_class;
+
 out:
 	return result;
+
+error_class:
+	class_destroy(hidraw_class);
+error_cdev:
+	unregister_chrdev_region(dev_id, HIDRAW_MAX_DEVICES);
+	goto out;
 }
 
 void hidraw_exit(void)


