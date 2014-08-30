Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaH3Qli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 12:41:38 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:56164 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaH3QlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 12:41:25 -0400
Subject: [PATCH v2 2/6] mm/balloon_compaction: keep ballooned pages away
 from normal migration path
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Date: Sat, 30 Aug 2014 20:41:13 +0400
Message-ID: <20140830164113.29066.25879.stgit@zurg>
In-Reply-To: <20140830163834.29066.98205.stgit@zurg>
References: <20140830163834.29066.98205.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

Proper testing shows yet another problem in balloon migration: it works only
once for each page. balloon_page_movable() check page flags and page_count.
In __unmap_and_move page is locked, reference counter is elevated, so
balloon_page_movable() _always_ fails here. As result in __unmap_and_move()
migration goes to the normal migration path.

Balloon ->migratepage() is so special, it returns MIGRATEPAGE_BALLOON_SUCCESS
instead of MIGRATEPAGE_SUCCESS. After that in move_to_new_page() successfully
migrated page got NULL into its mapping pointer and loses connectivity with
balloon and ability for further migration.

It's safe to use __is_movable_balloon_page here: page is isolated and pinned.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: stable <stable@vger.kernel.org> # v3.8
---
 include/linux/balloon_compaction.h |    5 +++++
 mm/migrate.c                       |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 53d482e..284fc1d 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -258,6 +258,11 @@ static inline void balloon_page_delete(struct page *page)
 	list_del(&page->lru);
 }
 
+static inline bool __is_movable_balloon_page(struct page *page)
+{
+	return false;
+}
+
 static inline bool balloon_page_movable(struct page *page)
 {
 	return false;
diff --git a/mm/migrate.c b/mm/migrate.c
index 905b1aa..57c94f9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -873,7 +873,7 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 		}
 	}
 
-	if (unlikely(balloon_page_movable(page))) {
+	if (unlikely(__is_movable_balloon_page(page))) {
 		/*
 		 * A ballooned page does not need any special attention from
 		 * physical to virtual reverse mapping procedures.

