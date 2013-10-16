Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab3JPBb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 21:31:58 -0400
Received: from tundra.namei.org ([65.99.196.166]:58210 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab3JPBb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 21:31:56 -0400
Date: Wed, 16 Oct 2013 12:36:15 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] Apparmor bugfixes for 3.12
Message-ID: <alpine.LRH.2.02.1310161234120.19614@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple more regressions fixed, please pull.

The following changes since commit 34ec4de42be5006abdd8d0c08b306ffaa64d0d5d:

  Merge tag 'devicetree-for-linus' of git://git.secretlab.ca/git/linux (2013-10-15 17:14:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

John Johansen (2):
      apparmor: fix memleak of the profile hash
      apparmor: fix bad lock balance when introspecting policy

 security/apparmor/apparmorfs.c |    4 +---
 security/apparmor/policy.c     |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

---

commit ed2c7da3a40c58410508fe24e12d03e508d7ec01
Author: John Johansen <john.johansen@canonical.com>
Date:   Mon Oct 14 11:46:27 2013 -0700

    apparmor: fix bad lock balance when introspecting policy
    
    BugLink: http://bugs.launchpad.net/bugs/1235977
    
    The profile introspection seq file has a locking bug when policy is viewed
    from a virtual root (task in a policy namespace), introspection from the
    real root is not affected.
    
    The test for root
        while (parent) {
    is correct for the real root, but incorrect for tasks in a policy namespace.
    This allows the task to walk backup the policy tree past its virtual root
    causing it to be unlocked before the virtual root should be in the p_stop
    fn.
    
    This results in the following lockdep back trace:
    [   78.479744] [ BUG: bad unlock balance detected! ]
    [   78.479792] 3.11.0-11-generic #17 Not tainted
    [   78.479838] -------------------------------------
    [   78.479885] grep/2223 is trying to release lock (&ns->lock) at:
    [   78.479952] [<ffffffff817bf3be>] mutex_unlock+0xe/0x10
    [   78.480002] but there are no more locks to release!
    [   78.480037]
    [   78.480037] other info that might help us debug this:
    [   78.480037] 1 lock held by grep/2223:
    [   78.480037]  #0:  (&p->lock){+.+.+.}, at: [<ffffffff812111bd>] seq_read+0x3d/0x3d0
    [   78.480037]
    [   78.480037] stack backtrace:
    [   78.480037] CPU: 0 PID: 2223 Comm: grep Not tainted 3.11.0-11-generic #17
    [   78.480037] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
    [   78.480037]  ffffffff817bf3be ffff880007763d60 ffffffff817b97ef ffff8800189d2190
    [   78.480037]  ffff880007763d88 ffffffff810e1c6e ffff88001f044730 ffff8800189d2190
    [   78.480037]  ffffffff817bf3be ffff880007763e00 ffffffff810e5bd6 0000000724fe56b7
    [   78.480037] Call Trace:
    [   78.480037]  [<ffffffff817bf3be>] ? mutex_unlock+0xe/0x10
    [   78.480037]  [<ffffffff817b97ef>] dump_stack+0x54/0x74
    [   78.480037]  [<ffffffff810e1c6e>] print_unlock_imbalance_bug+0xee/0x100
    [   78.480037]  [<ffffffff817bf3be>] ? mutex_unlock+0xe/0x10
    [   78.480037]  [<ffffffff810e5bd6>] lock_release_non_nested+0x226/0x300
    [   78.480037]  [<ffffffff817bf2fe>] ? __mutex_unlock_slowpath+0xce/0x180
    [   78.480037]  [<ffffffff817bf3be>] ? mutex_unlock+0xe/0x10
    [   78.480037]  [<ffffffff810e5d5c>] lock_release+0xac/0x310
    [   78.480037]  [<ffffffff817bf2b3>] __mutex_unlock_slowpath+0x83/0x180
    [   78.480037]  [<ffffffff817bf3be>] mutex_unlock+0xe/0x10
    [   78.480037]  [<ffffffff81376c91>] p_stop+0x51/0x90
    [   78.480037]  [<ffffffff81211408>] seq_read+0x288/0x3d0
    [   78.480037]  [<ffffffff811e9d9e>] vfs_read+0x9e/0x170
    [   78.480037]  [<ffffffff811ea8cc>] SyS_read+0x4c/0xa0
    [   78.480037]  [<ffffffff817ccc9d>] system_call_fastpath+0x1a/0x1f
    
    Signed-off-by: John Johansen <john.johansen@canonical.com>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 95c2b26..7db9954 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -580,15 +580,13 @@ static struct aa_namespace *__next_namespace(struct aa_namespace *root,
 
 	/* check if the next ns is a sibling, parent, gp, .. */
 	parent = ns->parent;
-	while (parent) {
+	while (ns != root) {
 		mutex_unlock(&ns->lock);
 		next = list_entry_next(ns, base.list);
 		if (!list_entry_is_head(next, &parent->sub_ns, base.list)) {
 			mutex_lock(&next->lock);
 			return next;
 		}
-		if (parent == root)
-			return NULL;
 		ns = parent;
 		parent = parent->parent;
 	}

commit 5cb3e91ebd0405519795f243adbfc4ed2a6fe53f
Author: John Johansen <john.johansen@canonical.com>
Date:   Mon Oct 14 11:44:34 2013 -0700

    apparmor: fix memleak of the profile hash
    
    BugLink: http://bugs.launchpad.net/bugs/1235523
    
    This fixes the following kmemleak trace:
    unreferenced object 0xffff8801e8c35680 (size 32):
      comm "apparmor_parser", pid 691, jiffies 4294895667 (age 13230.876s)
      hex dump (first 32 bytes):
        e0 d3 4e b5 ac 6d f4 ed 3f cb ee 48 1c fd 40 cf  ..N..m..?..H..@.
        5b cc e9 93 00 00 00 00 00 00 00 00 00 00 00 00  [...............
      backtrace:
        [<ffffffff817a97ee>] kmemleak_alloc+0x4e/0xb0
        [<ffffffff811ca9f3>] __kmalloc+0x103/0x290
        [<ffffffff8138acbc>] aa_calc_profile_hash+0x6c/0x150
        [<ffffffff8138074d>] aa_unpack+0x39d/0xd50
        [<ffffffff8137eced>] aa_replace_profiles+0x3d/0xd80
        [<ffffffff81376937>] profile_replace+0x37/0x50
        [<ffffffff811e9f2d>] vfs_write+0xbd/0x1e0
        [<ffffffff811ea96c>] SyS_write+0x4c/0xa0
        [<ffffffff817ccb1d>] system_call_fastpath+0x1a/0x1f
        [<ffffffffffffffff>] 0xffffffffffffffff
    
    Signed-off-by: John Johansen <john.johansen@canonical.com>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 345bec0..705c287 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -610,6 +610,7 @@ void aa_free_profile(struct aa_profile *profile)
 	aa_put_dfa(profile->policy.dfa);
 	aa_put_replacedby(profile->replacedby);
 
+	kzfree(profile->hash);
 	kzfree(profile);
 }
 
