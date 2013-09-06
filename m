Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab3IFSY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:24:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:32430 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab3IFSY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:24:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,855,1371106800"; 
   d="scan'208";a="399510778"
Subject: [PATCH 1/2] fs/superblock: Unregister sb shrinker before
 ->kill_sb()
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Sep 2013 11:24:22 -0700
Message-ID: <1378491862.3467.6.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave, 

I've created the two patches we've discussed on the
mail thread regarding avoiding grab_super_passive during
memory reclaim.

Tim

From: 	Dave Chinner <david@fromorbit.com>
We will like to unregister the sb shrinker before ->kill_sb().
This will allow cached objects to be counted without call to
grab_super_passive() to update ref count on sb. We want
to avoid locking during memory reclamation especially when
we are skipping the memory reclaim when we are out of
cached objects.

This is safe because grab_super_passive does a try-lock on the sb->s_umount
now, and so if we are in the unmount process, it won't ever block.
That means what used to be a deadlock and races we were avoiding
by using grab_super_passive() is now:

        shrinker                        umount

        down_read(shrinker_rwsem)
                                        down_write(sb->s_umount)
                                        shrinker_unregister
                                          down_write(shrinker_rwsem)
                                            <blocks>
        grab_super_passive(sb)
          down_read_trylock(sb->s_umount)
            <fails>
        <shrinker aborts>
        ....
        <shrinkers finish running>
        up_read(shrinker_rwsem)
                                          <unblocks>
                                          <removes shrinker>
                                          up_write(shrinker_rwsem)
                                        ->kill_sb()
                                        ....

So it is safe to deregister the shrinker before ->kill_sb().

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index 73d0952..b724f35 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -324,10 +324,10 @@ void deactivate_locked_super(struct super_block *s)
 	struct file_system_type *fs = s->s_type;
 	if (atomic_dec_and_test(&s->s_active)) {
 		cleancache_invalidate_fs(s);
+		unregister_shrinker(&s->s_shrink);
 		fs->kill_sb(s);
 
 		/* caches are now gone, we can safely kill the shrinker now */
-		unregister_shrinker(&s->s_shrink);
 		list_lru_destroy(&s->s_dentry_lru);
 		list_lru_destroy(&s->s_inode_lru);
 
-- 
1.7.11.7



