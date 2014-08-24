Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaHXWnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 18:43:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbaHXWnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 18:43:46 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 25 Aug 2014 08:42:36 +1000
Subject: [PATCH 3/6] autofs4: make "autofs4_can_expire" idempotent.
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Message-ID: <20140824224236.16196.77033.stgit@notabene.brown>
In-Reply-To: <20140824223628.16196.5795.stgit@notabene.brown>
References: <20140824223628.16196.5795.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have a "test" function change the value it is testing can
be confusing, particularly as a future patch will be calling
this function twice.

So move the update for 'last_used' to avoid repeat expiry
to the place where the final determination on what to expire is known.

Reviewed-by: Ian Kent <raven@themaw.net>
Tested-by: Ian Kent <raven@themaw.net>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/autofs4/expire.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index bee939efca2b..af09dada91bc 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -30,12 +30,6 @@ static inline int autofs4_can_expire(struct dentry *dentry,
 		/* Too young to die */
 		if (!timeout || time_after(ino->last_used + timeout, now))
 			return 0;
-
-		/* update last_used here :-
-		   - obviously makes sense if it is in use now
-		   - less obviously, prevents rapid-fire expire
-		     attempts if expire fails the first time */
-		ino->last_used = now;
 	}
 	return 1;
 }
@@ -541,6 +535,8 @@ int autofs4_expire_run(struct super_block *sb,
 
 	spin_lock(&sbi->fs_lock);
 	ino = autofs4_dentry_ino(dentry);
+	/* avoid rapid-fire expire attempts if expiry fails */
+	ino->last_used = now;
 	ino->flags &= ~AUTOFS_INF_EXPIRING;
 	complete_all(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
@@ -567,6 +563,8 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
 
 		spin_lock(&sbi->fs_lock);
+		/* avoid rapid-fire expire attempts if expiry fails */
+		ino->last_used = now;
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
 		complete_all(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);


