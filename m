Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbaBUNAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:00:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47216 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547AbaBUMv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 094/121] mm/memory-failure.c: move refcount only in !MF_COUNT_INCREASED
Date: Fri, 21 Feb 2014 12:48:38 +0000
Message-Id: <1392986945-9693-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit 8d547ff4ac5927245e0833ac18528f939da0ee0e upstream.

mce-test detected a test failure when injecting error to a thp tail
page.  This is because we take page refcount of the tail page in
madvise_hwpoison() while the fix in commit a3e0f9e47d5e
("mm/memory-failure.c: transfer page count from head page to tail page
after split thp") assumes that we always take refcount on the head page.

When a real memory error happens we take refcount on the head page where
memory_failure() is called without MF_COUNT_INCREASED set, so it seems
to me that testing memory error on thp tail page using madvise makes
little sense.

This patch cancels moving refcount in !MF_COUNT_INCREASED for valid
testing.

[akpm@linux-foundation.org: s/&&/&/]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/memory-failure.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index bfee485..a869081 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -943,8 +943,10 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 			 * to it. Similarly, page lock is shifted.
 			 */
 			if (hpage != p) {
-				put_page(hpage);
-				get_page(p);
+				if (!(flags & MF_COUNT_INCREASED)) {
+					put_page(hpage);
+					get_page(p);
+				}
 				lock_page(p);
 				unlock_page(hpage);
 				*hpagep = p;
-- 
1.9.0

