Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaHWOSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:18:25 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:59158 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaHWOSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:18:24 -0400
Date: Sat, 23 Aug 2014 18:18:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-ID: <20140823141820.GG25918@moon>
References: <20140822192241.GA26512@redhat.com>
 <20140822201550.GA25918@moon>
 <20140823115302.GA27587@redhat.com>
 <20140823122214.GF25918@moon>
 <20140823131412.GA31685@redhat.com>
 <20140823133001.GA966@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823133001.GA966@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 03:30:01PM +0200, Oleg Nesterov wrote:
> forgot to mention,
> 
> On 08/23, Oleg Nesterov wrote:
> >
> > On 08/23, Cyrill Gorcunov wrote:
> >
> > > Looks like I need
> > > to use cred_guard_mutex instead of task_lock here, no?
> >
> > Please don't. First of all, it can't help because proc_pid_auxv() doesn't hold
> > this lock. It does mm_access() which drops this lock after return. And to remind,
> > we are going to remove mm_access/lock_trace from sys_read() paths in proc.
> 
> Besides, it can't help anyway. cred_guard_mutex is per-process (not per-thread),
> suppose that a vfork()'ed child does prctl() while another thread reads the
> parent's /proc/pid/auxv.

Then either I need to use some other lock (not sure which one) either leave it
completely unlocked mentionin in the man page such lockless behaviour. Thoughts?

> Cyrill, I am sorry, but I am starting to think that this patch should be
> dropped and replaced by another version. Or do you think it would be better
> to send the fixes on top?

It's not a problem to drop this particular patch (together with all fixes on
top) one and replace it with new version (this looks like a better idea than
drowning lkml with series of small patches). I rather need to understand what
exactly should be done in new version. So from your previous email

 | > Stricktly speaking yes, but don't forget we might need to update
 | > exe::file as well which requires lock to be taken.
 |
 | For reading? I see prctl_set_mm_exe_file_locked() in this patch, probably
 | this function was added by another patch. But, if this function calls
 | set_mm_exe_file() (I guess it does?) then down_read() is not enough?
 | set_mm_exe_file() can race with itself.

yes, for reading, look in set_mm_exe_file we lookup for vma which should
be not present when we change the link, and yes, because of read-only lock
this call can race but only one caller success there because we allow
to change exe link only once.

 | But for what? Ignoring the (I think buggy) check in do_shmat() ->start_stack
 | is simply unused, we only report it via /proc/. The same for, say, mm->start_code.

that't the good question if this check in do_shmat is buggy or not, why do
you think it's a bug there?

Oleg, letme summarize all the concerns maybe there would be a way to handle
them gracefully

1) How code flows for now (with all fixes on top of current Andrew's queued patches)

   - obtain struct prctl_mm_map from userspace
   - copy saved_auxv from userspace
   - down-read mmap_sem
   - validate all the data passed from userspace
     - we need a reference to stack-vma for RLIMIT_STACK check (this is doable,
       as you said, but until we drop the RLIMIT_STACK from do_shmat I would
       prefer it to be here)
     - we need to be sure that start_brk, brk, arg_start, arg_end, env_start, env_end
       really point to existing VMAs, strictly speaking the probgram can unmap
       all own VMAs except executable one and continue running without problem
       but this is not that practical I think and at first iteration I prefer
       more severe tests here on VMAs
   - setup new mm::exe_file (we need to be sure the old exe_file is unmapped
     so mmap_sem read-lock is needed)
   - update mm::saved_auxv with new values
   - finally setup new members to struct mm_struct
   - up-read mmap_sem

2) The qustion is do we really need that read-lock would be taken for all this
   time? And my answer is yes because of how I implement the checks for start_brk
   and etc.

Oleg, check please if I undersnad you correctly, you propose

 - drop off mmap_sem completely
 - don't verify for RLIMIT_STACK
 - drop off task_lock when updating mm::saved_auxv but still invent
   how to prevent update/read race

right?
