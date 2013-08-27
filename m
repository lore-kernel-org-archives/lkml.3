Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3H0U2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:28:51 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:59030 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab3H0U2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:28:48 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwtVH+MoG7Emt5V5wy2eDbYOBHBgOywRHFQ+Vm2XZn-Ag@mail.gmail.com>
References: <CA+55aFw20W9L8HV+VbTRNeQQM-_+aeUhvT9AAod5LGfb-7hE9g@mail.gmail.com>
 <7d1419dda1da70a8ad915f85b093a58b86bcaf3b.1377630856.git.luto@amacapital.net> <CA+55aFwtVH+MoG7Emt5V5wy2eDbYOBHBgOywRHFQ+Vm2XZn-Ag@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 27 Aug 2013 13:28:27 -0700
Message-ID: <CALCETrVerk6evSngbf1fiD=k6E557KgKNCBF4qYQSCXYrOx0ag@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: Add user_file_or_path_at and use it for truncate
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>,
        "security@kernel.org" <security@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 12:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Aug 27, 2013 at 12:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> This is an experiment to see if we can get nice semantics for all syscalls
>> that either follow symlinks or allow AT_EMPTY_PATH without jumping through
>> enormous hoops.  This converts truncate (although you can't tell using
>> truncate from coreutils, because it actually uses open + ftruncate).
>
> So this seems *way* too complex. I'd much rather see "nd->flags" get a
> LOOKUP_READONLY flag, for example, that gets set by
> proc_pid_follow_link() when it hits a read-only file descriptor (and
> gets cleared by other lookups).
>
> Wouldn't that be *much* more straightforward?

It would if it works.  It certainly would for truncate, setxattr, etc.

There are funny cases, though.  For example, execing an O_WRONLY fd
should probably fail, as should opening an O_WRONLY fd as O_RDWR.
O_APPEND is also funny.  flink will (I suspect) always want to be a
bit special.

There are also O_PATH fds, and I'm not sure what the semantics of
O_PATH fds are or should be when they refer to something other than a
directory.

The benefit of my approach is that it's really obvious that
truncate("/proc/self/fd/N") and ftruncate(N) do exactly the same
thing.  The downside is that the namei code is a bit gross and there
was more rearranging of ftruncate than I would have liked.  (I also
lost the benefit of fget_light, but I could fix that by passing a
struct fd around instead of a struct file *.)

--Andy
