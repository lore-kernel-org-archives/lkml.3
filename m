Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbbATXEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:04:06 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40691 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbbATXED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:04:03 -0500
Date: Tue, 20 Jan 2015 15:03:52 -0800
From: josh@joshtriplett.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Fam Zheng <famz@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC 0/6] epoll: Introduce new syscall "epoll_mod_wait"
Message-ID: <20150120230352.GB14475@cloud>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
 <CALCETrU4TeG1ShVLkQgqQ6usFm8pg_t0D8K=Mi_UJGSfxUwXtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU4TeG1ShVLkQgqQ6usFm8pg_t0D8K=Mi_UJGSfxUwXtA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 02:40:32PM -0800, Andy Lutomirski wrote:
> On Tue, Jan 20, 2015 at 1:57 AM, Fam Zheng <famz@redhat.com> wrote:
> > This adds a new system call, epoll_mod_wait. It's described as below:
> >
> > NAME
> >        epoll_mod_wait - modify and wait for I/O events on an epoll file
> >                         descriptor
> >
> > SYNOPSIS
> >
> >        int epoll_mod_wait(int epfd, int flags,
> >                           int ncmds, struct epoll_mod_cmd *cmds,
> >                           struct epoll_wait_spec *spec);
> >
> > DESCRIPTION
> >
> >        The epoll_mod_wait() system call can be seen as an enhanced combination
> >        of several epoll_ctl(2) calls, which are followed by an epoll_pwait(2)
> >        call. It is superior in two cases:
> >
> >        1) When epoll_ctl(2) are followed by epoll_wait(2), using epoll_mod_wait
> >        will save context switches between user mode and kernel mode;
> >
> >        2) When you need higher precision than microsecond for wait timeout.
> >
> >        The epoll_ctl(2) operations are embedded into this call by with ncmds
> >        and cmds. The latter is an array of command structs:
> >
> >            struct epoll_mod_cmd {
> >
> >                   /* Reserved flags for future extension, must be 0 for now. */
> >                   int flags;
> >
> >                   /* The same as epoll_ctl() op parameter. */
> >                   int op;
> >
> >                   /* The same as epoll_ctl() fd parameter. */
> >                   int fd;
> >
> >                   /* The same as the "events" field in struct epoll_event. */
> >                   uint32_t events;
> >
> >                   /* The same as the "data" field in struct epoll_event. */
> >                   uint64_t data;
> >
> >                   /* Output field, will be set to the return code once this
> >                    * command is executed by kernel */
> >                   int error;
> >            };
> 
> I would add an extra u32 at the end so that the structure size will be
> a multiple of 8 bytes on all platforms.

*shrug*, but if you do so, enforce that it has a value of 0 or return
-EINVAL, just like a flags field.  Alternatively, move the last field
earlier and make flags a uint64_t.

- Josh Triplett
