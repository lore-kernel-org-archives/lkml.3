Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaIXUQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:16:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40643 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaIXUQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:16:33 -0400
Date: Wed, 24 Sep 2014 21:16:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrey Wagin <avagin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: linux-next: cgroup_mount() falls asleep forever
Message-ID: <20140924201629.GH7996@ZenIV.linux.org.uk>
References: <CANaxB-ykM+5h4+x5hHK2Z_APpiQLvGvc=2nBR5pGQS=msqp6ZA@mail.gmail.com>
 <CANaxB-zqeJ0mse0J0=aH4uV+yRdgVhmHbAq4Wa8tW-81sNSMJA@mail.gmail.com>
 <20140924185213.GB7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924185213.GB7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 07:52:14PM +0100, Al Viro wrote:

> Could somebody explain WTF is the whole construction trying to do?  Not
> to mention anything else, what *does* this pinning a superblock protect
> from?  Suppose we have a superblock for the same root with non-NULL ns
> and _that_ gets killed.  We get hit by the same
> 	percpu_ref_kill(&root->cgrp.self.refcnt);
> so what's the point of pinned_sb?  Might as well have just bumped the
> refcount, superblock or no superblock.  And no, delaying that kernfs_kill_sb()
> does you no good whatsoever - again, pinned_sb might have nothing to do with
> the superblock we are after.

Hrm...  Scratch the comments re "different superblock" (we are passing NULL
ns in that kernfs_mount() below), but...  then WTF is that thing trying to
do?  OK, you've got your active reference to a superblock from
kernfs_pin_sb().  You grab root->cgrp.self.refcnt.  Suppose it also worked.
Now what?  You drop cgroup_mutex and proceed to kernfs_mount().  Which
calls sget(), looking for exact same thing as your kernfs_pin_sb().  So it
finds the same superblock and grab it for you (with ->s_umount held).
At which point you drop root->cgrp.self.refcnt and drop the active reference
you've got from kernfs_pin_sb().  Pardon me, but what's the point of that
song and dance?  Who else can make that attempt at grabbing
root->cgrp.self.refcnt fail?

BTW, what happens if kernfs_fill_super() fails?  You get cgroup_kill_sb()
triggered by deactivate_locked_super(), which calls kernfs_kill_sb(), which
does kernfs_put().  Balancing the kernfs_get() we'd never got around to
in kernfs_fill_super()...
