Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaHWPfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 11:35:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbaHWPe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 11:34:59 -0400
Date: Sat, 23 Aug 2014 17:32:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
	added to -mm tree
Message-ID: <20140823153222.GA6559@redhat.com>
References: <20140822192241.GA26512@redhat.com> <20140822201550.GA25918@moon> <20140823115302.GA27587@redhat.com> <20140823122214.GF25918@moon> <20140823131412.GA31685@redhat.com> <20140823133001.GA966@redhat.com> <20140823141820.GG25918@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823141820.GG25918@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23, Cyrill Gorcunov wrote:
>
> On Sat, Aug 23, 2014 at 03:30:01PM +0200, Oleg Nesterov wrote:
> >
> > On 08/23, Oleg Nesterov wrote:
> > >
> > > On 08/23, Cyrill Gorcunov wrote:
> > >
> > > > Looks like I need
> > > > to use cred_guard_mutex instead of task_lock here, no?
> > >
> > > Please don't. First of all, it can't help because proc_pid_auxv() doesn't hold
> > > this lock. It does mm_access() which drops this lock after return. And to remind,
> > > we are going to remove mm_access/lock_trace from sys_read() paths in proc.
> >
> > Besides, it can't help anyway. cred_guard_mutex is per-process (not per-thread),
> > suppose that a vfork()'ed child does prctl() while another thread reads the
> > parent's /proc/pid/auxv.
>
> Then either I need to use some other lock (not sure which one) either leave it
> completely unlocked mentionin in the man page such lockless behaviour. Thoughts?

Personally I think "lockless" is the best choice (not sure man page should
know about this detail). I mean, I think that we do not care if proc_pid_auxv()
prints garbage if it races with ptctl().

Otherwise we have to use mmap_sem in proc_pid_auxv(), doesn't look nice.

>  | > Stricktly speaking yes, but don't forget we might need to update
>  | > exe::file as well which requires lock to be taken.
>  |
>  | For reading? I see prctl_set_mm_exe_file_locked() in this patch, probably
>  | this function was added by another patch. But, if this function calls
>  | set_mm_exe_file() (I guess it does?) then down_read() is not enough?
>  | set_mm_exe_file() can race with itself.
>
> yes, for reading, look in set_mm_exe_file we lookup for vma which should
> be not present when we change the link, and yes, because of read-only lock
> this call can race but only one caller success there because we allow
> to change exe link only once.

Ah, I forgot about MMF_EXE_FILE_CHANGED, thanks for correcting me.

(btw I think this check must die too, but this is off-topic and I was
 wrong anyway).

OK, but I still think down_read(mmap_sem) is not enough. get_mm_exe_file()
can do get_file() after prctl() paths do the final fput().

Or please look at tomoyo_get_exe(). Another thread can play with mm->exe_file
fput().

Plus I am a bit worrried about inode_permission() under mmap_sem... but
this is probably fine. Although you can never know which locks a creative
filesystem/security module can take ;) But probably this is fine.

>  | But for what? Ignoring the (I think buggy) check in do_shmat() ->start_stack
>  | is simply unused, we only report it via /proc/. The same for, say, mm->start_code.
>
> that't the good question if this check in do_shmat is buggy or not, why do
> you think it's a bug there?

Please see the patch I sent.

> Oleg, letme summarize all the concerns maybe there would be a way to handle
> them gracefully
>
> 1) How code flows for now (with all fixes on top of current Andrew's queued patches)
>
>    - obtain struct prctl_mm_map from userspace
>    - copy saved_auxv from userspace
>    - down-read mmap_sem
>    - validate all the data passed from userspace

I won't argue, but at least mmap_min/max_addr do not need mmap_sem.

>      - we need a reference to stack-vma for RLIMIT_STACK check (this is doable,
>        as you said, but until we drop the RLIMIT_STACK from do_shmat I would
>        prefer it to be here)

OK, I won't argue, but I think this is pointless and misleading.

And btw, where do you see RLIMIT_STACK in do_shmat() ?

>      - we need to be sure that start_brk, brk,

probably yes, simply because the kernel actually uses this members.

> arg_start, arg_end, env_start, env_end
>        really point to existing VMAs, strictly speaking the probgram can unmap
>        all own VMAs except executable one and continue running without problem
>        but this is not that practical I think and at first iteration I prefer
>        more severe tests here on VMAs

But, again, for what? There are only used to report this info via /proc/.

>    - setup new mm::exe_file (we need to be sure the old exe_file is unmapped
>      so mmap_sem read-lock is needed)

See above.

> Oleg, check please if I undersnad you correctly, you propose
>
>  - drop off mmap_sem completely

No, no, I didn't, we obviously can't do this.

>  - don't verify for RLIMIT_STACK

Yes, and more "don't verify". But again, I won't really argue. Just in my
opinion almost all these checks looks misleading, confusing, and unnecessary.

Please think about those who will try to understand this code. A little
comment like "this is not needed but we all are paranoid in openvz" could
make it a bit more understandable ;)

>  - drop off task_lock when updating mm::saved_auxv but still invent
>    how to prevent update/read race

Personally I think we can simply ignore this race.

But let me repeat, I won't argue with any approach as long as I think
it is fine correctness wise.

Oleg.

