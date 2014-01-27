Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaA0U20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:28:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:51743 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbaA0U2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:28:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,731,1384329600"; 
   d="scan'208";a="471628380"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 1/2] mei: clear write cb from waiting list on reset
Date: Mon, 27 Jan 2014 22:27:23 +0200
Message-Id: <1390854444-30650-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390854444-30650-1-git-send-email-tomas.winkler@intel.com>
References: <1390854444-30650-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Clear write callbacks sitting in write_waiting list on reset.
Otherwise these callbacks are left dangling and cause memory leak.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index ae07c38..8bf2034 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -960,8 +960,16 @@ void mei_cl_all_wakeup(struct mei_device *dev)
 void mei_cl_all_write_clear(struct mei_device *dev)
 {
 	struct mei_cl_cb *cb, *next;
+	struct list_head *list;
 
-	list_for_each_entry_safe(cb, next, &dev->write_list.list, list) {
+	list = &dev->write_list.list;
+	list_for_each_entry_safe(cb, next, list, list) {
+		list_del(&cb->list);
+		mei_io_cb_free(cb);
+	}
+
+	list = &dev->write_waiting_list.list;
+	list_for_each_entry_safe(cb, next, list, list) {
 		list_del(&cb->list);
 		mei_io_cb_free(cb);
 	}
-- 
1.8.5.3

