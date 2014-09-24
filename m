Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaIXTZC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:25:02 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:55132 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaIXTZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:25:00 -0400
Date: Wed, 24 Sep 2014 15:24:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrey Wagin <avagin@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: linux-next: cgroup_mount() falls asleep forever
Message-ID: <20140924192456.GA1233@mtj.dyndns.org>
References: <CANaxB-ykM+5h4+x5hHK2Z_APpiQLvGvc=2nBR5pGQS=msqp6ZA@mail.gmail.com>
 <CANaxB-zqeJ0mse0J0=aH4uV+yRdgVhmHbAq4Wa8tW-81sNSMJA@mail.gmail.com>
 <20140924185213.GB7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924185213.GB7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Al.

On Wed, Sep 24, 2014 at 07:52:14PM +0100, Al Viro wrote:
> On Wed, Sep 24, 2014 at 06:29:27PM +0400, Andrey Wagin wrote:
> > 2014-09-24 14:31 GMT+04:00 Andrey Wagin <avagin@gmail.com>:
> > > Hi All,
> > 
> > The problem is in a following commit:
> > 
> > commit 0c7bf3e8cab7900e17ce7f97104c39927d835469
> > Author: Zefan Li <lizefan@huawei.com>
> > Date:   Sat Sep 20 14:49:10 2014 +0800
> > 
> >     cgroup: remove redundant variable in cgroup_mount()
> > 
> >     Both pinned_sb and new_sb indicate if a new superblock is needed,
> >     so we can just remove new_sb.
> > 
> >     Note now we must check if kernfs_tryget_sb() returns NULL, because
> >     when it returns NULL, kernfs_mount() may still re-use an existing
> >     superblock, which is just allocated by another concurent mount.
> > 
> >     Suggested-by: Tejun Heo <tj@kernel.org>
> >     Signed-off-by: Zefan Li <lizefan@huawei.com>
> >     Signed-off-by: Tejun Heo <tj@kernel.org>

I'm gonna wait for Li's response for a couple days and then revert it
if it can't be fixed differently.

> Lovely...  First of all, that thing is obviously racy - there's nothing
> to prevent another mount happening between these two places.  Moreover,
> kernfs_mount() calling conventions are really atrocious - pointer to
> bool just to indicate that superblock is new?
> 
> Could somebody explain WTF is the whole construction trying to do?  Not
> to mention anything else, what *does* this pinning a superblock protect
> from?  Suppose we have a superblock for the same root with non-NULL ns
> and _that_ gets killed.  We get hit by the same
> 	percpu_ref_kill(&root->cgrp.self.refcnt);
> so what's the point of pinned_sb?  Might as well have just bumped the
> refcount, superblock or no superblock.  And no, delaying that kernfs_kill_sb()
> does you no good whatsoever - again, pinned_sb might have nothing to do with
> the superblock we are after.

Yeah, it's an ugly thing to work around vfs interface not very
conducive for filesystems which conditionally create or reuse
superblocks during mount.  There was a thread explaining what's going
on.  Looking up...

  http://thread.gmane.org/gmane.linux.kernel.containers/27623/focus=10635

Thanks.

-- 
tejun
