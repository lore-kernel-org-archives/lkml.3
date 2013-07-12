Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3GLFsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 01:48:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35650 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3GLFsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 01:48:19 -0400
Date: Fri, 12 Jul 2013 06:48:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] vfs.git part 2
Message-ID: <20130712054817.GY4165@ZenIV.linux.org.uk>
References: <20130703122918.GK4165@ZenIV.linux.org.uk>
 <CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 02:42:54PM -0700, Linus Torvalds wrote:
> On Wed, Jul 3, 2013 at 5:29 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >         Assorted f_pos race fixes, making do_splice_direct() safe to
> > call with i_mutex on parent, O_TMPFILE support, Jeff's locks.c series,
> > ->d_hash/->d_compare calling conventions changes from Linus, misc stuff
> > all over the place.  Please, pull from
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
> 
> Btw, the new O_TMPFILE support seems to have a fundamental interface
> problem: old kernels ignore that flag, and happily implement totally
> different semantics than the intended new ones.
> 
> So with a *new* kernel, if the filesystem doesn't support O_TMPFILE,
> you get an ENOTSUPP error, and you can fall back on whatever old
> tmpfile logic you had.
> 
> But with an *old* kernel, O_TMPFILE will just silently be ignored as
> an unrecognized flag, and things won't work. If you do
> 
>   fd = open("dirname", O_CREAT | O_TMPFILE | O_RDWR, 0666);
> 
> it may be that it ends up acting as a "create file at specified
> directory path" instead of what the user *meant* for it to do, which
> was "create unnamed temporary file in the specified directory".
> 
> This seems to make the feature actively dangerous. You can't just try
> to use it and have a fallback, because that "try to use it" phase may
> incorrectly succeed.
> 
> Yes, you can force things to not work on old systems by having a slash
> at the end of the directory name, but if you ever forget that, you'll
> end up with the above problem.
> 
> Am I missing something?

It's slightly less painful than that - if dirname exists, the old kernels
will fail; O_CREAT for existing directory means an error.  So in practice
you can use it safely.  I'm not too happy about that situation, but I
hadn't been able to come up with anything better, short of a new syscall
that would duplicate openat(2), but reject unknown values in flags argument
from the very beginning ;-/  Which is what we probably should've done with
openat(2) itself, but it's too late for that now...
