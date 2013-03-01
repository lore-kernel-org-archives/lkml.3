Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3CAIui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:50:38 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51902 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3CAIuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:50:37 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <87txowa2cm.fsf@xmission.com>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
 <87txowa2cm.fsf@xmission.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 1 Mar 2013 09:50:16 +0100
Message-ID: <CAKgNAkjxrbcpONCU4UdD0-cjXwbHr+YwkOR0H_aXp3CGB283Uw@mail.gmail.com>
Subject: Re: For review: pid_namespaces(7) man page
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Thu, Feb 28, 2013 at 4:24 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

[...]

>> ==========
>> PID_NAMESPACES(7)      Linux Programmer's Manual     PID_NAMESPACES(7)
>>
>> NAME
>>        pid_namespaces - overview of Linux PID namespaces
>>
>> DESCRIPTION
[...]

>>    The namespace init process
>>        The first process created in a new namespace (i.e., the process
>>        created using clone(2) with the CLONE_NEWPID flag, or the first
>>        child created by a process after a call to unshare(2) using the
>>        CLONE_NEWPID flag) has the PID 1, and is the "init" process for
>>        the namespace (see init(1)).  Children that are orphaned within
>>        the namespace will be reparented to this  process  rather  than
>>        init(1).
>>
>>        If the "init" process of a PID namespace terminates, the kernel
>>        terminates all of the processes in the namespace via a  SIGKILL
>>        signal.   This  behavior  reflects  the  fact  that  the "init"
>>        process is essential for the correct operation of a PID  names‐
>>        pace.   In this case, a subsequent fork(2) into this PID names‐
>>        pace (e.g., from a process that has done a  setns(2)  into  the
>>        namespace    using    an    open    file   descriptor   for   a
>>        /proc/[pid]/ns/pid file corresponding to a process that was  in
>>        the  namespace) will fail with the error ENOMEM; it is not pos‐
>>        sible to create a new processes in a PID namespace whose "init"
>>        process has terminated.
>
> It may be useful to mention unshare in the case of fork(2) failing just
> because that is such an easy mistake to make.
>
> unshare(CLONE_NEWPID);
> pid = fork();
> waitpid(pid,...);
> fork() -> ENOMEM

I'm lost. Why does that sequence fail? The child of fork() becomes PID
1 in the new PID namespace.

>>        Only  signals  for  which  the "init" process has established a
>>        signal handler can be sent to the "init" process by other  mem‐
>>        bers  of  the  PID namespace.  This restriction applies even to
>>        privileged processes, and prevents other  members  of  the  PID
>>        namespace from accidentally killing the "init" process.
>>
>>        Likewise, a process in an ancestor namespace can—subject to the
>>        usual permission checks described in  kill(2)—send  signals  to
>>        the  "init" process of a child PID namespace only if the "init"
>>        process has established a handler for that signal.  (Within the
>>        handler,  the  siginfo_t si_pid field described in sigaction(2)
>>        will be zero.)  SIGKILL or SIGSTOP are  treated  exceptionally:
>>        these signals are forcibly delivered when sent from an ancestor
>>        PID namespace.  Neither of these signals can be caught  by  the
>>        "init" process, and so will result in the usual actions associ‐
>>        ated with those signals (respectively, terminating and stopping
>>        the process).
>>
>>    Nesting PID namespaces
>>        PID  namespaces can be nested: each PID namespace has a parent,
>>        except for the initial ("root") PID namespace.  The parent of a
>>        PID  namespace is the PID namespace of the process that created
>>        the namespace using clone(2)  or  unshare(2).   PID  namespaces
>>        thus  form a tree, with all namespaces ultimately tracing their
>>        ancestry to the root namespace.
>>
>>        A process is visible to other processes in its  PID  namespace,
>>        and  to  the  processes  in  each direct ancestor PID namespace
>>        going back to the root PID namespace.  In this context,  "visi‐
>>        ble"  means that one process can be the target of operations by
>>        another process using system calls that specify a  process  ID.
>>        Conversely,  the  processes  in a child PID namespace can't see
>>        processes in the parent and further removed ancestor namespace.
>>        More  succinctly:  a  process  can see (e.g., send signals with
>>        kill(2), set nice values with setpriority(2), etc.)  only  pro‐
>>        cesses contained in its own PID namespace and in descendants of
>>        that namespace.
>>
>>        A process has one process ID in each of the layers of  the  PID
>>        namespace  hierarchy  in  which  is  visible,  and walking back
>>        though each direct ancestor namespace through to the  root  PID
>>        namespace.   System  calls  that  operate on process IDs always
>>        operate using the process ID that is visible in the PID  names‐
>>        pace of the caller.  A call to getpid(2) always returns the PID
>>        associated with the namespace in which the process was created.
>>
>>        Some processes in a PID namespace may  have  parents  that  are
>>        outside  of the namespace.  For example, the parent of the ini‐
>>        tial process in the namespace (i.e., the init(1)  process  with
>>        PID  1)  is  necessarily  in  another namespace.  Likewise, the
>>        direct children of a process that uses setns(2)  to  cause  its
>>        children  to join a PID namespace are in a different PID names‐
>>        pace from the caller of setns(2).  Calls to getppid(2) for such
>>        processes return 0.
>>
>>    setns(2) and unshare(2) semantics
>>        Calls  to setns(2) that specify a PID namespace file descriptor
>>        and calls to unshare(2) with the CLONE_NEWPID flag cause  chil‐
>>        dren  subsequently created by the caller to be placed in a dif‐
>>        ferent PID namespace from the caller.  These calls do not, how‐
>>        ever,  change the PID namespace of the calling process, because
>>        doing so would change the caller's idea  of  its  own  PID  (as
>>        reported  by getpid()), which would break many applications and
>>        libraries.
>>
>>        To put things another way: a process's PID namespace membership
>>        is determined when the process is created and cannot be changed
>>        thereafter.  Among other things, this means that  the  parental
>>        relationship between processes mirrors the parental between PID
>>        namespaces: the parent of a  process  is  either  in  the  same
>>        namespace or resides in the immediate parent PID namespace.
>
> This is mostly true.  With setns it is possible to have a parent
> in a pid namespace several steps up the pid namespace hierarchy.
>
>>        Every  thread  in  a process must be in the same PID namespace.
>>        For this reason, the two following call sequences will fail:
>>
>>            unshare(CLONE_NEWPID);
>>            clone(..., CLONE_VM, ...);    /* Fails */
>>
>>            setns(fd, CLONE_NEWPID);
>>            clone(..., CLONE_VM, ...);    /* Fails */
>>
>>        Because the above unshare(2) and setns(2) calls only change the
>>        PID  namespace  for created children, the clone(2) calls neces‐
>>        sarily put the new thread in a different PID namespace from the
>>        calling thread.
>
> I don't know if it is interesting but these sequences also fail.  But I
> suppose that is obvious?  Or documented at least Documented in the clone
> manpage and unshare manpages.
>
>             clone(..., CLONE_VM, ...);
>             unshare(CLONE_NEWPID);       /* Fails */
>
>             clone(..., CLONE_VM, ...);
>             setns(fd, CLONE_NEWPID);     /* Fails */


I added to this page.

>>    Miscellaneous
>>        After  creating a new PID namespace, it is useful for the child
>>        to change its root directory and mount a new procfs instance at
>>        /proc  so  that  tools such as ps(1) work correctly.  (If a new
>>        mount  namespace  is  simultaneously   created   by   including
>>        CLONE_NEWNS  in  the flags argument of clone(2) or unshare(2)),
>>        then it isn't necessary to change the  root  directory:  a  new
>>        procfs instance can be mounted directly over /proc.)
>
> Should it be documented somewhere that /proc when mounted from a pid
> namespace will use the pids of that pid namespace and /proc will only
> show process for visible in the mounting pid namespace, even if that
> mount of proc is accessed by processes in other pid namespaces?
>
> You sort of say it here by saying it is useful to mount a new copy of
> /proc, which it is.  I just don't see you coming out straight and saying
> why it is.  It just seems to be implied.

You're right. I should be more explicit. I will add some text detailing this.

[...]

Thanks for the comments, Eric!

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
