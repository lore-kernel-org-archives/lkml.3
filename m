Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752Ab3GZVeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:34:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759950Ab3GZUsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [ 51/79] bcache: Fix a sysfs splat on shutdown
Date: Fri, 26 Jul 2013 13:47:41 -0700
Message-Id: <20130726204727.905469344@linuxfoundation.org>
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

commit c9502ea4424b31728703d113fc6b30bfead14633 upstream.

If we stopped a bcache device when we were already detaching (or
something like that), bcache_device_unlink() would try to remove a
symlink from sysfs that was already gone because the bcache dev kobject
had already been removed from sysfs.

So keep track of whether we've removed stuff from sysfs.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/bcache.h |    1 +
 drivers/md/bcache/super.c  |   11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -437,6 +437,7 @@ struct bcache_device {
 
 	/* If nonzero, we're detaching/unregistering from cache set */
 	atomic_t		detaching;
+	int			flush_done;
 
 	atomic_long_t		sectors_dirty;
 	unsigned long		sectors_dirty_gc;
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -704,7 +704,8 @@ static void bcache_device_detach(struct
 		atomic_set(&d->detaching, 0);
 	}
 
-	bcache_device_unlink(d);
+	if (!d->flush_done)
+		bcache_device_unlink(d);
 
 	d->c->devices[d->id] = NULL;
 	closure_put(&d->c->caching);
@@ -1016,6 +1017,14 @@ static void cached_dev_flush(struct clos
 	struct cached_dev *dc = container_of(cl, struct cached_dev, disk.cl);
 	struct bcache_device *d = &dc->disk;
 
+	mutex_lock(&bch_register_lock);
+	d->flush_done = 1;
+
+	if (d->c)
+		bcache_device_unlink(d);
+
+	mutex_unlock(&bch_register_lock);
+
 	bch_cache_accounting_destroy(&dc->accounting);
 	kobject_del(&d->kobj);
 


