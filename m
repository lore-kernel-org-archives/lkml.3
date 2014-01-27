Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaA0URJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:17:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaA0UQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:16:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.13 10/10] md/raid5: close recently introduced race in stripe_head management.
Date: Mon, 27 Jan 2014 12:17:13 -0800
Message-Id: <20140127201536.069050252@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <20140127201535.350372282@linuxfoundation.org>
References: <20140127201535.350372282@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 7da9d450ab2843bf1db378c156acc6304dbc1c2b upstream.

As release_stripe and __release_stripe decrement ->count and then
manipulate ->lru both under ->device_lock, it is important that
get_active_stripe() increments ->count and clears ->lru also under
->device_lock.

However we currently list_del_init ->lru under the lock, but increment
the ->count outside the lock.  This can lead to races and list
corruption.

So move the atomic_inc(&sh->count) up inside the ->device_lock
protected region.

Note that we still increment ->count without device lock in the case
where get_free_stripe() was called, and in fact don't take
->device_lock at all in that path.
This is safe because if the stripe_head can be found by
get_free_stripe, then the hash lock assures us the no-one else could
possibly be calling release_stripe() at the same time.

Fixes: 566c09c53455d7c4f1130928ef8071da1a24ea65
Reported-and-tested-by: Ian Kumlien <ian.kumlien@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -675,8 +675,10 @@ get_active_stripe(struct r5conf *conf, s
 					 || !conf->inactive_blocked),
 					*(conf->hash_locks + hash));
 				conf->inactive_blocked = 0;
-			} else
+			} else {
 				init_stripe(sh, sector, previous);
+				atomic_inc(&sh->count);
+			}
 		} else {
 			spin_lock(&conf->device_lock);
 			if (atomic_read(&sh->count)) {
@@ -695,13 +697,11 @@ get_active_stripe(struct r5conf *conf, s
 					sh->group = NULL;
 				}
 			}
+			atomic_inc(&sh->count);
 			spin_unlock(&conf->device_lock);
 		}
 	} while (sh == NULL);
 
-	if (sh)
-		atomic_inc(&sh->count);
-
 	spin_unlock_irq(conf->hash_locks + hash);
 	return sh;
 }


