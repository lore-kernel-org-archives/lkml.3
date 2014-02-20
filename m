Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbaBUAd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:33:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbaBTXwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3.12 47/82] mei: clear write cb from waiting list on reset
Date: Thu, 20 Feb 2014 15:52:30 -0800
Message-Id: <20140220235020.892584649@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -916,8 +916,16 @@ void mei_cl_all_wakeup(struct mei_device
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


