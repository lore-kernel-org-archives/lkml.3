Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3HUUFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:05:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:36971 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab3HUUF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:05:29 -0400
Date: Thu, 22 Aug 2013 05:04:59 +0900 (JST)
Message-Id: <20130822.050459.85418575.konishi.ryusuke@lab.ntt.co.jp>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, rwheeler@redhat.com, avati@redhat.com,
        bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, raven@themaw.net
Subject: Re: [PATCH 0/9] [RFC v2] safely drop directory dentry on failed
 revalidate
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20130821054055.GN27005@ZenIV.linux.org.uk>
References: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
	<20130821054055.GN27005@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Thu, 22 Aug 2013 05:05:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 06:40:56 +0100, Al Viro wrote:
> 	And I would like to understand what nilfs one is trying to do...
> Unless I'm seriously misreading that code, it's *not* on any kind of a hot
> path, so I really wonder why don't we simply do shrink_dcache_parent() +
> check if d_count has dropped to 1, without trying to look for submounts
> first - if we have any, shrink_dcache_parent() is simply going to leave
> us with d_count > 1 and that's it.  Actually, it's cheaper that way -
> no need to walk the tree twice.

> 	We are really getting too many tree walkers in fs/dcache.c and
> all that duplication is the prime breeding ground for bugs ;-/

I agree that we can eliminate have_submounts() from nilfs.  Please
apply the following patch if you hope so.

> Moreover, checking for d_count == 1
> case first is also pointless - in that case we have no children at all
> and shrink_dcache_parent() will return immediately.

This also looks true.  I will confirm whether we can remove the
pre-check for d_count == 1 case.


Regards,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Thu, 22 Aug 2013 01:53:03 +0900
Subject: [PATCH] nilfs2: do not use have_submounts()

The pre-check with have_submounts() in
nilfs_try_to_shrink_tree(root_dentry) is eliminable since the return
value of the function does not depend on whether the root_dentry has
sub-mounts or not.  Removing the have_submount() pre-check may cause
unnecessary dcache shrinking, but the impact looks limited because
nilfs_try_to_shrink_tree() is not called in usual operation.

So, we remove use of have_submounts() from nilfs.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/super.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index af3ba04..38fe240 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1007,8 +1007,6 @@ static int nilfs_tree_was_touched(struct dentry *root_dentry)
  */
 static int nilfs_try_to_shrink_tree(struct dentry *root_dentry)
 {
-	if (have_submounts(root_dentry))
-		return true;
 	shrink_dcache_parent(root_dentry);
 	return nilfs_tree_was_touched(root_dentry);
 }
-- 
1.7.9.3

