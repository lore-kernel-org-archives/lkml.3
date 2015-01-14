Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbbANIhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:37:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbbANH0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:26:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
        Robert Elliott <elliott@hp.com>, Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.18 048/150] blk-mq: Avoid that __bt_get_word() wraps multiple times
Date: Tue, 13 Jan 2015 23:21:59 -0800
Message-Id: <20150114072058.052335987@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq-tag.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -137,6 +137,7 @@ static inline bool hctx_may_queue(struct
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


