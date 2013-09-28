Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3I1U1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 16:27:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50504 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3I1U1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 16:27:32 -0400
Date: Sat, 28 Sep 2013 21:27:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [rfc][possible solution] RCU vfsmounts
Message-ID: <20130928202728.GK13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	FWIW, I think I have a kinda-sorta solution for that and I'd like
to hear your comments on that.  I want to replace vfsmount_lock with seqlock
and store additional seq number in nameidata, set to vfsmount_seq in the
beginning and rechecked in unlazy_walk/complete_walk.

	The obvious variant would be to have unlazy_walk/complete_walk to
grab refcount, check vfsmount_seq and mntput on mismatch.  The trouble
with that is race with what would've been the final mntput() done by
umount(2); complete_walk() would drop that temporary reference and
fail, all right, but... we would get a umount(2) returning without having
actually shut the filesystem down.  Said shutdown would happen in whoever
had been doing pathname resolution that stepped into the race.

	I _think_ I have a workable variant:
	* new vfsmount flag (MNT_SYNC_UMOUNT or something like that) and
ability to tell umount_tree() to set that on all victims; done on
non-lazy umount and on expiry.  Never cleared once set, and set only
when propagate_mount_busy() has been called and returned true.
Set before bumping vfsmount_seq.
	* rcu_barrier() added in namespace_unlock(), between
dropping namespace_sem and doing mntput() on the victims.
	* unlazy_walk() and complete_walk() use the common helper along
the lines of

legitimize_mnt(struct vfsmount *mnt, unsigned seq)
{
	if (read_seqcount_retry(&vfsmount_seq, seq)) {
		rcu_read_unlock();
		return false;
	}
	mntget(mnt);
	if (!read_seqcount_retry(&vfsmount_seq, seq)) {
		rcu_read_unlock();
		return true;
	}
	if (mnt->mnt_flags & MNT_SYNC_UMOUNT) {
		/* it couldn't have gotten through rcu_barrier() yet */
		mnt_add_count(real_mount(mnt), -1);
		rcu_read_unlock();
		return false;
	}
	rcu_read_unlock();
	mntput(mnt);
	return false;
}

Freeing vfsmounts would be done with rcu delay, vfsmount hash lookups,
d_path(), etc. do the obvious things as we do with rename_lock for dentry
side of things - that stuff is all obvious.  Not ending up with final
mntput() stolen from something that really expects it to be final is the
hard part and it looks like the above would be a solution.

Comments?  AFAICS, that would've killed *all* vfsmount-related locked stores
in RCU-mode pathwalks...
