Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaAVC2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 21:28:13 -0500
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60525 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaAVC2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 21:28:09 -0500
From: Jamie Liu <jamieliu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@fusionio.com>,
        Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan@kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jamie Liu <jamieliu@google.com>
Subject: [PATCH] swap: do not skip lowest_bit in scan_swap_map() scan loop
Date: Tue, 21 Jan 2014 18:21:16 -0800
Message-Id: <1390357276-16521-1-git-send-email-jamieliu@google.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the second half of scan_swap_map()'s scan loop, offset is set to
si->lowest_bit and then incremented before entering the loop for the
first time, causing si->swap_map[si->lowest_bit] to be skipped.

Signed-off-by: Jamie Liu <jamieliu@google.com>
---
 mm/swapfile.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 612a7c9..6635081 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -616,7 +616,7 @@ scan:
 		}
 	}
 	offset = si->lowest_bit;
-	while (++offset < scan_base) {
+	while (offset < scan_base) {
 		if (!si->swap_map[offset]) {
 			spin_lock(&si->lock);
 			goto checks;
@@ -629,6 +629,7 @@ scan:
 			cond_resched();
 			latency_ration = LATENCY_LIMIT;
 		}
+		offset++;
 	}
 	spin_lock(&si->lock);
 
-- 
1.8.5.3

