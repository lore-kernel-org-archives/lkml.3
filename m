Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373AbbAIKyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:54:55 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44509 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757389AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Weijie Yang <weijie.yang@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjennings@variantweb.net>,
        Dan Streetman <ddstreet@ieee.org>, Minchan Kim <minchan@kernel.org>,
        Bob Liu <bob.liu@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 16/78] mm: frontswap: invalidate expired data on a dup-store failure
Date: Fri,  9 Jan 2015 11:31:25 +0100
Message-Id: <94724f27bf02e417629d93101a3fbb0dcfe86c28.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weijie Yang <weijie.yang@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/frontswap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index c30eec536f03..f2a3571c6e22 100644
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
2.2.1

