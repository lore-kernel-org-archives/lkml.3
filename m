Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaLOTeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:34:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41072 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaLOTeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:34:19 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Weijie Yang <weijie.yang@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjennings@variantweb.net>,
        Dan Streetman <ddstreet@ieee.org>, Minchan Kim <minchan@kernel.org>,
        Bob Liu <bob.liu@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 77/96] mm: frontswap: invalidate expired data on a dup-store failure
Date: Mon, 15 Dec 2014 11:26:37 -0800
Message-Id: <1418671616-25482-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weijie Yang <weijie.yang@samsung.com>

commit fb993fa1a2f669215fa03a09eed7848f2663e336 upstream.

If a frontswap dup-store failed, it should invalidate the expired page
in the backend, or it could trigger some data corruption issue.
Such as:
 1. use zswap as the frontswap backend with writeback feature
 2. store a swap page(version_1) to entry A, success
 3. dup-store a newer page(version_2) to the same entry A, fail
 4. use __swap_writepage() write version_2 page to swapfile, success
 5. zswap do shrink, writeback version_1 page to swapfile
 6. version_2 page is overwrited by version_1, data corrupt.

This patch fixes this issue by invalidating expired data immediately
when meet a dup-store failure.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/frontswap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index 1b24bdc..a55036a 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -244,8 +244,10 @@ int __frontswap_store(struct page *page)
 		  the (older) page from frontswap
 		 */
 		inc_frontswap_failed_stores();
-		if (dup)
+		if (dup) {
 			__frontswap_clear(sis, offset);
+			frontswap_ops->invalidate_page(type, offset);
+		}
 	}
 	if (frontswap_writethrough_enabled)
 		/* report failure so swap also writes to swap device */
-- 
1.9.1

