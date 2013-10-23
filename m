Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3JWJKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:10:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48161 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab3JWJJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:09:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 4/5] drbd: fix decoding of bitmap vli rle for device sizes > 64 TB
Date: Wed, 23 Oct 2013 10:59:18 +0200
Message-Id: <1382518759-5467-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382518759-5467-1-git-send-email-philipp.reisner@linbit.com>
References: <1382518759-5467-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Symptoms: disconnect after bitmap exchange due to
bitmap overflow (e:49731075554) while decoding bm RLE packet

In the decoding step of the variable length integer run length encoding
there was potentially an uncatched bitshift by wordsize (variable >> 64).

The result of which is "undefined" :(
(only "sometimes" the result is the desired 0)

Fix: don't do any bit shift magic for shift == 64, just assign.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 12c59eb..6fa6673 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4125,7 +4125,11 @@ recv_bm_rle_bits(struct drbd_conf *mdev,
 				(unsigned int)bs.buf_len);
 			return -EIO;
 		}
-		look_ahead >>= bits;
+		/* if we consumed all 64 bits, assign 0; >> 64 is "undefined"; */
+		if (likely(bits < 64))
+			look_ahead >>= bits;
+		else
+			look_ahead = 0;
 		have -= bits;
 
 		bits = bitstream_get_bits(&bs, &tmp, 64 - have);
-- 
1.7.9.5

