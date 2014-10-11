Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaJKIeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 04:34:09 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:63043 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaJKIeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 04:34:07 -0400
From: hansechang@gmail.com
To: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Cc: Ian.Campbell@eu.citrix.com, dgdegra@tycho.nsa.gov,
        jinsong.liu@alibaba-inc.com,
        Chang Huaixin <huaixin.chx@alibaba-inc.com>
Subject: [PATCH] Input: xen-kbdfront - free grant table entry in xenkbd_disconnect_backend
Date: Sat, 11 Oct 2014 16:33:32 +0800
Message-Id: <1413016412-17890-1-git-send-email-hansechang@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chang Huaixin <huaixin.chx@alibaba-inc.com>

xenkbd_disconnect_backend doesn't free grant table entry.
This bug affects live migration.

xenkbd_disconnect_backend uses gnttab_end_foreign_access_ref
to handle grant table entry which doesn't really free an entry.

Thus every time we do xenkbd_resume, grant table entry increses
by one. As an grant table entry occupies 8 bytes, an grant table
page has at most 512 entries. Every 512 times we do xenkdb_resume,
grant table pages increses by one.

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

