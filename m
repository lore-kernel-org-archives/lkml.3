Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbbALSHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:07:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57834 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbbALSG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
        Robert Elliott <elliott@hp.com>, Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 102/216] blk-mq: Avoid that __bt_get_word() wraps multiple times
Date: Mon, 12 Jan 2015 18:03:39 +0000
Message-Id: <1421085933-32536-103-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 9e98e9d7cf6e9d2ec1cce45e8d5ccaf3f9b386f3 upstream.

If __bt_get_word() is called with last_tag != 0, if the first
find_next_zero_bit() fails, if after wrap-around the
test_and_set_bit() call fails and find_next_zero_bit() succeeds,
if the next test_and_set_bit() call fails and subsequently
find_next_zero_bit() does not find a zero bit, then another
wrap-around will occur. Avoid this by introducing an additional
local variable.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robert Elliott <elliott@hp.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/blk-mq-tag.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 74a4168ea34e..a1bc33974fc4 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -137,6 +137,7 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 static int __bt_get_word(struct blk_align_bitmap *bm, unsigned int last_tag)
 {
 	int tag, org_last_tag, end;
+	bool wrap = last_tag != 0;
 
 	org_last_tag = last_tag;
 	end = bm->depth;
@@ -148,8 +149,9 @@ restart:
 			 * We started with an offset, start from 0 to
 			 * exhaust the map.
 			 */
-			if (org_last_tag && last_tag) {
-				end = last_tag;
+			if (wrap) {
+				wrap = false;
+				end = org_last_tag;
 				last_tag = 0;
 				goto restart;
 			}
-- 
2.1.4

