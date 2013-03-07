Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3CGWu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:50:58 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:59731 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3CGWu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:50:56 -0500
MIME-Version: 1.0
In-Reply-To: <20130307221800.GA572@redhat.com>
References: <20130307021645.GA10173@redhat.com>
	<20130307153052.GA18246@redhat.com>
	<CA+55aFyVZeDswi=M65ULQkGCvJq5vsASLqGCtufH3TcS--MC1Q@mail.gmail.com>
	<20130307193501.GA2802@redhat.com>
	<CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
	<20130307221800.GA572@redhat.com>
Date: Thu, 7 Mar 2013 14:50:55 -0800
X-Google-Sender-Auth: S-GY4XiCe86sDHTadEMuchW6_SA
Message-ID: <CA+55aFwObv7--izbae5YdXX3AhoHfV0YwbSLQoonTf-=e4PzqQ@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode->i_op->follow_link);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 2:18 PM, Dave Jones <davej@redhat.com> wrote:
>
> Ok, that didn't enlightenment me so much..

Ooh, I'm good.

> [  304.559707] WARNING: at fs/namei.c:696 nd_jump_link+0x85/0xa0()
> [  304.692736]  [<ffffffff811c1795>] nd_jump_link+0x85/0xa0
> [  304.693541]  [<ffffffff81224aec>] proc_pid_follow_link+0x6c/0x70
> [  304.694445]  [<ffffffff811be661>] path_lookupat+0x2d1/0x740
> [  304.695270]  [<ffffffff811beb04>] filename_lookup+0x34/0xc0
> [  304.696112]  [<ffffffff811c193e>] user_path_at_empty+0x8e/0x110
> [  304.697007]  [<ffffffff811c19d1>] user_path_at+0x11/0x20
> [  304.697800]  [<ffffffff811d944f>] sys_setxattr+0x3f/0xe0
> [  304.698609]  [<ffffffff816cdbc2>] system_call_fastpath+0x16/0x1b
> [  304.722423] ---[ end trace 469ba8f58f5994e6 ]---
> [  304.723132] old=fd new=1:9
>
> thoughts ?

Yes, I can reproduce this, and I know what's going on. I don't have a
patch, though, and I think it's in Al's court on what we should do.
Al?

Anyway, so the "old=fd" thing implies that it's one of the symlinks in
/proc/xyz/fd/, so that's something. It could have been the
cwd/exe/mmap ones. But that was kind of the expectation to begin with.

The "new=1:9" is the path that the file descriptor contained, and
since you're playing games with /proc, /sys and /dev, *and* since you
hit the "it shouldn't be a symlink" test, I'm *guessing* that it might
be something like

    /sys/dev/char/1:9

which is a symlink to ../../devices/virtual/mem/urandom/.

And here is how you reproduce this:

Do:

  int main(int argc, char **argv)
  {
    int fd = open(argv[1], O_PATH | O_NOFOLLOW);
    struct stat st;
    fstat(fd, &st);
    sleep(100);
  }

and then run

   ./a.out /sys/dev/char/1:9 &

which will look up that symlink using O_NOFOLLOW. Take note of the
<pid>, and then do

   ls -l /proc/<pid>/fd/3/

and you get the oops, because when it follows that pseudo-symlink for
fd3, it will hit that symlink we just looked up. And trigger the
BUG_ON() you see.

Al, I think the BUG_ON() is simply bogus. Should we just remove it? Or
is there some conceptual reason why we can't handle a symlink there?

              Linus
