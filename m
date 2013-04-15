Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3DOORk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:17:40 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:49825 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3DOORi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:17:38 -0400
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, re.emese@gmail.com,
        pageexec@freemail.hu
Subject: [PATCH] nfsd4: do not compute undefined pointer arithmetic
Date: Mon, 15 Apr 2013 16:16:23 +0200
Message-Id: <1366035383-16825-1-git-send-email-Jason@zx2c4.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

If statp is NULL, "NULL - ptr_value" will be computed, which is
undefined behavior:

    When two pointers are subtracted, both shall point to elements of
    the same array object, or one past the last element of the array
    object; the result is the difference of the subscripts of the two
    array elements. -6.5.6.9

This causes issues with the PaX size overflow gcc plugin, and may cause
problems in other compiler instrumentation and other issues down the
line.

The PaX error message is as follows:

    PAX: size overflow detected in function nfsd_cache_update fs/nfsd/nfscache.c:267 cicus.155_59 min, count: 26
    Pid: 10581, comm: nfsd Not tainted 3.8.6-grsec #4
    Call Trace:
     [<ffffffff8114fbd0>] ? report_size_overflow+0x20/0x30
     [<ffffffff81241e52>] ? nfsd_cache_update+0x232/0x270
     [<ffffffff81238062>] ? nfsd_dispatch+0x112/0x190
     [<ffffffff81616320>] ? svc_process_common+0x410/0x5c0
     [<ffffffff81617302>] ? svc_process+0x102/0x160
     [<ffffffff81237a4f>] ? nfsd+0xaf/0x120
     [<ffffffff812379a0>] ? nfsd_destroy+0x70/0x70
     [<ffffffff810ad03f>] ? kthread+0xaf/0xc0
     [<ffffffff810acf90>] ? __kthread_bind+0x30/0x30
     [<ffffffff8164c2f2>] ? ret_from_fork+0x72/0xa0
     [<ffffffff810acf90>] ? __kthread_bind+0x30/0x30

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 fs/nfsd/nfscache.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index ca05f6d..466d108 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -466,8 +466,11 @@ nfsd_cache_update(struct svc_rqst *rqstp, int cachetype, __be32 *statp)
 	if (!rp)
 		return;
 
-	len = resv->iov_len - ((char*)statp - (char*)resv->iov_base);
-	len >>= 2;
+	/* Do not calculate NULL - ptr_value, as it overflows. */
+	if (statp) {
+		len = resv->iov_len - ((char*)statp - (char*)resv->iov_base);
+		len >>= 2;
+	}
 
 	/* Don't cache excessive amounts of data and XDR failures */
 	if (!statp || len > (256 >> 2)) {
-- 
1.8.1.5

