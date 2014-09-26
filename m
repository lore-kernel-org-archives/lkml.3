Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbaIZKi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:38:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672AbaIZJpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 013/142] Btrfs: fix crash on endio of reading corrupted block
Date: Fri, 26 Sep 2014 11:43:44 +0200
Message-Id: <8f543e8182632771ed610a88a7b8594b3c6f6820.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Bo <bo.li.liu@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 38c1c2e44bacb37efd68b90b3f70386a8ee370ee upstream.

The crash is

------------[ cut here ]------------
kernel BUG at fs/btrfs/extent_io.c:2124!
[...]
Workqueue: btrfs-endio normal_work_helper [btrfs]
RIP: 0010:[<ffffffffa02d6055>]  [<ffffffffa02d6055>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]

This is in fact a regression.

It is because we forgot to increase @offset properly in reading corrupted block,
so that the @offset remains, and this leads to checksum errors while reading
left blocks queued up in the same bio, and then ends up with hiting the above
BUG_ON.

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/extent_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b395791dd923..594bbfd4996e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2485,6 +2485,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
 				if (err)
 					uptodate = 0;
+				offset += len;
 				continue;
 			}
 		}
-- 
2.1.0

