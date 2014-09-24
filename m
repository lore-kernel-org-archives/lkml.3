Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaIXSwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:52:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40519 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaIXSwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:52:17 -0400
Date: Wed, 24 Sep 2014 19:52:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrey Wagin <avagin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: linux-next: cgroup_mount() falls asleep forever
Message-ID: <20140924185213.GB7996@ZenIV.linux.org.uk>
References: <CANaxB-ykM+5h4+x5hHK2Z_APpiQLvGvc=2nBR5pGQS=msqp6ZA@mail.gmail.com>
 <CANaxB-zqeJ0mse0J0=aH4uV+yRdgVhmHbAq4Wa8tW-81sNSMJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANaxB-zqeJ0mse0J0=aH4uV+yRdgVhmHbAq4Wa8tW-81sNSMJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 06:29:27PM +0400, Andrey Wagin wrote:
> 2014-09-24 14:31 GMT+04:00 Andrey Wagin <avagin@gmail.com>:
> > Hi All,
> 
> The problem is in a following commit:
> 
> commit 0c7bf3e8cab7900e17ce7f97104c39927d835469
> Author: Zefan Li <lizefan@huawei.com>
> Date:   Sat Sep 20 14:49:10 2014 +0800
> 
>     cgroup: remove redundant variable in cgroup_mount()
> 
>     Both pinned_sb and new_sb indicate if a new superblock is needed,
>     so we can just remove new_sb.
> 
>     Note now we must check if kernfs_tryget_sb() returns NULL, because
>     when it returns NULL, kernfs_mount() may still re-use an existing
>     superblock, which is just allocated by another concurent mount.
> 
>     Suggested-by: Tejun Heo <tj@kernel.org>
>     Signed-off-by: Zefan Li <lizefan@huawei.com>
>     Signed-off-by: Tejun Heo <tj@kernel.org>

Lovely...  First of all, that thing is obviously racy - there's nothing
to prevent another mount happening between these two places.  Moreover,
kernfs_mount() calling conventions are really atrocious - pointer to
bool just to indicate that superblock is new?

Could somebody explain WTF is the whole construction trying to do?  Not
to mention anything else, what *does* this pinning a superblock protect
from?  Suppose we have a superblock for the same root with non-NULL ns
and _that_ gets killed.  We get hit by the same
	percpu_ref_kill(&root->cgrp.self.refcnt);
so what's the point of pinned_sb?  Might as well have just bumped the
refcount, superblock or no superblock.  And no, delaying that kernfs_kill_sb()
does you no good whatsoever - again, pinned_sb might have nothing to do with
the superblock we are after.
