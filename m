Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbaIRSNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:13:09 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:23989 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbaIRSNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:13:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvcNAH4gG1RbsHJU/2dsb2JhbABggw2BKrURAQEEBQFxmwqBCxcBeYQxLyOBGjeIQgGyB5BEhgmJbh2ENQWRJotmlUiDYDsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, reiserfs-devel@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/reiserfs/journal.c: fix sparse context imbalance warning
Date: Thu, 18 Sep 2014 20:12:38 +0200
Message-Id: <1411063958-11570-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge conditional unlock/lock in the same condition to avoid sparse warning:
fs/reiserfs/journal.c:703:36: warning: context imbalance in 'add_to_chunk' - unexpected unlock

Cc: reiserfs-devel@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/reiserfs/journal.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index a88b1b3..d571e17 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -699,11 +699,13 @@ static int add_to_chunk(struct buffer_chunk *chunk, struct buffer_head *bh,
 	chunk->bh[chunk->nr++] = bh;
 	if (chunk->nr >= CHUNK_SIZE) {
 		ret = 1;
-		if (lock)
+		if (lock) {
 			spin_unlock(lock);
-		fn(chunk);
-		if (lock)
+			fn(chunk);
 			spin_lock(lock);
+		} else {
+			fn(chunk);
+		}
 	}
 	return ret;
 }
-- 
1.9.1

