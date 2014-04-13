Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaDMVwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 17:52:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44517 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaDMVwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 17:52:49 -0400
Date: Sun, 13 Apr 2014 22:52:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>, tytso@mit.edu
Subject: Re: [RFC][PATCH] vfs: In mntput run deactivate_super on a shallow
 stack.
Message-ID: <20140413215242.GP18016@ZenIV.linux.org.uk>
References: <87sipmbe8x.fsf@x220.int.ebiederm.org>
 <20140409175322.GZ18016@ZenIV.linux.org.uk>
 <20140409182830.GA18016@ZenIV.linux.org.uk>
 <87txa286fu.fsf@x220.int.ebiederm.org>
 <87fvlm860e.fsf_-_@x220.int.ebiederm.org>
 <20140409232423.GB18016@ZenIV.linux.org.uk>
 <87lhva5h4k.fsf@x220.int.ebiederm.org>
 <20140413053956.GM18016@ZenIV.linux.org.uk>
 <87zjjp3e7w.fsf@x220.int.ebiederm.org>
 <87ppkl1xb7.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppkl1xb7.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 12:51:56AM -0700, Eric W. Biederman wrote:

> btrfs_init_test_fs, and of course I was silly when I thought the module
> ref count would be useful for something before init_module succeeds.
> 
> Still I suspect I was on the right track.  We do have the get_fs_type,
> get_filesystem and put_filesystem.  Which ought to be enough to allow
> us to convert unregister_filesystem into an appropriate barrier.

Umm...  I don't think so - register_filesystem and unregister_filesystem
are only about the fs being visible in fs type list.  You do *not* have
to register the sucker at all in order to be able to do kern_mount().
So the call of unregister_filesystem() is not guaranteed to happen at
all - as the matter of fact, I think we ought to stop registering any
mount_pseudo()-based ones (pipefs, etc.) and the only reason for _not_
doing that is that some scripts might be poking in /proc/filesystems.
We definitely do not want that for anything *new* that isn't mountable
from userland...

BTW, could somebody explain this: in fs/ext4/super.c we have
#define IS_EXT2_SB(sb) ((sb)->s_bdev->bd_holder == &ext2_fs_type)
What's wrong with simple ((sb)->s_type == &ext2_fs_type)?  What am
I missing there?  Ted?

FWIW, I have found one bug of similar sort, but it's already
present with the current semantics: init_hugetlb_fs() has
        for_each_hstate(h) { 
                char buf[50];
                unsigned ps_kb = 1U << (h->order + PAGE_SHIFT - 10);

                snprintf(buf, sizeof(buf), "pagesize=%uK", ps_kb);
                hugetlbfs_vfsmount[i] = kern_mount_data(&hugetlbfs_fs_type,
                                                        buf);

                if (IS_ERR(hugetlbfs_vfsmount[i])) {
                        pr_err("hugetlb: Cannot mount internal hugetlbfs for "
                                "page size %uK", ps_kb);
                        error = PTR_ERR(hugetlbfs_vfsmount[i]);
                        hugetlbfs_vfsmount[i] = NULL;
                }
                i++;
        }
        /* Non default hstates are optional */
        if (!IS_ERR_OR_NULL(hugetlbfs_vfsmount[default_hstate_idx]))
                return 0;
followed by
	kmem_cache_destroy(hugetlbfs_inode_cachep);

If some of those kern_mount_data() succeed, but not the one we really
want to have, we'll end up with kmem_cache_destroy() on non-empy cache...
Granted, it's very unlikely to happen, but it's still a bug.  BTW, that
IS_ERR_OR_NULL() there looks like cargo-culting - it's ERR_PTR() is
explicitly turned into NULL a few lines above...

Another thing: does anybody seriously expect the system to survive with
every pipe(2) failing (and oopsing, actually)?  If not, we probably should
just make init_pipe_fs() panic on failure...  The same goes for sock_init(),
IMO...
