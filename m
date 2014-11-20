Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaKTFTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 00:19:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57808 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaKTFTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 00:19:48 -0500
Date: Thu, 20 Nov 2014 05:19:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
Subject: gfs2: gfs2_dir_get_hash_table(): avoiding deferred vfree() is easy
 here...
Message-ID: <20141120051947.GG7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfree() is allowed under spinlock these days, but it's cheaper when
it doesn't step into deferred case and here it's very easy to avoid.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/gfs2/dir.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index c247fed..c5a34f0 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -370,11 +370,12 @@ static __be64 *gfs2_dir_get_hash_table(struct gfs2_inode *ip)
 	}
 
 	spin_lock(&inode->i_lock);
-	if (ip->i_hash_cache)
-		kvfree(hc);
-	else
+	if (likely(!ip->i_hash_cache)) {
 		ip->i_hash_cache = hc;
+		hc = NULL;
+	}
 	spin_unlock(&inode->i_lock);
+	kvfree(hc);
 
 	return ip->i_hash_cache;
 }
-- 
1.7.10.4

