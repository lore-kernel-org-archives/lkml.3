Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3IMSmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:42:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44104 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab3IMSmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:42:09 -0400
Date: Fri, 13 Sep 2013 19:42:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linus Torvalds <torvalds@osdl.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: [GIT PULL] aio changes for 3.12
Message-ID: <20130913184204.GS13318@ZenIV.linux.org.uk>
References: <20130913165937.GL2517@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913165937.GL2517@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 12:59:37PM -0400, Benjamin LaHaise wrote:
> Hell Linus, Al and everyone,
> 
> First off, sorry for this pull request being late in the merge window.  Al 
> had raised a couple of concerns about 2 items in the series below.  I 
> addressed the first issue (the race introduced by Gu's use of mm_populate()),
> but he has not provided any further details on how he wants to rework the 
> anon_inode.c changes (which were sent out months ago but have yet to be 
> commented on).  The bulk of the changes have been sitting in the -next tree 
> for a few months, with all the issues raised being addressed.  Please 
> consider this pull.  Thanks,

OK...  As for objections against anon_inodes.c stuff, it can be dealt with
after merge.  Basically, I don't like using anon_inodes as a dumping ground -
look how little of what that sucker is doing has anything to do with the
code in anon_inodes.c; you override practically everything anyway.  It's
just a "filesystems are hard, let's go shopping".  Look, declaring an
fs takes about 20 lines.  Total.  All you really use from anon_inodes.c is

{
        struct inode *inode = new_inode_pseudo(s);
        if (!inode)
                return ERR_PTR(-ENOMEM);
        inode->i_ino = get_next_ino();
        inode->i_state = I_DIRTY;
        inode->i_mode = S_IRUSR | S_IWUSR;
        inode->i_uid = current_fsuid();
        inode->i_gid = current_fsgid();
        inode->i_flags |= S_PRIVATE;
        inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
        return inode;
}

which can bloody well go into fs/inode.c - it has nothing whatsoever
anon_inode-specific.  You end up overriding ->a_ops anyway.  Moreover,
your "allocate a file/dentry/inode and give it to me" helper creates
a struct file that needs to be patched up by caller.  What's the point
of passing ctx to anon_inode_getfile_private(), then?  And the same
will happen for any extra callers that API might grow.

Look, defining an fs is as simple as this:

struct vfsmount *aio_mnt;
static struct dentry *aio_mount(struct file_system_type *fs_type,
                                int flags, const char *dev_name, void *data)
{
	static const struct dentry_operations ops = {
		.d_dname        = simple_dname,
	};
	return mount_pseudo(fs_type, "aio:", NULL,
		&ops, 0x69696969);
}
and in aio_setup() do this
	static struct file_system_type aiofs = {
		.name           = "aio",
		.mount          = aio_mount,
		.kill_sb        = kill_anon_super,
	};
        aio_mnt = kern_mount(&aio_fs);
	if (IS_ERR(aio_mnt))
		panic("buggered");

That's all the glue you need.  Again, the proper solution is to take
fs-independent parts of anon_inode_mkinode() to fs/inode.c (there's a
lot of open-coded variants floating around in the tree, BTW) and do
what anon_inode_getfile_private() is trying to do right in aio.c.
With the patch-up you have to do afterwards folded in.  Look at what
it's doing, really.
	* allocate an inode, with uid/gid/ino/timestamps set in
usual way.  Should be fs/inode.c helper.
	* set the rest of it up (size, a_ops, ->mapping->private_data) -
the things you open-code anyway
	* d_alloc_pseudo() on constant name ("anon_inode:[aio]")
	* d_instantiate()
	* mntget()
	* alloc_file(), with &aio_ring_fops passed to it
	* set file->private_data (unused)
It might make sense to add a helper for steps 3--5 (something along the
lines of alloc_pseudo_file(mnt, name, inode, mode, fops)).  Step 6 is
useless, AFAICS.

Note that anon_inodes.c reason to exist was "it's for situations where
all context lives on struct file and we don't need separate inode for
them".  Going from that to "it happens to contain a handy function for inode
allocation"...
