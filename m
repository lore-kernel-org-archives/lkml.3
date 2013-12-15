Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3LOCBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:01:10 -0500
Received: from dmz-mailsec-scanner-2.mit.edu ([18.9.25.13]:63280 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab3LOCBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:01:06 -0500
X-AuditID: 1209190d-b7ef66d000000c40-69-52ad0d6100b7
Date: Sat, 14 Dec 2013 21:01:03 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] random: reserve for /dev/random only once /dev/urandom
 seeded
Message-ID: <20131215020103.GC27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsUixCmqrJvIuzbIoOumqsXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mron/CUtWAPf8WJ97cZGxhv83QxcnJICJhI3Hh1lhnCFpO4cG89
	WxcjF4eQwGwmicMPZrFCOBsZJZ6v38sKUiUk8ItRYvGJOBCbRUBVYsHC52BxNgEFiR/z14FN
	EhFQllg1cxMTiM0MFP91bxNYjbBAmETzyVksIDavgJXEq0frmSFmGki0z2xggogLSpyc+YQF
	oldL4sa/l0BxDiBbWmL5Pw6QMKeAocS7hVcZQWxRARWJKSe3sU1gFJyFpHsWku5ZCN0LGJlX
	Mcqm5Fbp5iZm5hSnJusWJyfm5aUW6Rrp5WaW6KWmlG5iBIepJO8OxncHlQ4xCnAwKvHwSrCt
	DRJiTSwrrsw9xCjJwaQkyivFCRTiS8pPqcxILM6ILyrNSS0+xCjBwawkwrvj/JogId6UxMqq
	1KJ8mJQ0B4uSOO9NDvsgIYH0xJLU7NTUgtQimKwMB4eSBK82D9BQwaLU9NSKtMycEoQ0Ewcn
	yHAeoOFiIDW8xQWJucWZ6RD5U4yKUuK8/iAJAZBERmkeXC8sjbxiFAd6RZhXAqSKB5iC4Lpf
	AQ1mAhrsvWcVyOCSRISUVAPjdI4Vqiw/rgt3pJ7n7rG+nBQ1T1vrvqzGnBlLokwm55u5m28/
	Wrt2sn7zFo/2Q/9Xa29t4LiV7nI87I1D3ePFW9ZWLdudpdB1yGetn9aPL9KZpzR65pc8mJ/U
	+zwmp6Os6MBv9QnmVyxCes9Irptt8979t/azX8mip5We+u82zMxue/u5ZWmxEktxRqKhFnNR
	cSIAPXlFA/4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early in boot, we really want to make sure the nonblocking pool (for
/dev/urandom and the kernel's own use) gets an adequate amount of
entropy ASAP.  Anyone reading /dev/random is prepared to wait
potentially a long time anyway, so delaying them a little bit more at
boot until /dev/urandom is seeded is no big deal.  This logic still
ensures that /dev/random readers won't starve indefinitely.

At present most input goes directly to the nonblocking pool early on
anyway, but this helps put us in a position to change that.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 92d9f6862..bf7fedadd 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -923,19 +923,21 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
 	__u32 tmp[OUTPUT_POOL_WORDS];
-	int bytes, min_bytes;
-
-	/* For /dev/random's pool, always leave two wakeups' worth */
-	int rsvd_bytes = r->limit ? 0 : random_read_wakeup_bits / 4;
+	int bytes, min_bytes, reserved_bytes;
 
 	/* pull at least as much as a wakeup */
 	min_bytes = random_read_wakeup_bits / 8;
 	/* but never more than the buffer size */
 	bytes = min(sizeof(tmp), max_t(size_t, min_bytes, nbytes));
 
+	/* reserve some for /dev/random's pool, unless we really need it */
+	reserved_bytes = 0;
+	if (!r->limit && r->initialized)
+		reserved_bytes = 2 * (random_read_wakeup_bits / 8);
+
 	trace_xfer_secondary_pool(r->name, bytes * 8, nbytes * 8,
 				  ENTROPY_BITS(r), ENTROPY_BITS(r->pull));
-	bytes = extract_entropy(r->pull, tmp, bytes, min_bytes, rsvd_bytes);
+	bytes = extract_entropy(r->pull, tmp, bytes, min_bytes, reserved_bytes);
 	mix_pool_bytes(r, tmp, bytes, NULL);
 	credit_entropy_bits(r, bytes*8);
 }
-- 
1.8.3.2

