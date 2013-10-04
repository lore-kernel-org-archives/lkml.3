Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3JDUPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:15:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49469 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3JDUPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:15:16 -0400
Date: Fri, 4 Oct 2013 21:15:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: security: lockless stat() issues
Message-ID: <20131004201512.GQ13318@ZenIV.linux.org.uk>
References: <CA+55aFxndx0J0sTLTx0qu25TkoLLfGd+8qiLhdG5CYwpO1NvVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxndx0J0sTLTx0qu25TkoLLfGd+8qiLhdG5CYwpO1NvVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 12:33:17PM -0700, Linus Torvalds wrote:

> So how do people feel about passing a "mode" value for
> security_inode_getattr(), the same way we do for
> security_inode_permission()? The only flag would be that MAY_NOT_BLOCK
> flag that gets set for RCU lookup, and the semantics would be the same
> (return -ECHILD if you need to sleep).
> 
> Attached is a patch that adds the interface, and then makes all
> security layers just do that ECHILD thing (and nobody actually sets
> MAY_NOT_BLOCK yet). So it's purely preparatory. It's also
> insufficient, because we'll need the same kind o fflag for the
> low-level filesystem "i_op->getattr()" call, but that's an independent
> issue.
> 
> Al, any comments?

Just a couple of days ago you'd been complaining about filesystems exposure
to rcuwalk details and now you propose to increase the contact surface
by one more method?  OK...

For one thing, that will definitely require lazy freeing of struct
super_block itself.  At the very least, you want ->i_sb->s_dev, even
on default pathway.  Another thing is that API is wrong for that
kind of stuff - we pass vfsmount/dentry pair and we end up looking
at the inode guts.  Fine, but in RCU case you must cope with the
possibility of dentry->d_inode going NULL under you.  Which isn't
all that terrible, but we need to slap ACCESS_ONCE() into each method
instance (all 34 of them).  IOW, it's worse than just "oh, we need to
add a flag"; we'll need to pass the sodding inode separately, with
dire warnings not to use dentry->d_inode.

It's not impossible to do, of course, but it won't be fun...

Oh, well...  In any case, we need something in Documentation/filesystems
describing the RCU-related rules for fs writers - exposure surface, what
to avoid, etc.
