Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3LRVQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:16:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3LRVO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.12 086/118] dm space map: disallow decrementing a reference count below zero
Date: Wed, 18 Dec 2013 13:12:03 -0800
Message-Id: <20131218211221.893894083@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 5b564d80f8bc21094c0cd2b19b679d983aabcc29 upstream.

The old behaviour, returning -EINVAL if a ref_count of 0 would be
decremented, was removed in commit f722063 ("dm space map: optimise
sm_ll_dec and sm_ll_inc").  To fix this regression we return an error
code from the mutator function pointer passed to sm_ll_mutate() and have
dec_ref_count() return -EINVAL if the old ref_count is 0.

Add a DMERR to reflect the potential seriousness of this error.

Also, add missing dm_tm_unlock() to sm_ll_mutate()'s error path.

With this fix the following dmts regression test now passes:
 dmtest run --suite cache -n /metadata_use_kernel/

The next patch fixes the higher-level dm-array code that exposed this
regression.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-space-map-common.c |   32 ++++++++++++++++-------
 1 file changed, 23 insertions(+), 9 deletions(-)

--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -381,7 +381,7 @@ int sm_ll_find_free_block(struct ll_disk
 }
 
 static int sm_ll_mutate(struct ll_disk *ll, dm_block_t b,
-			uint32_t (*mutator)(void *context, uint32_t old),
+			int (*mutator)(void *context, uint32_t old, uint32_t *new),
 			void *context, enum allocation_event *ev)
 {
 	int r;
@@ -410,11 +410,17 @@ static int sm_ll_mutate(struct ll_disk *
 
 	if (old > 2) {
 		r = sm_ll_lookup_big_ref_count(ll, b, &old);
-		if (r < 0)
+		if (r < 0) {
+			dm_tm_unlock(ll->tm, nb);
 			return r;
+		}
 	}
 
-	ref_count = mutator(context, old);
+	r = mutator(context, old, &ref_count);
+	if (r) {
+		dm_tm_unlock(ll->tm, nb);
+		return r;
+	}
 
 	if (ref_count <= 2) {
 		sm_set_bitmap(bm_le, bit, ref_count);
@@ -465,9 +471,10 @@ static int sm_ll_mutate(struct ll_disk *
 	return ll->save_ie(ll, index, &ie_disk);
 }
 
-static uint32_t set_ref_count(void *context, uint32_t old)
+static int set_ref_count(void *context, uint32_t old, uint32_t *new)
 {
-	return *((uint32_t *) context);
+	*new = *((uint32_t *) context);
+	return 0;
 }
 
 int sm_ll_insert(struct ll_disk *ll, dm_block_t b,
@@ -476,9 +483,10 @@ int sm_ll_insert(struct ll_disk *ll, dm_
 	return sm_ll_mutate(ll, b, set_ref_count, &ref_count, ev);
 }
 
-static uint32_t inc_ref_count(void *context, uint32_t old)
+static int inc_ref_count(void *context, uint32_t old, uint32_t *new)
 {
-	return old + 1;
+	*new = old + 1;
+	return 0;
 }
 
 int sm_ll_inc(struct ll_disk *ll, dm_block_t b, enum allocation_event *ev)
@@ -486,9 +494,15 @@ int sm_ll_inc(struct ll_disk *ll, dm_blo
 	return sm_ll_mutate(ll, b, inc_ref_count, NULL, ev);
 }
 
-static uint32_t dec_ref_count(void *context, uint32_t old)
+static int dec_ref_count(void *context, uint32_t old, uint32_t *new)
 {
-	return old - 1;
+	if (!old) {
+		DMERR_LIMIT("unable to decrement a reference count below 0");
+		return -EINVAL;
+	}
+
+	*new = old - 1;
+	return 0;
 }
 
 int sm_ll_dec(struct ll_disk *ll, dm_block_t b, enum allocation_event *ev)


