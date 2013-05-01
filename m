Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075Ab3EAN4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 09:56:18 -0400
Received: from mail-ye0-f201.google.com ([209.85.213.201]:36813 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3EAN4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 09:56:15 -0400
From: Robert Love <rlove@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shankar Brahadeeswaran <shankoo77@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        devel <devel@driverdev.osuosl.org>, Hugh Dickins <hughd@google.com>,
        Anjana V Kumar <anjanavk12@gmail.com>, Dad <akpm@linux-foundation.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: [PATCH -next] ashmem: Fix ashmem_shrink deadlock.
Date: Wed,  1 May 2013 09:56:13 -0400
Message-Id: <1367416573-5430-1-git-send-email-rlove@google.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't acquire ashmem_mutex in ashmem_shrink if we've somehow recursed into the
shrinker code from within ashmem. Just bail out, avoiding a deadlock. This is
fine, as ashmem cache pruning is advisory anyhow.

Signed-off-by: Robert Love <rlove@google.com>
---
 drivers/staging/android/ashmem.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index e681bdd..82c6768 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -363,7 +363,11 @@ static int ashmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	if (!sc->nr_to_scan)
 		return lru_count;
 
-	mutex_lock(&ashmem_mutex);
+	/* avoid recursing into this code from within ashmem itself */
+	if (!mutex_trylock(&ashmem_mutex)) {
+		return -1;
+	}
+
 	list_for_each_entry_safe(range, next, &ashmem_lru_list, lru) {
 		loff_t start = range->pgstart * PAGE_SIZE;
 		loff_t end = (range->pgend + 1) * PAGE_SIZE;
-- 
1.8.2.1

