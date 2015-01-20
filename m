Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbbATWk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:40:57 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:54630 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbATWkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:40:55 -0500
MIME-Version: 1.0
In-Reply-To: <1421747878-30744-1-git-send-email-famz@redhat.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 Jan 2015 14:40:32 -0800
Message-ID: <CALCETrU4TeG1ShVLkQgqQ6usFm8pg_t0D8K=Mi_UJGSfxUwXtA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/6] epoll: Introduce new syscall "epoll_mod_wait"
To: Fam Zheng <famz@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Miklos Szeredi <mszeredi@suse.cz>,
        David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 1:57 AM, Fam Zheng <famz@redhat.com> wrote:
> This adds a new system call, epoll_mod_wait. It's described as below:
>
> NAME
>        epoll_mod_wait - modify and wait for I/O events on an epoll file
>                         descriptor
>
> SYNOPSIS
>
>        int epoll_mod_wait(int epfd, int flags,
>                           int ncmds, struct epoll_mod_cmd *cmds,
>                           struct epoll_wait_spec *spec);
>
> DESCRIPTION
>
>        The epoll_mod_wait() system call can be seen as an enhanced combination
>        of several epoll_ctl(2) calls, which are followed by an epoll_pwait(2)
>        call. It is superior in two cases:
>
>        1) When epoll_ctl(2) are followed by epoll_wait(2), using epoll_mod_wait
>        will save context switches between user mode and kernel mode;
>
>        2) When you need higher precision than microsecond for wait timeout.
>
>        The epoll_ctl(2) operations are embedded into this call by with ncmds
>        and cmds. The latter is an array of command structs:
>
>            struct epoll_mod_cmd {
>
>                   /* Reserved flags for future extension, must be 0 for now. */
>                   int flags;
>
>                   /* The same as epoll_ctl() op parameter. */
>                   int op;
>
>                   /* The same as epoll_ctl() fd parameter. */
>                   int fd;
>
>                   /* The same as the "events" field in struct epoll_event. */
>                   uint32_t events;
>
>                   /* The same as the "data" field in struct epoll_event. */
>                   uint64_t data;
>
>                   /* Output field, will be set to the return code once this
>                    * command is executed by kernel */
>                   int error;
>            };

I would add an extra u32 at the end so that the structure size will be
a multiple of 8 bytes on all platforms.

>
>        There is no guartantee that all the commands are executed in order. Only
>        if all the commands are successfully executed (all the error fields are
>        set to 0), events are polled.

If this doesn't happen, what error is returned?

>            struct epoll_wait_spec {
>
>                   /* The same as "maxevents" in epoll_pwait() */
>                   int maxevents;
>
>                   /* The same as "events" in epoll_pwait() */
>                   struct epoll_event *events;
>
>                   /* Which clock to use for timeout */
>                   int clockid;
>
>                   /* Maximum time to wait if there is no event */
>                   struct timespec timeout;
>
>                   /* The same as "sigmask" in epoll_pwait() */
>                   sigset_t *sigmask;
>
>                   /* The same as "sigsetsize" in epoll_pwait() */
>                   size_t sigsetsize;
>            } EPOLL_PACKED;

I think the convention is to align the structure's fields manually
rather than declaring it to be packed.

>
> RETURN VALUE
>
>        When any error occurs, epoll_mod_wait() returns -1 and errno is set
>        appropriately. All the "error" fields in cmds are unchanged before they
>        are executed, and if any cmds are executed, the "error" fields are set
>        to a return code accordingly. See also epoll_ctl for more details of the
>        return code.

Does this mean that callers should initialize the error fields to an
impossible value first so they can tell which commands were executed?

>
>        When successful, epoll_mod_wait() returns the number of file
>        descriptors ready for the requested I/O, or zero if no file descriptor
>        became ready during the requested timeout milliseconds.
>
>        If spec is NULL, it returns 0 if all the commands are successful, and -1
>        if an error occured.
>
> ERRORS
>
>        These errors apply on either the return value of epoll_mod_wait or error
>        status for each command, respectively.

Please clarify which errors are returned overall and which are per-command.

Thanks,
Andy
