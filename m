Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaDMFkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 01:40:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40298 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaDMFkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 01:40:04 -0400
Date: Sun, 13 Apr 2014 06:39:56 +0100
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
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH] vfs: In mntput run deactivate_super on a shallow
 stack.
Message-ID: <20140413053956.GM18016@ZenIV.linux.org.uk>
References: <87wqezl5df.fsf_-_@x220.int.ebiederm.org>
 <20140409023027.GX18016@ZenIV.linux.org.uk>
 <20140409023947.GY18016@ZenIV.linux.org.uk>
 <87sipmbe8x.fsf@x220.int.ebiederm.org>
 <20140409175322.GZ18016@ZenIV.linux.org.uk>
 <20140409182830.GA18016@ZenIV.linux.org.uk>
 <87txa286fu.fsf@x220.int.ebiederm.org>
 <87fvlm860e.fsf_-_@x220.int.ebiederm.org>
 <20140409232423.GB18016@ZenIV.linux.org.uk>
 <87lhva5h4k.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhva5h4k.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 03:15:39PM -0700, Eric W. Biederman wrote:

> Can you explain which scenario you are thinking about with respect to a
> failed modprobe?

Completely made up example:

static struct file_system_type foofs = {
	.mount = mount_foo,
	.kill_sb = kill_foo,
};

static struct vfsmount *mnt;

static __init int foo_init(void)
{
	int err;
	err = init_some();
	if (err < 0)
		return err;
	mnt = kern_mount(&foofs);
	if (IS_ERR(mnt)) {
		uninit_some();
		return PTR_ERR(mnt);
	}
	err = init_some_more();
	if (err < 0) {
		kern_umount(mnt);
		uninit_some();
		return err;
	}
	printk(KERN_INFO "loaded foo");
	return 0;
}

Now, think what happens if init_some_more() in the above fails.  With the
current mntput() semantics, everything works.  After making mntput() (from
kern_umount()) delayed until the return to userland, we end up with attempt
to call kill_foo() after the memory where it code sits gets freed.  For that
matter, by that point we are not even guaranteed to reach it, since it
comes as mnt->mnt_sb->s_type->kill_sb() and s_type points to freed memory.

I'm not saying that we have something that would closely resemble this
example, but it's not hard to vary it in a lot of ways, keeping the same
problem.  Basically, you need to audit all paths leading from failure
exits in some module_init() to mntput() and figure out if delaying the
effect of that mntput() would be safe there (== doesn't get delayed past
the point where we destroy something needed for that fs shutdown).

It's not *that* horrible, since not too many modules out there are
declaring any fs types, but it needs to be done.  In theory, you could
also fall prey to something like this:
	type = get_fs_type("proc");
	ns = kmalloc(...);
	/* fill *ns */
	mnt = kern_mount_data(type, p);
	...
	if (error) {
		kern_unmount(mnt);
		kfree(p);
		put_filesystem(type);
	}
possibly with get_fs_type() replaced with some other way to get that
pointer to fs type (defined elsewhere).  E.g. for procfs it could
be, say, task_active_pid_ns(current)->proc_mnt->mnt_sb->s_type, etc.

Again, it's not impossible to audit (there's not a lot of places where
struct file_system_type * is ever stored, there are few instances of
struct file_system_type, all statically allocated, etc.), but it's
a non-trivial amount of work.  And I honestly don't know if we have
any such places right now.  Moreover, unless you feel like repeating
that kind of audit every merge window, we'll need a some way of dealing
with such situations.  Something like flush_pending_mntput(fs_type), for
example, documented as barrier to be used in such places might do, but
if you can think of something more fool-proof...
