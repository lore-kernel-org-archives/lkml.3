Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbaKLDap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:30:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaKLBcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:32:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Matt Mullins <mmullins@mmlx.us>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 246/319] mm/balloon_compaction: fix deflation when compaction is disabled
Date: Wed, 12 Nov 2014 10:16:24 +0900
Message-Id: <20141112011033.533491400@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

commit 4d88e6f7d5ffc84e6094a47925870f4a130555c2 upstream.

If CONFIG_BALLOON_COMPACTION=n balloon_page_insert() does not link pages
with balloon and doesn't set PagePrivate flag, as a result
balloon_page_dequeue() cannot get any pages because it thinks that all
of them are isolated.  Without balloon compaction nobody can isolate
ballooned pages.  It's safe to remove this check.

Fixes: d6d86c0a7f8d ("mm/balloon_compaction: redesign ballooned pages management").
Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Reported-by: Matt Mullins <mmullins@mmlx.us>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/balloon_compaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -93,11 +93,13 @@ struct page *balloon_page_dequeue(struct
 		 * to be released by the balloon driver.
 		 */
 		if (trylock_page(page)) {
+#ifdef CONFIG_BALLOON_COMPACTION
 			if (!PagePrivate(page)) {
 				/* raced with isolation */
 				unlock_page(page);
 				continue;
 			}
+#endif
 			spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 			balloon_page_delete(page);
 			spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);


