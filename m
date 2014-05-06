Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaEFV0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:26:23 -0400
Received: from mail.ispras.ru ([83.149.199.45]:46785 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbaEFV0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:26:22 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: David Fries <David@Fries.net>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH v2] w1: do not unlock unheld list_mutex in __w1_remove_master_device()
Date: Wed,  7 May 2014 01:26:04 +0400
Message-Id: <1399411564-16172-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140501034759.GG5096@spacedout.fries.net>
References: <20140501034759.GG5096@spacedout.fries.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

w1_process_callbacks() expects to be called with dev->list_mutex held,
but it is the fact only in w1_process(). __w1_remove_master_device()
calls w1_process_callbacks() after it releases list_mutex.

The patch fixes __w1_remove_master_device() to acquire list_mutex
for w1_process_callbacks().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/w1/w1.c     | 2 ++
 drivers/w1/w1_int.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index ff52618cafbe..5d7341520544 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1078,6 +1078,8 @@ static void w1_search_process(struct w1_master *dev, u8 search_type)
  * w1_process_callbacks() - execute each dev->async_list callback entry
  * @dev: w1_master device
  *
+ * The w1 master list_mutex must be held.
+ *
  * Return: 1 if there were commands to executed 0 otherwise
  */
 int w1_process_callbacks(struct w1_master *dev)
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 9b084db739c7..728039d2efe1 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -219,9 +219,13 @@ void __w1_remove_master_device(struct w1_master *dev)
 
 		if (msleep_interruptible(1000))
 			flush_signals(current);
+		mutex_lock(&dev->list_mutex);
 		w1_process_callbacks(dev);
+		mutex_unlock(&dev->list_mutex);
 	}
+	mutex_lock(&dev->list_mutex);
 	w1_process_callbacks(dev);
+	mutex_unlock(&dev->list_mutex);
 
 	memset(&msg, 0, sizeof(msg));
 	msg.id.mst.id = dev->id;
-- 
1.8.3.2

