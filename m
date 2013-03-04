Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab3CDMrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:47:19 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48676 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab3CDMrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:47:17 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <87wqtr3zg5.fsf@xmission.com>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
 <1362110504.15531.4@driftwood> <CAKgNAkgVKnhRT1Lpq4a_UdBKB+tn6XmWSDF2QJXG0aSLtNH6dg@mail.gmail.com>
 <87wqtr3zg5.fsf@xmission.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 4 Mar 2013 13:46:57 +0100
Message-ID: <CAKgNAkjGD0FdQqpA+rYR=+Yc5uVPB8mE5JjCqy-5WS85cPsvng@mail.gmail.com>
Subject: Re: For review: pid_namespaces(7) man page
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rob Landley <rob@landley.net>, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 4:35 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>
>> Hi Rob,
>>
>> On Fri, Mar 1, 2013 at 5:01 AM, Rob Landley <rob@landley.net> wrote:
>>> On 02/28/2013 05:24:07 AM, Michael Kerrisk (man-pages) wrote:
>> [...]
>>
>>>> DESCRIPTION
>>>>        For an overview of namespaces, see namespaces(7).
>>>>
>>>>        PID  namespaces  isolate  the  process ID number space, meaning
>>>>        that processes in different PID namespaces can  have  the  same
>>>>        PID.
>>>
>>>
>>> Um, perhaps "different processes"? Slightly repetitive, but trying to avoid
>>> the potential misreading that "a processes can have the same PID in
>>> different namespaces". (A single process can't be a member of more than one
>>> namespace. This is not about selective visibility.)
>>
>> I'm not sure this clarifies things...
>>
>>>> PID namespaces allow containers to migrate to a new host
>>>>        while the processes inside  the  container  maintain  the  same
>>>>        PIDs.
>>>
>>>
>>> I thought suspend/resume a container was the simple case. Migration to a new
>>> host is built on top of that. (On resume in a new container on the same
>>> system, if other stuff is going on in the system so the available PIDs have
>>> shifted.)
>>
>> I'll add some words here on suspend/resume.
>>
>>>>        Likewise, a process in an ancestor namespace can—subject to the
>>>>        usual permission checks described in  kill(2)—send  signals  to
>>>>        the  "init" process of a child PID namespace only if the "init"
>>>>        process has established a handler for that signal.  (Within the
>>>>        handler,  the  siginfo_t si_pid field described in sigaction(2)
>>>>        will be zero.)  SIGKILL or SIGSTOP are  treated  exceptionally:
>>>>        these signals are forcibly delivered when sent from an ancestor
>>>>        PID namespace.  Neither of these signals can be caught  by  the
>>>>        "init" process, and so will result in the usual actions associ‐
>>>>        ated with those signals (respectively, terminating and stopping
>>>>        the process).
>>>
>>>
>>> If SIGKILL to init is propogated to all the children of init, is SIGSTOP
>>> also propogated to all the children? (I.E. will SIGSTOP to container's init
>>> suspend the whole container, and will SIGCONT resume the whole container? If
>>> the latter, will it only resume processes that weren't previously stopped?
>>> :)
>>
>> Covered by Eric.
>>
>>>>        To put things another way: a process's PID namespace membership
>>>>        is determined when the process is created and cannot be changed
>>>>        thereafter.  Among other things, this means that  the  parental
>>>>        relationship between processes mirrors the parental between PID
>>>
>>>
>>> mirrors the relationship
>>
>> Thanks.
>>
>>>>        namespaces: the parent of a  process  is  either  in  the  same
>>>>        namespace or resides in the immediate parent PID namespace.
>>>>
>>>>        Every  thread  in  a process must be in the same PID namespace.
>>>>        For this reason, the two following call sequences will fail:
>>>>
>>>>            unshare(CLONE_NEWPID);
>>>>            clone(..., CLONE_VM, ...);    /* Fails */
>>>>
>>>>            setns(fd, CLONE_NEWPID);
>>>>            clone(..., CLONE_VM, ...);    /* Fails */
>>>
>>>
>>> They fail with -EUNDOCUMENTED
>>
>> Added EINVAL, as per Eric's reply. (Eric does that error also apply
>> for the two new cases you added?).
>>
>>>>        Because the above unshare(2) and setns(2) calls only change the
>>>>        PID  namespace  for created children, the clone(2) calls neces‐
>>>>        sarily put the new thread in a different PID namespace from the
>>>>        calling thread.
>>>
>>>
>>> Um, no they don't. They fail. That's the point.
>>
>> (Good catch.)
>>
>>> They _would_ put the new
>>> thread in a different PID namespace, which breaks the definition of threads.
>>>
>>> How about:
>>>
>>> The above unshare(2) and setns(2) calls change the PID namespace of
>>> children created by subsequent clone(2) calls, which is incompatible
>>> with CLONE_VM.
>>
>> I decided on:
>>
>>        The  point  here is that unshare(2) and setns(2) change the PID
>>        namespace for created children but not for the calling process,
>>        while  clone(2) CLONE_VM specifies the creation of a new thread
>>        in the same process.
>
> Can we make that "for all new tasks created" instead of "created
> children"
>
> Othewise someone might expect CLONE_THREAD would work as you
> CLONE_THREAD creates a thread and not a child...

The term "task" is kernel-space talk that rarely appears in man pages,
so I am reluctant to use it.

How about this:

       The  point  here is that unshare(2) and setns(2) change the PID
       namespace for processes subsequently created by the caller, but
       not  for the calling process, while clone(2) CLONE_VM specifies
       the creation of a new thread in the same process.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
