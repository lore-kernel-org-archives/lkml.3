Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbaJIGTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:19:04 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:53754 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaJIGS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:18:59 -0400
From: hansechang@gmail.com
To: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Cc: Chang Huaixin <huaixin.chx@alibaba-inc.com>
Subject: [PATCH] bugfix: free grant table entry in xenkbd_disconnect_backend
Date: Thu,  9 Oct 2014 14:18:40 +0800
Message-Id: <1412835520-22981-1-git-send-email-hansechang@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chang Huaixin <huaixin.chx@alibaba-inc.com>

This bug affects live migration.

xenkdb_disconnect_backend uses gnttab_end_foreign_access_ref
to handle grant table entry which doesn't really free an entry.

Thus every time we do xenkbd_resume, grant table entry increses
by one. Every 512 times we do xenkdb_resume, grant table pages
increses by one.

After around 3500 times of live migration, grant table pages
will increase by 7, causing too many pages to populate and hitting
max_pages limit when assigning pages.Thus assign_pages will fail,
so will live migration.

Signed-off-by: Chang Huaixin <huaixin.chx@alibaba-inc.com>
---
 drivers/input/misc/xen-kbdfront.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index fbfdc10..e2ecfc6 100644
--- a/drivers/input/misc/xen-kbdfront.c
+++ b/drivers/input/misc/xen-kbdfront.c
@@ -285,7 +285,7 @@ static int xenkbd_connect_backend(struct xenbus_device *dev,
  error_evtchan:
 	xenbus_free_evtchn(dev, evtchn);
  error_grant:
-	gnttab_end_foreign_access_ref(info->gref, 0);
+	gnttab_end_foreign_access(info->gref, 0, 0UL);
 	info->gref = -1;
 	return ret;
 }
@@ -296,7 +296,7 @@ static void xenkbd_disconnect_backend(struct xenkbd_info *info)
 		unbind_from_irqhandler(info->irq, info);
 	info->irq = -1;
 	if (info->gref >= 0)
-		gnttab_end_foreign_access_ref(info->gref, 0);
+		gnttab_end_foreign_access(info->gref, 0, 0UL);
 	info->gref = -1;
 }
 
-- 
1.9.1

