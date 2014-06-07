Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaFGBXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:23:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35937 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Naoya Horiguchi" <n-horiguchi@ah.jp.nec.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.357877816@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 86/92] mm/memory-failure.c: fix memory leak by race
 between poison and unpoison
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit 3e030ecc0fc7de10fd0da10c1c19939872a31717 upstream.

When a memory error happens on an in-use page or (free and in-use)
hugepage, the victim page is isolated with its refcount set to one.

When you try to unpoison it later, unpoison_memory() calls put_page()
for it twice in order to bring the page back to free page pool (buddy or
free hugepage list).  However, if another memory error occurs on the
page which we are unpoisoning, memory_failure() returns without
releasing the refcount which was incremented in the same call at first,
which results in memory leak and unconsistent num_poisoned_pages
statistics.  This patch fixes it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: s/num_poisoned_pages/bad_mce_pages/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/memory-failure.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1094,6 +1094,8 @@ int __memory_failure(unsigned long pfn,
 	 */
 	if (!PageHWPoison(p)) {
 		printk(KERN_ERR "MCE %#lx: just unpoisoned\n", pfn);
+		atomic_long_sub(nr_pages, &mce_bad_pages);
+		put_page(hpage);
 		res = 0;
 		goto out;
 	}

