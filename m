Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaJPNLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:11:55 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39785 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaJPNLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:11:53 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-3a-543fc417d3b0
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH] extcon: Implement OF-based extcon lookup properly
Date: Thu, 16 Oct 2014 15:11:44 +0200
Message-id: <1413465104-26201-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t/xK7riR+xDDNY/k7G4/uU5q8XlXXPY
	LNYeuctucbtxBZvFql1/GB1YPXbOusvu0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBk9uy+w
	FbzkrdjasIO5gfE6dxcjJ4eEgInE1/1djBC2mMSFe+vZuhi5OIQEljJKLFqxihXC6WOS+P//
	GBtIFZuAoUTX2y4wW0RAQWJz7zOwImaB5YwSX9bfABslLOAk8WplA5jNIqAqMefAUxYQm1fA
	Q2LR7tvMEOvkJP6/XME0gZF7ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQAPiyg3Hx
	MatDjAIcjEo8vBrB9iFCrIllxZW5hxglOJiVRHhnHwQK8aYkVlalFuXHF5XmpBYfYmTi4JRq
	YIxX88osjvpnaDFPe2+GUNiVwmUzFlZyLzm3+dwl5utTpprO/sKbxb5Ys+1Mb0l5jkjkeU6u
	HPY7L7atm7v49anFG/m+pJzbFLQ2Mt3iMluXef7dp7+bddUEJwrNuOqUUvNI99yLJbUqV54f
	6/6hJ1TMVsHsx5sQ+/+936mXVsatvTGmehbvDJRYijMSDbWYi4oTATrt4D7eAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <tomasz.figa@gmail.com>

Platform bus is not the only way to have extcon devices, so current
implementation of of_extcon_get_extcon_dev() is broken. Also using
parent device node only to get device name is quite ugly.

This patch reimplements of_extcon_get_extcon_dev() to do exactly the
same as extcon_get_extcon_dev() but instead of comparing names, compare
node pointers.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
[mszyprow: simplified the code]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/extcon/extcon-class.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 4c2f2c543bb7..043dcd9946c9 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -29,6 +29,7 @@
 #include <linux/fs.h>
 #include <linux/err.h>
 #include <linux/extcon.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/of.h>
@@ -997,13 +998,16 @@ struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev, int index)
 		return ERR_PTR(-ENODEV);
 	}
 
-	edev = extcon_get_extcon_dev(node->name);
-	if (!edev) {
-		dev_err(dev, "unable to get extcon device : %s\n", node->name);
-		return ERR_PTR(-ENODEV);
+	mutex_lock(&extcon_dev_list_lock);
+	list_for_each_entry(edev, &extcon_dev_list, entry) {
+		if (edev->dev.parent && edev->dev.parent->of_node == node) {
+			mutex_unlock(&extcon_dev_list_lock);
+			return edev;
+		}
 	}
+	mutex_unlock(&extcon_dev_list_lock);
 
-	return edev;
+	return ERR_PTR(-EPROBE_DEFER);
 }
 #else
 struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev, int index)
-- 
1.9.2

