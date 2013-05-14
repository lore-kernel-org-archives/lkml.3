Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab3ENBTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:19:09 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:39103 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab3ENBTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:05 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <koverstreet@google.com>,
        Josh Boyer <jwboyer@redhat.com>, Zach Brown <zab@redhat.com>
Subject: [PATCH 01/21] aio: fix kioctx not being freed after cancellation at exit time
Date: Mon, 13 May 2013 18:18:38 -0700
Message-Id: <1368494338-7069-2-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin LaHaise <bcrl@kvack.org>

The recent changes overhauling fs/aio.c introduced a bug that results in the
kioctx not being freed when outstanding kiocbs are cancelled at exit_aio()
time.  Specifically, a kiocb that is cancelled has its completion events
discarded by batch_complete_aio(), which then fails to wake up the process
stuck in free_ioctx().  Fix this by modifying the wait_event() condition
in free_ioctx() appropriately.

This patch was tested with the cancel operation in the thread based code
posted yesterday.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Zach Brown <zab@redhat.com>
---
 fs/aio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index c5b1a8c..fe794af 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -307,7 +307,9 @@ static void free_ioctx(struct kioctx *ctx)
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_active) > 0) {
-		wait_event(ctx->wait, head != ctx->tail);
+		wait_event(ctx->wait,
+			   (head != ctx->tail) ||
+			   (atomic_read(&ctx->reqs_active) <= 0);
 
 		avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
 
-- 
1.8.2.1

