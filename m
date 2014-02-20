Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaBUA4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:56:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbaBTXvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3.10 38/66] mei: clear write cb from waiting list on reset
Date: Thu, 20 Feb 2014 15:51:37 -0800
Message-Id: <20140220234910.587052544@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 30c54df7cb9b15b222529a028390b9c9582dd65e upstream.

Clear write callbacks sitting in write_waiting list on reset.
Otherwise these callbacks are left dangling and cause memory leak.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/client.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -829,8 +829,16 @@ void mei_cl_all_read_wakeup(struct mei_d
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


