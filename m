Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbbAGDFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:05:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832AbbAGBvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:51:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.18 30/84] dm thin: fix a race in thin_dtr
Date: Tue,  6 Jan 2015 17:49:33 -0800
Message-Id: <20150107014030.017800392@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 17181fb7a0c3a279196c0eeb2caba65a1519614b upstream.

As long as struct thin_c is in the list, anyone can grab a reference of
it.  Consequently, we must wait for the reference count to drop to zero
*after* we remove the structure from the list, not before.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3266,14 +3266,14 @@ static void thin_dtr(struct dm_target *t
 	struct thin_c *tc = ti->private;
 	unsigned long flags;
 
-	thin_put(tc);
-	wait_for_completion(&tc->can_destroy);
-
 	spin_lock_irqsave(&tc->pool->lock, flags);
 	list_del_rcu(&tc->list);
 	spin_unlock_irqrestore(&tc->pool->lock, flags);
 	synchronize_rcu();
 
+	thin_put(tc);
+	wait_for_completion(&tc->can_destroy);
+
 	mutex_lock(&dm_thin_pool_table.mutex);
 
 	__pool_dec(tc->pool);


