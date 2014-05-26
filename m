Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaEZRlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:41:08 -0400
Received: from numidia.opendz.org ([98.142.220.152]:49928 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaEZRlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:41:07 -0400
Date: Mon, 26 May 2014 18:41:00 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/9] procfs: add proc_read_from_buffer() and
 pid_entry_read() helpers
Message-ID: <20140526174100.GB6380@dztty>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
 <1401110850-3552-4-git-send-email-tixxdz@opendz.org>
 <CALCETrU+O+p_EYao1k6y0t6JnJ+sV97zAGkn=enuJPEzpcW_Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU+O+p_EYao1k6y0t6JnJ+sV97zAGkn=enuJPEzpcW_Wg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 10:01:20AM -0700, Andy Lutomirski wrote:
> On Mon, May 26, 2014 at 6:27 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > This patch is preparation, it adds a couple of helpers to read data and
> > to get the cached permission checks during that ->read().
> >
> > Currently INF entries share the same code, they do not implement
> > specific ->open(), only ->read() coupled with callback calls. Doing
> > permission checks during ->open() will not work and will only disturb
> > the INF entries that do not need permission checks. Yes not all the INF
> > entries need checks, the ones that need protections are listed below:
> > /proc/<pid>/wchan
> > /proc/<pid>/syscall
> > /proc/<pid>/{auxv,io}  (will be handled in next patches).
> >
> > So to have proper permission checks convert this INF entries to REG
> > entries and use their open() and read() handlers to implement these
> > checks. To achieve this we add the following helpers:
> >
> > * proc_read_from_buffer() a wrapper around simple_read_from_buffer(), it
> >   makes sure that count <= PROC_BLOCK_SIZE (3*1024)
> >
> > * pid_entry_read(): it will get a free page and pass it to the specific
> >   /proc/<pid>/$entry handler (callback). The handler is of the same
> >   types of the previous INF handlers, it will only receive an extra
> >   "permitted" argument that contains the cached permission check that
> >   was performed during ->open().
> >
> >   The handler is of type:
> >   typedef int (*proc_read_fn_t)(char *page,
> >                                struct task_struct *task, int permitted);
> 
> [...]
> 
> This strikes me as *way* too complicated.  Why not just change
> proc_info_file_operations to *always* cache may_ptrace on open?
Not all the INF entries need permission checks during open:
The one that need it:
/proc/<pid>/{wchan|syscall}  converted in this series.
/proc/<pid>/{auxv|io}  (will be converted in next series)

The ones that do not need it:
/proc/<pid>/{limite|cmdline|shedstat|oom_score|...}

There is no reason to do it for these entries, and if you do it you will
also have to passe the cached permission checks, so I don't think that
you want to modify all the INF handlers especially the ones that do not
need it to take an extra argument.
Then you will also modify this:
in file fs/proc/internal.h the:
union proc_op {
	...
	int (*proc_read)(struct task_struct *task, char *page);
	...
 }

And then you will follow in all other places and handlers... and modify
the definition of INF entries... It's much more complicated...


This is cleaner: we modify only the ones that need proper permission and
they will use a shared helper, which will call their appropriate handler!

Their handlers will just receive an extra int argument.

Ultimately the sensitive INF files need their appropraite ->open(), they
are sensitive they need good protection, and other non-sensitive ones
can still share the same code.


> FWIW, it's been awhile: was anything actually wrong with using f_cred,
> other than the fact that it would have required adjusting the LSM
> hooks?
Adjusting the LSM hooks was one of the reason, and it can't be done
easily... and this one seems better since we cache just an integer
and we avoid to do some extra work during ->read() which can be done
during ->open()

Here we have the full context to do the appropriate checks.

> Admittedly, I don't see anything fundamentally wrong with caching
> may_ptrace on open as long as revoke in in the cards eventually, but
> it's plausible that a good f_cred-based implementation would make
> revoke less necessary.
Perhaps, but from the last discussion every one seems to want a revoke
anyway, and for the f_cred you will also need to check it during
->read() which in this case the check is done during ->open(), simple
and much more optimized for read() calls.


With a nice revoke implementation, you can even remove the ptrace checks
during ->read() just keep the cached result check during ->open() and
recheck just an integer during ->read(). This means less checks during
->read()... revoke should handle what was left....


Thanks!

> --Andy

-- 
Djalal Harouni
http://opendz.org
