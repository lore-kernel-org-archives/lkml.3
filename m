Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaAMQcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:32:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53413 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbaAMQDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Durgin <josh.durgin@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 126/208] rbd: complete notifies before cleaning up osd_client and rbd_dev
Date: Mon, 13 Jan 2014 15:59:27 +0000
Message-Id: <1389628849-1614-127-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit 9abc59908e0c5f983aaa91150da32d5b62cf60b7 upstream.

To ensure rbd_dev is not used after it's released, flush all pending
notify callbacks before calling rbd_dev_image_release(). No new
notifies can be added to the queue at this point because the watch has
already be unregistered with the osd_client.

Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/rbd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 853e622..16f6966 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5163,6 +5163,13 @@ static ssize_t rbd_remove(struct bus_type *bus,
 	ret = rbd_dev_header_watch_sync(rbd_dev, false);
 	if (ret)
 		rbd_warn(rbd_dev, "failed to cancel watch event (%d)\n", ret);
+
+	/*
+	 * flush remaining watch callbacks - these must be complete
+	 * before the osd_client is shutdown
+	 */
+	dout("%s: flushing notifies", __func__);
+	ceph_osdc_flush_notifies(&rbd_dev->rbd_client->client->osdc);
 	rbd_dev_image_release(rbd_dev);
 	module_put(THIS_MODULE);
 
-- 
1.8.3.2

