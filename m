Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaFXKHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:07:08 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:59156 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaFXKHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:07:04 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2 4/4] lib: list_sort.c: Limit number of unused cmp callbacks
Date: Tue, 24 Jun 2014 12:06:31 +0200
Message-Id: <1403604392-23259-5-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403604392-23259-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1403604392-23259-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper merge_and_restore_back_links() makes sure to call the
caller's cmp function during the final ->prev pointer fixup, so that
the cmp function may call cond_resched(). However, if the cmp function
does not call cond_resched() at all, this is entirely redundant. If it
does, doing at least two function calls for every two pointer
assignments is a bit excessive. This patch limits the calls to once
for every 256 iterations.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/list_sort.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index a34c78c..6b9fdaf 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -47,6 +47,7 @@ static void merge_and_restore_back_links(void *priv,
 				struct list_head *a, struct list_head *b)
 {
 	struct list_head *tail = head;
+	u8 count = 0;
 
 	while (a && b) {
 		/* if equal, take 'a' -- important for sort stability */
@@ -70,7 +71,8 @@ static void merge_and_restore_back_links(void *priv,
 		 * element comparison is needed, so the client's cmp()
 		 * routine can invoke cond_resched() periodically.
 		 */
-		(*cmp)(priv, tail->next, tail->next);
+		if (unlikely(!(++count)))
+			(*cmp)(priv, tail->next, tail->next);
 
 		tail->next->prev = tail;
 		tail = tail->next;
-- 
1.9.2

