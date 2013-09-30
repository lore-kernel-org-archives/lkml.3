Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3I3TtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:49:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53349 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab3I3TtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:49:24 -0400
Date: Mon, 30 Sep 2013 20:49:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [rfc][possible solution] RCU vfsmounts
Message-ID: <20130930194921.GS13318@ZenIV.linux.org.uk>
References: <20130928202728.GK13318@ZenIV.linux.org.uk>
 <CA+55aFzrjiM6bgqNgdckJGAZks2fR8ZD+R_5AqxvrnS64DD3ow@mail.gmail.com>
 <20130929060601.GL13318@ZenIV.linux.org.uk>
 <CA+55aFyGY7hZTDhWiyWBe+oSkxd2GzoYWGhvXtGTyZKL-3PZ1w@mail.gmail.com>
 <20130929181047.GM13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130929181047.GM13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 07:10:47PM +0100, Al Viro wrote:

> FWIW, right now I'm reviewing the subset of fs code that can be hit in
> RCU mode.

OK...  AFAICS, we are not too far from being able to handle RCU pathwalk
straying into fs in the middle of being shut down.
	* There are 5 methods that can be called:
->d_hash(...)
->d_compare(...)
->d_revalidate(..., LOOKUP_RCU | ...)
->d_manage(..., true)
->permission(..., MAY_NOT_BLOCK | MAY_EXEC)
Filesystem needs to be able to survive those during shutdown.  The stuff
needed for that should _not_ be freed without synchronize_rcu() (or via
call_rcu()); usually ->s_fs_info is involved (when anything is needed
at all).  In any case, we shouldn't allow rmmod without making sure that
everything in RCU mode has run out, but most of the filesystems have
rcu_barrier() in their exit_module anyway.
	* __put_super() probably ought to delay actual freeing via
call_rcu(); might not be strictly necessary, but probably a good idea
anyway.
	* shrink_dcache_for_umount() ought to use d_walk(), a-la
shrink_dcache_parent().

Note that most of the filesystems don't have any of these methods or
don't look at anything outside of inode/dentry involved in RCU case.
Zoo:

* adfs: has the name length limit in fs-private part of superblock; used
by ->d_hash() and ->d_compare().  No other methods involved, synchronize_rcu()
before doing kfree() in adfs_put_super() will suffice.

* autofs4: wants fs-private part of superblock in ->d_manage().
synchronize_rcu() in autofs4_kill_sb() would do it, or we could delay
freeing that sucker via call_rcu() (in that case we want delayed
freeing in __put_super() as well).

* btrfs: wants btrfs_root_readonly(BTRFS_I(inode)->root) usable in
->permission().  Delayed freeing of struct btrfs_root, perhaps?

* cifs: wants nls, refered to from fs-private part of superblock.
->permission() wants fs-private part of superblock as well.  Just
synchronize_rcu() before unload_nls() in cifs_umount()...

* fat: same situation as with cifs

* fuse: delayed freeing of struct fuse_conn?  BTW, Miklos, just what is
        } else if (mask & (MAY_ACCESS | MAY_CHDIR)) {
                if (mask & MAY_NOT_BLOCK)
                        return -ECHILD;
about, when we never pass such combinations?  Oh, well...

* hpfs: similar to cifs and fat, only without use of nls (a homegrown table
of some sort).

* ncpfs: _probably_ similar to cifs et.al., but there might be dragons

* procfs: delayed freeing of pid_namespace?

* lustre: messy, haven't looked through that.

Overall, it looks doable.
