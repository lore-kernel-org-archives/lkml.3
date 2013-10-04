Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3JDUtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:49:16 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:55200 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3JDUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:49:14 -0400
MIME-Version: 1.0
In-Reply-To: <20131004201512.GQ13318@ZenIV.linux.org.uk>
References: <CA+55aFxndx0J0sTLTx0qu25TkoLLfGd+8qiLhdG5CYwpO1NvVQ@mail.gmail.com>
	<20131004201512.GQ13318@ZenIV.linux.org.uk>
Date: Fri, 4 Oct 2013 13:49:13 -0700
X-Google-Sender-Auth: QQnPzZTklnqDzbKVyOSxbE6h5IA
Message-ID: <CA+55aFzt1LN77WgFbdEak0f-JssQH64pSL=1zYAfB7=B8pxwvQ@mail.gmail.com>
Subject: Re: security: lockless stat() issues
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 1:15 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Just a couple of days ago you'd been complaining about filesystems exposure
> to rcuwalk details and now you propose to increase the contact surface
> by one more method?  OK...\

.. anything for a really critical path.

> For one thing, that will definitely require lazy freeing of struct
> super_block itself.  At the very least, you want ->i_sb->s_dev, even
> on default pathway.  Another thing is that API is wrong for that
> kind of stuff - we pass vfsmount/dentry pair and we end up looking
> at the inode guts.  Fine, but in RCU case you must cope with the
> possibility of dentry->d_inode going NULL under you.  Which isn't
> all that terrible, but we need to slap ACCESS_ONCE() into each method
> instance (all 34 of them).  IOW, it's worse than just "oh, we need to
> add a flag"; we'll need to pass the sodding inode separately, with
> dire warnings not to use dentry->d_inode.

That would get ugly.

However, I don't think we actually really need to do that.  We had a
similar situation with d_revalidate() passing inode pointers etc
totally unnecessarily. Yes, the filesystem needs to use ACCESS_ONCE()
and care about NULL, but it doesn't need anything more than that. And
we really do have that already.

And we already have dentry->d_sb - which is supposed to be valid.
Again, we already use it under RCU for d_revalidate() and for name
hashing. So the super-block had better already be ok with RCU.

            Linus
