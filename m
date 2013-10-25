Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab3JYHZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 03:25:59 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45921 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3JYHZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 03:25:58 -0400
From: Cong Ding <dinggnu@gmail.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] uio: fix memory leak
Date: Fri, 25 Oct 2013 00:25:53 -0700
Message-Id: <1382685953-19413-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we have to call kobject_put() to clean up the kobject after function
kobject_init(), kobject_add(), or kobject_uevent() is called.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/uio/uio.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 11d4e0a..539d148 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -288,13 +288,13 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		}
 		map = kzalloc(sizeof(*map), GFP_KERNEL);
 		if (!map)
-			goto err_map;
+			goto err_map_kobj;
 		kobject_init(&map->kobj, &map_attr_type);
 		map->mem = mem;
 		mem->map = map;
 		ret = kobject_add(&map->kobj, idev->map_dir, "map%d", mi);
 		if (ret)
-			goto err_map;
+			goto err_map_kobj;
 		ret = kobject_uevent(&map->kobj, KOBJ_ADD);
 		if (ret)
 			goto err_map;
@@ -313,14 +313,14 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		}
 		portio = kzalloc(sizeof(*portio), GFP_KERNEL);
 		if (!portio)
-			goto err_portio;
+			goto err_portio_kobj;
 		kobject_init(&portio->kobj, &portio_attr_type);
 		portio->port = port;
 		port->portio = portio;
 		ret = kobject_add(&portio->kobj, idev->portio_dir,
 							"port%d", pi);
 		if (ret)
-			goto err_portio;
+			goto err_portio_kobj;
 		ret = kobject_uevent(&portio->kobj, KOBJ_ADD);
 		if (ret)
 			goto err_portio;
@@ -329,14 +329,18 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 	return 0;
 
 err_portio:
-	for (pi--; pi >= 0; pi--) {
+	pi--;
+err_portio_kobj:
+	for (; pi >= 0; pi--) {
 		port = &idev->info->port[pi];
 		portio = port->portio;
 		kobject_put(&portio->kobj);
 	}
 	kobject_put(idev->portio_dir);
 err_map:
-	for (mi--; mi>=0; mi--) {
+	mi--;
+err_map_kobj:
+	for (; mi >= 0; mi--) {
 		mem = &idev->info->mem[mi];
 		map = mem->map;
 		kobject_put(&map->kobj);
-- 
1.7.9.5

