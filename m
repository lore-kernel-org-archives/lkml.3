Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbaF1SZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:25:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbaF1RvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        David Fries <david@fries.net>, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 3.15 007/139] w1: do not unlock unheld list_mutex in __w1_remove_master_device()
Date: Sat, 28 Jun 2014 10:46:08 -0700
Message-Id: <20140628174605.699151559@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit a0f104644ec27ce5bbb36e950eb426dba9a3ad44 upstream.

w1_process_callbacks() expects to be called with dev->list_mutex held,
but it is the fact only in w1_process(). __w1_remove_master_device()
calls w1_process_callbacks() after it releases list_mutex.

The patch fixes __w1_remove_master_device() to acquire list_mutex
for w1_process_callbacks().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: David Fries <david@fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/w1/w1.c     |    2 ++
 drivers/w1/w1_int.c |    4 ++++
 2 files changed, 6 insertions(+)

--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1078,6 +1078,8 @@ static void w1_search_process(struct w1_
  * w1_process_callbacks() - execute each dev->async_list callback entry
  * @dev: w1_master device
  *
+ * The w1 master list_mutex must be held.
+ *
  * Return: 1 if there were commands to executed 0 otherwise
  */
 int w1_process_callbacks(struct w1_master *dev)
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -219,9 +219,13 @@ void __w1_remove_master_device(struct w1
 
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


