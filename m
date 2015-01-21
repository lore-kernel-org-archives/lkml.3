Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbbAUJH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:07:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbbAUJGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:06:48 -0500
Date: Wed, 21 Jan 2015 17:05:53 +0800
From: Fam Zheng <famz@redhat.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
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
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC 0/6] epoll: Introduce new syscall "epoll_mod_wait"
Message-ID: <20150121090553.GC23024@ad.nay.redhat.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
 <54BE4EA4.6080901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BE4EA4.6080901@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01/20 13:48, Michael Kerrisk (man-pages) wrote:
> Hello Fam Zheng,
> 
> I know this API has been through a number of iterations, and there were 
> discussions about the design that led to it becoming more complex.
> But, let us assume that someone has not seen those discussions,
> or forgotten them, or is too lazy to go hunting list archives.
> 
> Then: this patch series should somewhere have an explanation of
> why the API is what it is, ideally with links to previous relevant
> discussions. I see that you do part of that in
> 
>     [PATCH RFC 5/6] epoll: Add implementation for epoll_mod_wait
> 
> There are however no links to previous discussions in that mail (I guess
> http://thread.gmane.org/gmane.linux.kernel/1861430/focus=91591 is most
> relevant, nor is there any sort of change log in the commit message 
> that explains the evolution of the API. Having those would ease the 
> task of reviewers.
> 
> Coming back to THIS mail, this man page should also include an
> explanation of why the API is what it is. That would include much
> of the detail from the 5/6 patch, and probably more info besides.
> 
> Some specific points below.
> 
> On 01/20/2015 10:57 AM, Fam Zheng wrote:
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
> 
> s/microsecond/millisecond/

Yes, thanks for pointing out.

> >        if all the commands are successfully executed (all the error fields are
> >        set to 0), events are polled.
> 
> Does the operation execute all commands, or stop when it encounters the first 
> error? In other words, when looping over the returned 'error' fields, what
> is the termination condition for the user-space application?
> 
> (Yes, I know I can trivially inspect the patch 5/6 to answer this question, 
> but the man page should explicitly state this so that I don't have to 
> read the source, and also because it is only if you explicitly document 
> the intended behavior that I can tell whether the actual implementation 
> matches the intention.)


> 
> >        The last parameter "spec" is a pointer to struct epoll_wait_spec, which
> >        contains the information about how to poll the events. If it's NULL, this
> >        call will immediately return after running all the commands in cmds.
> > 
> >        The structure is defined as below:
> > 
> >            struct epoll_wait_spec {
> > 
> >                   /* The same as "maxevents" in epoll_pwait() */
> >                   int maxevents;
> > 
> >                   /* The same as "events" in epoll_pwait() */
> >                   struct epoll_event *events;
> > 
> >                   /* Which clock to use for timeout */
> >                   int clockid;
> 
> Which clocks can be specified here?
> CLOCK_MONOTONIC?
> CLOCK_REALTIME?
> CLOCK_PROCESS_CPUTIME_ID?
> clock_getcpuclockid()?
> others?

At the moment we can limit it to CLOCK_MONOTONIC and CLOCK_REALTIME, I'm not
sure any application care about others. It's not checked in this series, but
should be done in v2.

> 
> >                   /* Maximum time to wait if there is no event */
> >                   struct timespec timeout;
> 
> Is this timeout relative or absolute?

Relative. I'll document it. Absolute timeout can be added later with new flags.

> 
> >                   /* The same as "sigmask" in epoll_pwait() */
> >                   sigset_t *sigmask;
> 
> I just want to confirm here that 'sigmask' can be NULL, meaning
> that we degenerate to epoll_wait() functionality, right?

Yes. Will document explicitly.

> 
> >                   /* The same as "sigsetsize" in epoll_pwait() */
> >                   size_t sigsetsize;
> >            } EPOLL_PACKED;
> 
> What is the "EPOLL_PACKED" here for?

Copy paste error. :)

> 
> > RETURN VALUE
> > 
> >        When any error occurs, epoll_mod_wait() returns -1 and errno is set
> >        appropriately. All the "error" fields in cmds are unchanged before they
> >        are executed, and if any cmds are executed, the "error" fields are set
> >        to a return code accordingly. See also epoll_ctl for more details of the
> >        return code.
> > 
> >        When successful, epoll_mod_wait() returns the number of file
> >        descriptors ready for the requested I/O, or zero if no file descriptor
> >        became ready during the requested timeout milliseconds.
> 
> s/milliseconds//

OK.

> 
> > 
> >        If spec is NULL, it returns 0 if all the commands are successful, and -1
> >        if an error occured.
> 
> s/occured/occurred/

OK, thanks.

> 
> > ERRORS
> > 
> >        These errors apply on either the return value of epoll_mod_wait or error
> >        status for each command, respectively.
> >
> >        EBADF  epfd or fd is not a valid file descriptor.
> > 
> >        EFAULT The memory area pointed to by events is not accessible with write
> >               permissions.
> > 
> >        EINTR  The call was interrupted by a signal handler before either any of
> >               the requested events occurred or the timeout expired; see
> >               signal(7).
> > 
> >        EINVAL epfd is not an epoll file descriptor, or maxevents is less than
> >               or equal to zero, or fd is the same as epfd, or the requested
> >               operation op is not supported by this interface.
> 
> Add: Or 'flags' is nonzero. Or a 'cmds.flags' field is nonzero.

Yes.

> 
> >        EEXIST op was EPOLL_CTL_ADD, and the supplied file descriptor fd is
> >               already registered with this epoll instance.
> > 
> >        ENOENT op was EPOLL_CTL_MOD or EPOLL_CTL_DEL, and fd is not registered
> >               with this epoll instance.
> > 
> >        ENOMEM There was insufficient memory to handle the requested op control
> >               operation.
> > 
> >        ENOSPC The limit imposed by /proc/sys/fs/epoll/max_user_watches was
> >               encountered while trying to register (EPOLL_CTL_ADD) a new file
> >               descriptor on an epoll instance.  See epoll(7) for further
> >               details.
> > 
> >        EPERM  The target file fd does not support epoll.
> > 
> > CONFORMING TO
> > 
> >        epoll_mod_wait() is Linux-specific.
> > 
> > SEE ALSO
> > 
> >        epoll_create(2), epoll_ctl(2), epoll_wait(2), epoll_pwait(2), epoll(7)
> 
> Please add sigprocmask(2).

OK! Thanks for reviewing this.

Fam
