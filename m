Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab3CAFH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:07:59 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37973 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab3CAFH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:07:57 -0500
Date: Thu, 28 Feb 2013 22:01:44 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: For review: pid_namespaces(7) man page
To: mtk.manpages@gmail.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
In-Reply-To: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
	(from mtk.manpages@gmail.com on Thu Feb 28 05:24:07 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1362110504.15531.4@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 05:24:07 AM, Michael Kerrisk (man-pages) wrote:
> Eric et al,
> 
> Eventually, there will be more namespace man pages, but let us start
> now with one for PID namespaces. The attached page aims to provide a
> fairly complete overview of PID namespaces.

Onward!

> PID_NAMESPACES(7)      Linux Programmer's Manual     PID_NAMESPACES(7)
> 
> NAME
>        pid_namespaces - overview of Linux PID namespaces
> 
> DESCRIPTION
>        For an overview of namespaces, see namespaces(7).
> 
>        PID  namespaces  isolate  the  process ID number space, meaning
>        that processes in different PID namespaces can  have  the  same
>        PID.

Um, perhaps "different processes"? Slightly repetitive, but trying to  
avoid the potential misreading that "a processes can have the same PID  
in different namespaces". (A single process can't be a member of more  
than one namespace. This is not about selective visibility.)

> PID namespaces allow containers to migrate to a new host
>        while the processes inside  the  container  maintain  the  same
>        PIDs.

I thought suspend/resume a container was the simple case. Migration to  
a new host is built on top of that. (On resume in a new container on  
the same system, if other stuff is going on in the system so the  
available PIDs have shifted.)

>        Likewise, a process in an ancestor namespace can—subject to the
>        usual permission checks described in  kill(2)—send  signals  to
>        the  "init" process of a child PID namespace only if the "init"
>        process has established a handler for that signal.  (Within the
>        handler,  the  siginfo_t si_pid field described in sigaction(2)
>        will be zero.)  SIGKILL or SIGSTOP are  treated  exceptionally:
>        these signals are forcibly delivered when sent from an ancestor
>        PID namespace.  Neither of these signals can be caught  by  the
>        "init" process, and so will result in the usual actions associ‐
>        ated with those signals (respectively, terminating and stopping
>        the process).

If SIGKILL to init is propogated to all the children of init, is  
SIGSTOP also propogated to all the children? (I.E. will SIGSTOP to  
container's init suspend the whole container, and will SIGCONT resume  
the whole container? If the latter, will it only resume processes that  
weren't previously stopped? :)

>        To put things another way: a process's PID namespace membership
>        is determined when the process is created and cannot be changed
>        thereafter.  Among other things, this means that  the  parental
>        relationship between processes mirrors the parental between PID

mirrors the relationship

>        namespaces: the parent of a  process  is  either  in  the  same
>        namespace or resides in the immediate parent PID namespace.
> 
>        Every  thread  in  a process must be in the same PID namespace.
>        For this reason, the two following call sequences will fail:
> 
>            unshare(CLONE_NEWPID);
>            clone(..., CLONE_VM, ...);    /* Fails */
> 
>            setns(fd, CLONE_NEWPID);
>            clone(..., CLONE_VM, ...);    /* Fails */

They fail with -EUNDOCUMENTED

>        Because the above unshare(2) and setns(2) calls only change the
>        PID  namespace  for created children, the clone(2) calls neces‐
>        sarily put the new thread in a different PID namespace from the
>        calling thread.

Um, no they don't. They fail. That's the point. They _would_ put the  
new thread in a different PID namespace, which breaks the definition of  
threads.

How about:

The above unshare(2) and setns(2) calls change the PID namespace of
children created by subsequent clone(2) calls, which is incompatible
with CLONE_VM.

>    Miscellaneous
>        After  creating a new PID namespace, it is useful for the child
>        to change its root directory and mount a new procfs instance at
>        /proc  so  that  tools such as ps(1) work correctly.  (If a new
>        mount  namespace  is  simultaneously   created   by   including
>        CLONE_NEWNS  in  the flags argument of clone(2) or unshare(2)),
>        then it isn't necessary to change the  root  directory:  a  new
>        procfs instance can be mounted directly over /proc.)

Why is the (If) clause in parentheses? And unshare(2)) has a Bruce.
(I.E. unbalanced parens.).

>        Calling  readlink(2)  on the path /proc/self yields the process
>        ID of the caller in the  PID  namespace  of  the  procfs  mount
>        (i.e.,  the  PID  namespace  of  the  process  that mounted the
>        procfs).

This is per-filesystem rather than using the process's namespace  
because...?
(Where /proc/self points is already process-local data, so the races  
here can't be too horrible...)

>        When a process ID is passed over a  UNIX  domain  socket  to  a
>        process  in  a  different PID namespace (see the description of
>        SCM_CREDENTIALS in unix(7)), it is translated into  the  corre‐
>        sponding PID value in the receiving process's PID namespace.

Heh. :)

> CONFORMING TO
>        Namespaces are a Linux-specific feature.

And yet the glibc guys insist on #define GNU_GNU_GNU_ALL_HAIL_STALLMAN  
in order to access this Linux-specific feature which has nothing  
whatsoever to do with the FSF.

The unshare() call originally _didn't_ require this define, but they  
retroactively added the requirement in a version "upgrade" to match  
your man page. This made me sad. It also made me prototype it myself  
rather than expecting the header to provide it.

Rob
