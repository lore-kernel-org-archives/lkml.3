Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaAFW6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:58:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152AbaAFWmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Elder <elder@inktank.com>, Josh Durgin <josh.durgin@inktank.com>
Subject: [PATCH 3.10 096/129] rbd: protect against concurrent unmaps
Date: Mon,  6 Jan 2014 14:38:45 -0800
Message-Id: <20140106223902.349996992@linuxfoundation.org>
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

From: Alex Elder <elder@inktank.com>

commit 82a442d239695a242c4d584464c9606322cd02aa upstream.

Make sure two concurrent unmap operations on the same rbd device
won't collide, by only proceeding with the removal and cleanup of a
device if is not already underway.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Josh Durgin <josh.durgin@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5108,6 +5108,7 @@ static ssize_t rbd_remove(struct bus_typ
 	struct list_head *tmp;
 	int dev_id;
 	unsigned long ul;
+	bool already = false;
 	int ret;
 
 	ret = strict_strtoul(buf, 10, &ul);
@@ -5135,11 +5136,12 @@ static ssize_t rbd_remove(struct bus_typ
 		if (rbd_dev->open_count)
 			ret = -EBUSY;
 		else
-			set_bit(RBD_DEV_FLAG_REMOVING, &rbd_dev->flags);
+			already = test_and_set_bit(RBD_DEV_FLAG_REMOVING,
+							&rbd_dev->flags);
 		spin_unlock_irq(&rbd_dev->lock);
 	}
 	spin_unlock(&rbd_dev_list_lock);
-	if (ret < 0)
+	if (ret < 0 || already)
 		goto done;
 
 	rbd_bus_del_dev(rbd_dev);


