Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbbAEXrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:47:10 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:54751 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbbAEXrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:47:06 -0500
MIME-Version: 1.0
In-Reply-To: <549ABF87.8060905@elis.ugent.be>
References: <549ABF87.8060905@elis.ugent.be>
Date: Mon, 5 Jan 2015 15:47:05 -0800
X-Google-Sender-Auth: SRkLa-k7Pnl3SAlJT0B3IXL9poE
Message-ID: <CAGXu5jJWFKK1oJg0iyZtTKSSzXGyDD5B=iA3y7vvyayqhbOP5Q@mail.gmail.com>
Subject: Re: [PATCH RFC] Allow introspection to already attached ptracer in __ptrace_may_access
From: Kees Cook <keescook@chromium.org>
To: Stijn Volckaert <Stijn.Volckaert@elis.ugent.be>
Cc: Roland McGrath <roland@hack.frob.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        John Johansen <john.johansen@canonical.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 5:28 AM, Stijn Volckaert
<Stijn.Volckaert@elis.ugent.be> wrote:
> Hello,
>
> I ran across the following problem recently but I'm not entirely sure
> whether this should be fixed in ptrace or in Yama. I'm working on a
> ptrace-based monitor that forks off its own tracee during startup. The
> monitor attaches to the tracee and then lets the tracee perform an execve
> call. This is much like running a program in gdb.
>
> My monitor is multi-threaded and uses one monitor thread for every tracee
> thread so whenever the tracee forks/vforks/clones, I fire up a new monitor
> thread, detach the old monitor thread from the tracee thread and attach the
> new monitor thread to the tracee thread.
>
> I have recently stumbled upon several applications in which the main process
> A forks off process B and then immediately exits. Under normal circumstances
> the following would happen:
>
> Monitor[0]  ---   FORKS OFF   ---> Monitor[0]'
> Monitor[0]  --- PTRACE_ATTACH ---> Monitor[0]'
> Monitor[0]' ---    EXECVE     ---> Process A
>
> Process A   ---   FORKS OFF   ---> Process B
> Monitor[0]  --- PTRACE_DETACH ---> Process B
> Monitor[1]  --- PTRACE_ATTACH ---> Process B
>
> With Yama enabled (and the scope set to YAMA_SCOPE_RELATIONAL) however, a
> few interesting things can (and usually do) happen:
>
> 1) If Process A dies before Monitor[1] is attached to Process B, the attach
> will fail since from Yama's point of view, Process B is no longer a
> descendant of Monitor[1]. This problem is probably hard to fix
> but I've circumvented it by delaying the death of Process A until Process B
> is attached to Monitor[1].

Just to make sure I understand this better, "Monitor" is the initial
process, and [0] and [1] are separate threads within that process? I
would expect B to have Monitor as its parent after A died, but I must
be misunderstanding something.

Regardless, your "interesting thing 1" is certainly a side-effect of
YAMA_SCOPE_RELATIONAL trying to do its job.

> 2) More interestingly though, even if Process B does get attached to
> Monitor[1], as soon as Process A dies, all process_vm_readv and
> process_vm_writev calls on Process B start failing. Any other ptrace
> operations peformed on Process B do succeed.
>
> process_vm_readv|writev use __ptrace_may_access to check whether the
> operation is permitted, whereas other ptrace operations (with the exception
> of PTRACE_ATTACH) use ptrace_check_attach.

Right, process_vm_{read,write}v use PTRACE_MODE_ATTACH (which is what
Yama interposes via the LSM entry point in __ptrace_may_access).

> To fix this problem, __ptrace_may_access should be forced to return 0 if the
> calling process is already attached to the target process.
>
> The question now is whether or not it's the security module's responsibility
> to check whether a tracee relationship is already in place or if ptrace
> itself should do it. For the latter case, which seems more logical to me,
> you could use the patch below.
>
> What do you guys think?
>
> Regards,
> Stijn Volckaert
>
> --
>
> Signed-off-by: Stijn Volckaert <Stijn.Volckaert@elis.ugent.be>
>
> --- a/kernel/ptrace.c   2014-12-24 13:53:23.055346526 +0100
> +++ b/kernel/ptrace.c   2014-12-24 14:17:20.617824840 +0100
> @@ -232,6 +232,9 @@ static int __ptrace_may_access(struct ta
>         /* Don't let security modules deny introspection */
>         if (same_thread_group(task, current))
>                 return 0;
> +       /* Don't deny introspection to already attached ptracer */
> +       if (!ptrace_check_attach(task, true))
> +               return 0;
>         rcu_read_lock();
>         tcred = __task_cred(task);
>         if (uid_eq(cred->uid, tcred->euid) &&
>

I'm nervous to add this (or Oleg's suggestion) generally to
__ptrace_may_access, as it would mean other LSMs would stop seeing
access checks even when attached. It does seem silly to deny ptrace
checks when already attached, but it does change the behavior here.

If the other LSM folks don't see a problem here, then it should live
in the general case. Otherwise, I'm happy to add this check only in
Yama. The existing Yama scopes should ignore attach requests when
already attached.

-Kees

-- 
Kees Cook
Chrome OS Security
