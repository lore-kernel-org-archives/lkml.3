Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbaLIP6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:58:14 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:55707 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896AbaLIP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:58:12 -0500
Message-ID: <54871C13.50309@acm.org>
Date: Tue, 09 Dec 2014 16:58:11 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] blk-mq: Avoid that __bt_get_word() wraps multiple times
References: <54871BD0.8020305@acm.org>
In-Reply-To: <54871BD0.8020305@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: <stable@vger.kernel.org> # v3.13+
---
 block/blk-mq-tag.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 728b9a4..5a3db28 100644
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
2.1.2

