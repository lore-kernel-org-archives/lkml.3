Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab3CGRbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:31:22 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:45967 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab3CGRbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:31:20 -0500
MIME-Version: 1.0
In-Reply-To: <20130307153052.GA18246@redhat.com>
References: <20130307021645.GA10173@redhat.com>
	<20130307153052.GA18246@redhat.com>
Date: Thu, 7 Mar 2013 09:30:56 -0800
X-Google-Sender-Auth: GRhQwFBCgN_WrPHdI6ubJb-SbGU
Message-ID: <CA+55aFyVZeDswi=M65ULQkGCvJq5vsASLqGCtufH3TcS--MC1Q@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode->i_op->follow_link);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 7:30 AM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Mar 06, 2013 at 09:16:45PM -0500, Dave Jones wrote:
>
>  >  kernel BUG at fs/namei.c:1441!

Ok, that's a seriously bad error case. although I still worry that
BUG_ON() is too bug of a hammer. If we hold any other locks, we're
basically screwed, and may end up not saving the error message to
/var/log/messages etc.

So I think we should change that BUG_ON() into a

        if (WARN_ON_ONCE(nd->inode != parent->d_inode))
                return -ESTALE;

or something. Not because the bug isn't serious, but because doing
BUG_ON() is likely worse from a debugging standpoint than not.

>  >   [<ffffffff811be75e>] path_lookupat+0x71e/0x740
>  >   [<ffffffff811be7b4>] filename_lookup+0x34/0xc0
>  >   [<ffffffff811be8f2>] do_path_lookup+0x32/0x40
>  >   [<ffffffff811beb7a>] kern_path+0x2a/0x50
>  >   [<ffffffff811d569d>] do_mount+0x8d/0xa00
>  >   [<ffffffff811d609e>] sys_mount+0x8e/0xe0
>  >   [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b

Hmm. Nothing looks all that odd in that trace. Do you have any idea
what the path was? This being trinity, I'm assuming you're doing some
kind of targeted testing. sysfs or proc, perhaps? Or some particular
concurrency test with random system calls/pathnames? Not that I see
how it could happen anyway, but maybe it could give some hint about
what triggered this.

> More VFS fun, this time on something in /proc.
>
> kernel BUG at fs/namei.c:693!
> Call Trace:
>  [<ffffffff8122475c>] proc_pid_follow_link+0x6c/0x70
>  [<ffffffff811be311>] path_lookupat+0x2d1/0x740
>  [<ffffffff811be7b4>] filename_lookup+0x34/0xc0
>  [<ffffffff811c15ae>] user_path_at_empty+0x8e/0x110
>  [<ffffffff811c1641>] user_path_at+0x11/0x20
>  [<ffffffff811b62f9>] vfs_fstatat+0x49/0xa0
>  [<ffffffff811b664a>] sys_newfstatat+0x1a/0x40
>  [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b

Hmm. Al, is that BUG_ON() even valid any more? Can a file descriptor
opened with F_PATH contain a symlink? So doing a proc lookup of such a
thing could point to something that has a follow_link, no?

Dave, are these BUG_ON's new with current git, or is it perhaps
because you've expanded trinity with new patterns to test random
arguments for?

                   Linus
