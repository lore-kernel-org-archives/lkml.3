Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbaAFXGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:06:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158AbaAFWlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josh Durgin <josh.durgin@inktank.com>, Alex Elder <elder@linaro.org>
Subject: [PATCH 3.10 114/129] rbd: complete notifies before cleaning up osd_client and rbd_dev
Date: Mon,  6 Jan 2014 14:39:03 -0800
Message-Id: <20140106223902.854306282@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit 9abc59908e0c5f983aaa91150da32d5b62cf60b7 upstream.

To ensure rbd_dev is not used after it's released, flush all pending
notify callbacks before calling rbd_dev_image_release(). No new
notifies can be added to the queue at this point because the watch has
already be unregistered with the osd_client.

Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5150,6 +5150,13 @@ static ssize_t rbd_remove(struct bus_typ
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
 	ret = count;


