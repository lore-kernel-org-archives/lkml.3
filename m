Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3LMTXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:23:21 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:37295 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3LMTXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:23:01 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 4/4] w1: call put_device if device_register fails
Date: Fri, 13 Dec 2013 20:22:37 +0100
Message-Id: <1386962557-8899-5-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386962557-8899-1-git-send-email-levex@linux.com>
References: <1386962557-8899-1-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, memsetting and kfreeing the device is bad behaviour.
The device will have a reference count of 1 and hence can cause trouble
because it has kfree'd. Proper way to handle a failed device_register
is to call put_device right after it fails.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/w1/w1_int.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 5a98649..0b9b59e 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -90,9 +90,8 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
 	err = device_register(&dev->dev);
 	if (err) {
 		printk(KERN_ERR "Failed to register master device. err=%d\n", err);
-		memset(dev, 0, sizeof(struct w1_master));
-		kfree(dev);
-		dev = NULL;
+		put_device(&dev->dev);
+		return NULL;
 	}
 
 	return dev;
-- 
1.8.3.1

