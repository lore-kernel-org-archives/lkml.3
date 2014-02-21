Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbaBUMvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:51:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47107 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaBUMvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 078/121] mei: clear write cb from waiting list on reset
Date: Fri, 21 Feb 2014 12:48:22 +0000
Message-Id: <1392986945-9693-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 30c54df7cb9b15b222529a028390b9c9582dd65e upstream.

Clear write callbacks sitting in write_waiting list on reset.
Otherwise these callbacks are left dangling and cause memory leak.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/misc/mei/client.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 21d3f5a..e019165 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -915,8 +915,16 @@ void mei_cl_all_read_wakeup(struct mei_device *dev)
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
1.9.0

