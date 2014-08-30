Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaH3Qlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 12:41:40 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:40970 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaH3Ql3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 12:41:29 -0400
Subject: [PATCH v2 3/6] mm/balloon_compaction: isolate balloon pages without
 lru_lock
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Date: Sat, 30 Aug 2014 20:41:17 +0400
Message-ID: <20140830164117.29066.18189.stgit@zurg>
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

LRU-lock isn't required for balloon page isolation. This check makes migration
of some ballooned pages mostly impossible because isolate_migratepages_range()
drops LRU lock periodically.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: stable <stable@vger.kernel.org> # v3.8
---
 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 73466e1..ad58f73 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -643,7 +643,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		 */
 		if (!PageLRU(page)) {
 			if (unlikely(balloon_page_movable(page))) {
-				if (locked && balloon_page_isolate(page)) {
+				if (balloon_page_isolate(page)) {
 					/* Successfully isolated */
 					goto isolate_success;
 				}

