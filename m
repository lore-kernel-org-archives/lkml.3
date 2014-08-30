Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaH3Qlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 12:41:36 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:57026 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaH3QlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 12:41:22 -0400
Subject: [PATCH v2 1/6] mm/balloon_compaction: ignore anonymous pages
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Date: Sat, 30 Aug 2014 20:41:09 +0400
Message-ID: <20140830164109.29066.46373.stgit@zurg>
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

Sasha Levin reported KASAN splash inside isolate_migratepages_range().
Problem is in function __is_movable_balloon_page() which tests AS_BALLOON_MAP
in page->mapping->flags. This function has no protection against anonymous
pages. As result it tried to check address space flags in inside anon-vma.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Link: http://lkml.kernel.org/p/53E6CEAA.9020105@oracle.com
Cc: stable <stable@vger.kernel.org> # v3.8
---
 include/linux/balloon_compaction.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 089743a..53d482e 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -128,7 +128,7 @@ static inline bool page_flags_cleared(struct page *page)
 static inline bool __is_movable_balloon_page(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
-	return mapping_balloon(mapping);
+	return !PageAnon(page) && mapping_balloon(mapping);
 }
 
 /*

