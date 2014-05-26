Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaEZSWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:22:04 -0400
Received: from numidia.opendz.org ([98.142.220.152]:45248 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaEZSWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:22:02 -0400
Date: Mon, 26 May 2014 19:21:54 +0100
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
Message-ID: <20140526182154.GA6887@dztty>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
 <1401110850-3552-4-git-send-email-tixxdz@opendz.org>
 <CALCETrU+O+p_EYao1k6y0t6JnJ+sV97zAGkn=enuJPEzpcW_Wg@mail.gmail.com>
 <20140526174100.GB6380@dztty>
 <CALCETrV12jeZagHBjFnEvJo9wu=sengNa0s2feK8Z-2mjqVWwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV12jeZagHBjFnEvJo9wu=sengNa0s2feK8Z-2mjqVWwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 10:59:10AM -0700, Andy Lutomirski wrote:
> On Mon, May 26, 2014 at 10:41 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > On Mon, May 26, 2014 at 10:01:20AM -0700, Andy Lutomirski wrote:
> >> On Mon, May 26, 2014 at 6:27 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >> > This patch is preparation, it adds a couple of helpers to read data and
> >> > to get the cached permission checks during that ->read().
> >> >
> >> > Currently INF entries share the same code, they do not implement
> >> > specific ->open(), only ->read() coupled with callback calls. Doing
> >> > permission checks during ->open() will not work and will only disturb
> >> > the INF entries that do not need permission checks. Yes not all the INF
> >> > entries need checks, the ones that need protections are listed below:
> >> > /proc/<pid>/wchan
> >> > /proc/<pid>/syscall
> >> > /proc/<pid>/{auxv,io}  (will be handled in next patches).
> >> >
> >> > So to have proper permission checks convert this INF entries to REG
> >> > entries and use their open() and read() handlers to implement these
> >> > checks. To achieve this we add the following helpers:
> >> >
> >> > * proc_read_from_buffer() a wrapper around simple_read_from_buffer(), it
> >> >   makes sure that count <= PROC_BLOCK_SIZE (3*1024)
> >> >
> >> > * pid_entry_read(): it will get a free page and pass it to the specific
> >> >   /proc/<pid>/$entry handler (callback). The handler is of the same
> >> >   types of the previous INF handlers, it will only receive an extra
> >> >   "permitted" argument that contains the cached permission check that
> >> >   was performed during ->open().
> >> >
> >> >   The handler is of type:
> >> >   typedef int (*proc_read_fn_t)(char *page,
> >> >                                struct task_struct *task, int permitted);
> >>
> >> [...]
> >>
> >> This strikes me as *way* too complicated.  Why not just change
> >> proc_info_file_operations to *always* cache may_ptrace on open?
> > Not all the INF entries need permission checks during open:
> > The one that need it:
> > /proc/<pid>/{wchan|syscall}  converted in this series.
> > /proc/<pid>/{auxv|io}  (will be converted in next series)
> >
> > The ones that do not need it:
> > /proc/<pid>/{limite|cmdline|shedstat|oom_score|...}
> >
> > There is no reason to do it for these entries, and if you do it you will
> > also have to passe the cached permission checks, so I don't think that
> > you want to modify all the INF handlers especially the ones that do not
> > need it to take an extra argument.
> 
> ...but you don't have to pass the checks, because nothing will care
> whether you passed them.
No one will use them, but what you suggest is passing a dummy value that
no one cares about!

You said in the first place that this is *way* too complicated, no IHMO
going and changing all the handlers to receive a dummy argument that no one
will use is more complicated. In this case you are just suggesting to
convert all the INF entries into REG ones. Andi take a look please!

The definition of INF can't get a 'struct file_operations', only the
REG, at the end what you suggest is change all the INF entries to REG
and do a ptrace check at open() that only a small subset of these
entries will use...

Try it and you will see how much code you will change.

While the current proposed change just introduce a new helper (new code)
and adds the cached permission argument!

> > Then you will also modify this:
> > in file fs/proc/internal.h the:
> > union proc_op {
> >         ...
> >         int (*proc_read)(struct task_struct *task, char *page);
> >         ...
> >  }
> >
> > And then you will follow in all other places and handlers... and modify
> > the definition of INF entries... It's much more complicated...
> >
> 
> But the final result will be much less messy and have less duplicated
> code.  Your patch seems like it duplicates a bunch of code and I
> suspect that Al Viro will dislike it if he reads it.
Hmm, as I've said if we do that we need to convert all the INF entries
to REG ones, and remove the INF definition since it will be useless, then
convert all the handlers... And I can't consider it duplicate code,
since one is to handle non-sensitive entries and the other to handle
sensitive ones, perhaps write a new function that will get the small
duplicate instructions.


For Al Viro oh thank you :-), hope that he reads the patches first, then
if he thinks that converting all the INF entries into REG ones, and
doing ptrace check during ->open for files that do not need it is the
best solution, well I'll have just to follow and update the patches :-D

Thank you Andi!


> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Djalal Harouni
http://opendz.org
