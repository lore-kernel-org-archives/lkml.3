Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3GKVm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 17:42:57 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:50920 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab3GKVmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 17:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130703122918.GK4165@ZenIV.linux.org.uk>
References: <20130703122918.GK4165@ZenIV.linux.org.uk>
Date: Thu, 11 Jul 2013 14:42:54 -0700
X-Google-Sender-Auth: pD8sqgiwg50yLNVYA2DbQtz5vVM
Message-ID: <CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com>
Subject: Re: [git pull] vfs.git part 2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 5:29 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>         Assorted f_pos race fixes, making do_splice_direct() safe to
> call with i_mutex on parent, O_TMPFILE support, Jeff's locks.c series,
> ->d_hash/->d_compare calling conventions changes from Linus, misc stuff
> all over the place.  Please, pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Btw, the new O_TMPFILE support seems to have a fundamental interface
problem: old kernels ignore that flag, and happily implement totally
different semantics than the intended new ones.

So with a *new* kernel, if the filesystem doesn't support O_TMPFILE,
you get an ENOTSUPP error, and you can fall back on whatever old
tmpfile logic you had.

But with an *old* kernel, O_TMPFILE will just silently be ignored as
an unrecognized flag, and things won't work. If you do

  fd = open("dirname", O_CREAT | O_TMPFILE | O_RDWR, 0666);

it may be that it ends up acting as a "create file at specified
directory path" instead of what the user *meant* for it to do, which
was "create unnamed temporary file in the specified directory".

This seems to make the feature actively dangerous. You can't just try
to use it and have a fallback, because that "try to use it" phase may
incorrectly succeed.

Yes, you can force things to not work on old systems by having a slash
at the end of the directory name, but if you ever forget that, you'll
end up with the above problem.

Am I missing something?

              Linus
