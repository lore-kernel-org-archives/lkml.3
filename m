Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab3IIRfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:35:39 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51723 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3IIRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:35:38 -0400
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Olof Johansson <olof@lixom.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Russell King <linux@arm.linux.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: [PATCH] direct-io: Use return from cmpxchg to decide of assignment happened
Date: Mon,  9 Sep 2013 10:34:23 -0700
Message-Id: <1378748063-23589-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not using the return value can in the generic case be racy, so it's
in general good practice to check the return value instead.

This also resolved the warning caused on ARM and other architectures:

fs/direct-io.c: In function 'sb_init_dio_done_wq':
fs/direct-io.c:557:2: warning: value computed is not used [-Wunused-value]

Signed-off-by: Olof Johansson <olof@lixom.net>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: H Peter Anvin <hpa@zytor.com>

---
 fs/direct-io.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 1782023..0e04142 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -544,6 +544,7 @@ static inline int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
  */
 static int sb_init_dio_done_wq(struct super_block *sb)
 {
+	struct workqueue_struct *old;
 	struct workqueue_struct *wq = alloc_workqueue("dio/%s",
 						      WQ_MEM_RECLAIM, 0,
 						      sb->s_id);
@@ -552,9 +553,9 @@ static int sb_init_dio_done_wq(struct super_block *sb)
 	/*
 	 * This has to be atomic as more DIOs can race to create the workqueue
 	 */
-	cmpxchg(&sb->s_dio_done_wq, NULL, wq);
+	old = cmpxchg(&sb->s_dio_done_wq, NULL, wq);
 	/* Someone created workqueue before us? Free ours... */
-	if (wq != sb->s_dio_done_wq)
+	if (old)
 		destroy_workqueue(wq);
 	return 0;
 }
-- 
1.7.10.4

