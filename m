Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbaDQWMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 18:12:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33765 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaDQWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 18:12:12 -0400
Date: Thu, 17 Apr 2014 23:12:03 +0100
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
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15
Message-ID: <20140417221203.GC18016@ZenIV.linux.org.uk>
References: <87lhva5h4k.fsf@x220.int.ebiederm.org>
 <20140413053956.GM18016@ZenIV.linux.org.uk>
 <87zjjp3e7w.fsf@x220.int.ebiederm.org>
 <87ppkl1xb7.fsf@x220.int.ebiederm.org>
 <20140413215242.GP18016@ZenIV.linux.org.uk>
 <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
 <87ppkhc4pp.fsf@x220.int.ebiederm.org>
 <87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
 <20140417202237.GA18016@ZenIV.linux.org.uk>
 <87tx9rwsz4.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tx9rwsz4.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 02:23:27PM -0700, Eric W. Biederman wrote:

> The typically system has about 12 mounts and no mount namespaces.
> Making umount of any kind a rare case.

The typical system has no userns either.  Take a look at e.g. docker
setups (and unless I'm mistaken, they are going to become a serious
usecase for your stuff as well).

> Al my apologies for not picking your favorite solution and in choosing
> not to audit every call to mntput in the tree this week I have made an
> uncommon case slower.
> 
> These bug fixes are important, the code is correct, and it is
> technically straight forward to remove the wait in mntput in most
> cases.
> 
> I am very frustrated that when given lots of opportunities to look at
> and comment on my code it is hard to get you to engage and comment
> unless I send a pull request to Linus.

Sigh...  FYI, here's what was going on through since Sunday: I had been
beating vfs.git#for-next into shape, exactly to avoid the kind of fun
we had this cycle.  With xfstests update in the middle of it, picking
a bunch of fun both in my code and elsewhere.  With any luck, this stuff
is dealt with (see vfs.git on git.kernel.org) and we might be able to
avoid that kind of shit this time around.

Now I can get to your series.  And no, I'm _not_ suggesting an audit of
every mntput() in the tree.  Really.  It's much more limited thing -
we only need to take care of
	* mntput() from kernel threads.  The same kind of situation we
have with final fput(), the same solution works.
	* *KERNEL* vfsmounts; anything without MNT_INTERNAL is fair game
as far as ordering of fs shutdown is concerned.  If it wasn't MNT_INTERNAL,
and we'd done mntput() before destroying some data structures needed for
fs shutdown, we had been fucked anyway - no warranties that mntput() had
been the final one.  Moreover, that means going through kern_unmount() or
simple_release_fs().  Which is trivially dealt with by providing
mntput_sync(mnt) that *will* wait and using it in those two.  Again, if
we have an extra reference (e.g. stuffed into a struct file, etc.) -
we can't rely on mntput() being final.

I'd probably turn mntput_no_expire() into something like
static struct mount *__mntput(struct mount *m)
that would return NULL if nothing needs to be killed and returned m
if m really needs killing.  Leaving the caller to decide what to do
with that puppy.  We have, as it is, exactly two callers - exit path
in sys_umount() and mntput().  So we add two more functions:
static void kill_mnt_async(struct mount *m)
and
static void kill_mnt_sync(struct mount *m)
both being no-op on NULL.  Then in sys_umount() and mntput() we do
	kill_mnt_async(__mntput(mnt));
and in mntput_sync() - kill_mnt_sync(__mntput(mnt));
For that matter, kill_mnt_sync() (basically, your variant with completions)
can be folded into mntput_sync().

kill_mnt_async() would be a direct analog of this:
                struct task_struct *task = current;

                if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
                        init_task_work(&file->f_u.fu_rcuhead, ____fput);
                        if (!task_work_add(task, &file->f_u.fu_rcuhead, true))
                                return;
                        /*
                         * After this task has run exit_task_work(),
                         * task_work_add() will fail.  Fall through to delayed
                         * fput to avoid leaking *file.
                         */
                }

                if (llist_add(&file->f_u.fu_llist, &delayed_fput_list))
                        schedule_delayed_work(&delayed_fput_work, 1);
with obvious replacements.  Works for struct file, will work here as well.

That's all.  And yes, I believe that such series would make sense on its
own and once it survives beating (see above about docker - that bastard has
surprised me quite a bit re stressing namespace-related codepaths), I would
be quite willing to help with getting it merged.
