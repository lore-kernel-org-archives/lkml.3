Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab3LND1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:43 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62813 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab3LND1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:00 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 102/115] ion: free low memory from page pools first
Date: Fri, 13 Dec 2013 19:26:22 -0800
Message-Id: <1386991595-6251-10-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

When the shrinkers are called with GFP_HIGH free low memory first,
it is more important to have free than high memory.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_page_pool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 979d2e4..0ad0263 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -143,10 +143,10 @@ int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
 		struct page *page;
 
 		mutex_lock(&pool->mutex);
-		if (high && pool->high_count) {
-			page = ion_page_pool_remove(pool, true);
-		} else if (pool->low_count) {
+		if (pool->low_count) {
 			page = ion_page_pool_remove(pool, false);
+		} else if (high && pool->high_count) {
+			page = ion_page_pool_remove(pool, true);
 		} else {
 			mutex_unlock(&pool->mutex);
 			break;
-- 
1.8.3.2

