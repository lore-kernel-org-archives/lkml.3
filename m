Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354AbbAGCoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:44:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965AbbAGCHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 17/52] dm cache: dirty flag was mistakenly being cleared when promoting via overwrite
Date: Tue,  6 Jan 2015 18:06:45 -0800
Message-Id: <20150107020557.946310606@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 1e32134a5a404e80bfb47fad8a94e9bbfcbdacc5 upstream.

If the incoming bio is a WRITE and completely covers a block then we
don't bother to do any copying for a promotion operation.  Once this is
done the cache block and origin block will be different, so we need to
set it to 'dirty'.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -946,10 +946,14 @@ static void migration_success_post_commi
 		}
 
 	} else {
-		clear_dirty(cache, mg->new_oblock, mg->cblock);
-		if (mg->requeue_holder)
+		if (mg->requeue_holder) {
+			clear_dirty(cache, mg->new_oblock, mg->cblock);
 			cell_defer(cache, mg->new_ocell, true);
-		else {
+		} else {
+			/*
+			 * The block was promoted via an overwrite, so it's dirty.
+			 */
+			set_dirty(cache, mg->new_oblock, mg->cblock);
 			bio_endio(mg->new_ocell->holder, 0);
 			cell_defer(cache, mg->new_ocell, false);
 		}


