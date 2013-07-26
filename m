Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477Ab3GZVao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:30:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759988Ab3GZUsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [ 50/79] bcache: Shutdown fix
Date: Fri, 26 Jul 2013 13:47:40 -0700
Message-Id: <20130726204727.788803229@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit 5caa52afc5abd1396e4af720469abb5843a71eb8 upstream.

Stopping a cache set is supposed to make it stop attached backing
devices, but somewhere along the way that code got lost. Fixing this
mainly has the effect of fixing our reboot notifier.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/super.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1305,18 +1305,22 @@ static void cache_set_flush(struct closu
 static void __cache_set_unregister(struct closure *cl)
 {
 	struct cache_set *c = container_of(cl, struct cache_set, caching);
-	struct cached_dev *dc, *t;
+	struct cached_dev *dc;
 	size_t i;
 
 	mutex_lock(&bch_register_lock);
 
-	if (test_bit(CACHE_SET_UNREGISTERING, &c->flags))
-		list_for_each_entry_safe(dc, t, &c->cached_devs, list)
-			bch_cached_dev_detach(dc);
-
 	for (i = 0; i < c->nr_uuids; i++)
-		if (c->devices[i] && UUID_FLASH_ONLY(&c->uuids[i]))
-			bcache_device_stop(c->devices[i]);
+		if (c->devices[i]) {
+			if (!UUID_FLASH_ONLY(&c->uuids[i]) &&
+			    test_bit(CACHE_SET_UNREGISTERING, &c->flags)) {
+				dc = container_of(c->devices[i],
+						  struct cached_dev, disk);
+				bch_cached_dev_detach(dc);
+			} else {
+				bcache_device_stop(c->devices[i]);
+			}
+		}
 
 	mutex_unlock(&bch_register_lock);
 


