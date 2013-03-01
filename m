Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114Ab3CAG6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:58:20 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41384 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAG6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:58:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Landley <rob@landley.net>
Cc: mtk.manpages@gmail.com, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
	<1362110504.15531.4@driftwood>
Date: Thu, 28 Feb 2013 22:58:11 -0800
In-Reply-To: <1362110504.15531.4@driftwood> (Rob Landley's message of "Thu, 28
	Feb 2013 22:01:44 -0600")
Message-ID: <878v677gjg.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX19jxnvsCIj8SF7Phx0SaIPkN8eu5UqkZIA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Rob Landley <rob@landley.net>
X-Spam-Relay-Country: 
Subject: Re: For review: pid_namespaces(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> On 02/28/2013 05:24:07 AM, Michael Kerrisk (man-pages) wrote:
>> Eric et al,
>> 
>> Eventually, there will be more namespace man pages, but let us start
>> now with one for PID namespaces. The attached page aims to provide a
>> fairly complete overview of PID namespaces.
>
> Onward!
>
>> PID_NAMESPACES(7)      Linux Programmer's Manual     PID_NAMESPACES(7)
>> 
>> NAME
>>        pid_namespaces - overview of Linux PID namespaces
>> 
>> DESCRIPTION
>>        For an overview of namespaces, see namespaces(7).
>> 
>>        PID  namespaces  isolate  the  process ID number space, meaning
>>        that processes in different PID namespaces can  have  the  same
>>        PID.
>
> Um, perhaps "different processes"? Slightly repetitive, but trying to  
> avoid the potential misreading that "a processes can have the same PID  
> in different namespaces". (A single process can't be a member of more  
> than one namespace. This is not about selective visibility.)

Well actually a process is visible and arguably a member of all parent
pid namespaces, and a process certainly had a pid value in each pid
namespace up to the root of the pid namespace tree.

>> PID namespaces allow containers to migrate to a new host
>>        while the processes inside  the  container  maintain  the  same
>>        PIDs.
>
> I thought suspend/resume a container was the simple case. Migration to  
> a new host is built on top of that. (On resume in a new container on  
> the same system, if other stuff is going on in the system so the  
> available PIDs have shifted.)

I don't know if there is a difference at the implementation level.

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
>
> If SIGKILL to init is propogated to all the children of init, is  
> SIGSTOP also propogated to all the children? (I.E. will SIGSTOP to  
> container's init suspend the whole container, and will SIGCONT resume  
> the whole container? If the latter, will it only resume processes that  
> weren't previously stopped? :)

No.  SIGSTOP stops sent to init stops just init.

It isn't SIGKILL that is propogated it is the exiting of init that is
propogated by way of SIGKILL.  If your init process calls _exit() or
hits a SIGSEGV and dies all of the other processes in the pid namespace
will be sent a SIGKILL and be forced down.

This is similar to a the system panic if the global init exits.

>>        To put things another way: a process's PID namespace membership
>>        is determined when the process is created and cannot be changed
>>        thereafter.  Among other things, this means that  the  parental
>>        relationship between processes mirrors the parental between PID
>
> mirrors the relationship
>
>>        namespaces: the parent of a  process  is  either  in  the  same
>>        namespace or resides in the immediate parent PID namespace.
>> 
>>        Every  thread  in  a process must be in the same PID namespace.
>>        For this reason, the two following call sequences will fail:
>> 
>>            unshare(CLONE_NEWPID);
>>            clone(..., CLONE_VM, ...);    /* Fails */
>> 
>>            setns(fd, CLONE_NEWPID);
>>            clone(..., CLONE_VM, ...);    /* Fails */
>
> They fail with -EUNDOCUMENTED
Make that -EINVAL.

>>        Because the above unshare(2) and setns(2) calls only change the
>>        PID  namespace  for created children, the clone(2) calls neces‐
>>        sarily put the new thread in a different PID namespace from the
>>        calling thread.
>
> Um, no they don't. They fail. That's the point. They _would_ put the  
> new thread in a different PID namespace, which breaks the definition of  
> threads.
>
> How about:
>
> The above unshare(2) and setns(2) calls change the PID namespace of
> children created by subsequent clone(2) calls, which is incompatible
> with CLONE_VM.
>
>>    Miscellaneous
>>        After  creating a new PID namespace, it is useful for the child
>>        to change its root directory and mount a new procfs instance at
>>        /proc  so  that  tools such as ps(1) work correctly.  (If a new
>>        mount  namespace  is  simultaneously   created   by   including
>>        CLONE_NEWNS  in  the flags argument of clone(2) or unshare(2)),
>>        then it isn't necessary to change the  root  directory:  a  new
>>        procfs instance can be mounted directly over /proc.)
>
> Why is the (If) clause in parentheses? And unshare(2)) has a Bruce.
> (I.E. unbalanced parens.).
>
>>        Calling  readlink(2)  on the path /proc/self yields the process
>>        ID of the caller in the  PID  namespace  of  the  procfs  mount
>>        (i.e.,  the  PID  namespace  of  the  process  that mounted the
>>        procfs).
>
> This is per-filesystem rather than using the process's namespace  
> because...? 

The entire proc filesystem mount is in the pid namespace of the mounting
process.  Every pid that proc reports.  /proc/self is not a special
case, but /proc/self can be interesting if you want to find your pid
in that other guys pid namespace.

> (Where /proc/self points is already process-local data, so the races  
> here can't be too horrible...)

It actually is moderately important for /proc/self to do the right thing
here.  It means you can run against a /proc that is not for your pid
namespace and all of the /proc/self things that glibc and various other
programs and libraries due continue to work.

>>        When a process ID is passed over a  UNIX  domain  socket  to  a
>>        process  in  a  different PID namespace (see the description of
>>        SCM_CREDENTIALS in unix(7)), it is translated into  the  corre‐
>>        sponding PID value in the receiving process's PID namespace.
>
> Heh. :)
>
>> CONFORMING TO
>>        Namespaces are a Linux-specific feature.
>
> And yet the glibc guys insist on #define GNU_GNU_GNU_ALL_HAIL_STALLMAN  
> in order to access this Linux-specific feature which has nothing  
> whatsoever to do with the FSF.

I read it _GNU_SOURCE just implies a libc extensions specific to glibc.
Of course now that you mention it _GNU_SOURCE implies that we can
reasonably file a bug against glibc on the HURD or BSD for not
implementing this feature can't we?

> The unshare() call originally _didn't_ require this define, but they  
> retroactively added the requirement in a version "upgrade" to match  
> your man page. This made me sad. It also made me prototype it myself  
> rather than expecting the header to provide it.

Eric
