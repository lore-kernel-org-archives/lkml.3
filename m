Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab3IKFZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:25:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab3IKE50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:26 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=aNGXfs0vD7sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=yKfg51wq8esA:10 a=drOt6m5kAAAA:8 a=T2h1Z_K7z-JURIdn7sYA:9 a=jeBq3FmKZ4MA:10 a=4WJ10G-Clu1n_X21:21 a=KbpqDMbSeIllpiq9:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042911.435446916@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [115/251] livelock avoidance in sget()
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0115-livelock-avoidance-in-sget.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit acfec9a5a892f98461f52ed5770de99a3e571ae2 ]

Eric Sandeen has found a nasty livelock in sget() - take a mount(2) about
to fail.  The superblock is on ->fs_supers, ->s_umount is held exclusive,
->s_active is 1.  Along comes two more processes, trying to mount the same
thing; sget() in each is picking that superblock, bumping ->s_count and
trying to grab ->s_umount.  ->s_active is 3 now.  Original mount(2)
finally gets to deactivate_locked_super() on failure; ->s_active is 2,
superblock is still ->fs_supers because shutdown will *not* happen until
->s_active hits 0.  ->s_umount is dropped and now we have two processes
chasing each other:
s_active = 2, A acquired ->s_umount, B blocked
A sees that the damn thing is stillborn, does deactivate_locked_super()
s_active = 1, A drops ->s_umount, B gets it
A restarts the search and finds the same superblock.  And bumps it ->s_active.
s_active = 2, B holds ->s_umount, A blocked on trying to get it
... and we are in the earlier situation with A and B switched places.

The root cause, of course, is that ->s_active should not grow until we'd
got MS_BORN.  Then failing ->mount() will have deactivate_locked_super()
shut the damn thing down.  Fortunately, it's easy to do - the key point
is that grab_super() is called only for superblocks currently on ->fs_supers,
so it can bump ->s_count and grab ->s_umount first, then check MS_BORN and
bump ->s_active; we must never increment ->s_count for superblocks past
->kill_sb(), but grab_super() is never called for those.

The bug is pretty old; we would've caught it by now, if not for accidental
exclusion between sget() for block filesystems; the things like cgroup or
e.g. mtd-based filesystems don't have anything of that sort, so they get
bitten.  The right way to deal with that is obviously to fix sget()...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/super.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 0902cfa..7b6e4e5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -349,19 +349,19 @@ EXPORT_SYMBOL(deactivate_super);
  *	and want to turn it into a full-blown active reference.  grab_super()
  *	is called with sb_lock held and drops it.  Returns 1 in case of
  *	success, 0 if we had failed (superblock contents was already dead or
- *	dying when grab_super() had been called).
+ *	dying when grab_super() had been called).  Note that this is only
+ *	called for superblocks not in rundown mode (== ones still on ->fs_supers
+ *	of their type), so increment of ->s_count is OK here.
  */
 static int grab_super(struct super_block *s) __releases(sb_lock)
 {
-	if (atomic_inc_not_zero(&s->s_active)) {
-		spin_unlock(&sb_lock);
-		return 1;
-	}
-	/* it's going away */
 	s->s_count++;
 	spin_unlock(&sb_lock);
-	/* wait for it to die */
 	down_write(&s->s_umount);
+	if ((s->s_flags & MS_BORN) && atomic_inc_not_zero(&s->s_active)) {
+		put_super(s);
+		return 1;
+	}
 	up_write(&s->s_umount);
 	put_super(s);
 	return 0;
@@ -493,11 +493,6 @@ retry:
 				destroy_super(s);
 				s = NULL;
 			}
-			down_write(&old->s_umount);
-			if (unlikely(!(old->s_flags & MS_BORN))) {
-				deactivate_locked_super(old);
-				goto retry;
-			}
 			return old;
 		}
 	}
@@ -691,10 +686,10 @@ restart:
 		if (hlist_unhashed(&sb->s_instances))
 			continue;
 		if (sb->s_bdev == bdev) {
-			if (grab_super(sb)) /* drops sb_lock */
-				return sb;
-			else
+			if (!grab_super(sb))
 				goto restart;
+			up_write(&sb->s_umount);
+			return sb;
 		}
 	}
 	spin_unlock(&sb_lock);
-- 
1.7.10.4


