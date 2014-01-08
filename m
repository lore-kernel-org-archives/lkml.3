Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaAHB5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:57:30 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:61304 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaAHB5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:57:24 -0500
MIME-Version: 1.0
Date: Tue, 7 Jan 2014 17:57:23 -0800
Message-ID: <CAFR8uecjVRQg5S9RKKjZQ+t+7jFVed_T1BhhdXJFO60EK=9XGw@mail.gmail.com>
Subject: [block:for-3.14/core]: bio_endio: Warn and free bio if bi_end_io is
 not set.
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,
In bio_endio if bio doesn't have bi_end_io (should be an error case),
we set bio to NULL and continue silently without freeing the bio. It
would be good to have a WARN and free the bio to avoid memory leak.

If you agree, here is the patch.

---------
bio_endio: Warn and free bio if bi_end_io is not set

Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
--------
 fs/bio.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 75c49a3..581806d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1768,8 +1768,15 @@ void bio_endio(struct bio *bio, int error)
             bio_put(bio);
             bio = parent;
         } else {
-            if (bio->bi_end_io)
+            if (likely(bio->bi_end_io)) {
                 bio->bi_end_io(bio, error);
+            } else {
+                char dev_name[BDEVNAME_SIZE];
+                WARN(1, "bio_endio: bio for device %s without endio\n",
+                        bio->bi_bdev ? bdevname(bio->bi_bdev,
dev_name) : "(unknown)");
+                bio_put(bio);
+            }
+
             bio = NULL;
         }
     }

---------------
