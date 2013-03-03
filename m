Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab3CCWWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 17:22:44 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36805 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3CCWWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:22:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Raphael S Carvalho <raphael.scarv@gmail.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, linux-kernel@vger.kernel.org
References: <CACz=WecbvVK32qNPoxnufTeUKG3=_mSog+QwaTWXWjVMXnzi0g@mail.gmail.com>
Date: Sun, 03 Mar 2013 14:22:36 -0800
In-Reply-To: <CACz=WecbvVK32qNPoxnufTeUKG3=_mSog+QwaTWXWjVMXnzi0g@mail.gmail.com>
	(Raphael S. Carvalho's message of "Sun, 3 Mar 2013 19:00:49 -0300")
Message-ID: <87obf0qg2b.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX19eee5KHpmBBZtSqYORtdgCB+INx03uu+k=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Raphael S Carvalho <raphael.scarv@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: About namespaces and unshare() syscall.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raphael S Carvalho <raphael.scarv@gmail.com> writes:

> Hi Eric W. Biederman and Serge Hallyn,
>
> I'm a newcomer to Linux kernel Development, and I really like the way
> Linux manages namespaces.
> By the way, I'm studying how copy_process() deals with it. I mean,
> sharing namespaces by default and
> duplicating namespaces on demand. 
> I would appreciate if you can give me tips about where to get started
> (Which areas are needing either help or improvement). 

Public mailing lists are usually good forums for discussion.

> Regarding to unshare syscall, I really care about how the following
> fragment of code will work in the future:
> (kernel/fork.c) static int check_unshare_flags(unsigned long
> unshare_flags):
> ...
> 1735        if (unshare_flags & (CLONE_THREAD | CLONE_SIGHAND |
> CLONE_VM)) {
> 1736                /* FIXME: get_task_mm() increments ->mm_users */
> 1737                if (atomic_read(&current->mm->mm_users) > 1)
> 1738                        return -EINVAL;
> 1739        }
>
> For example, suppose CLONE_VM was added to Unshare syscall, and so you
> created an application which relies on this new feature (Unshare VM).
> So I found your application in the Internet, but I'm running a kernel
> which still has the above checking.
>
> It won't work properly! why?
> Taking a careful look at it, I realized that if one of those flags
> were passed to the unshare syscall and the current process is sharing
> its VM among other processes, the syscall would always return an
> invalid error.
>

Which is exactly correct behavior for threaded applications.
Essentially unshare(CLONE_VM) means make me not a thread.  If
current->mm->mm_users == 1 there is nothing to do.  Otherwise something
has to happen.  And if there is no CLONE_VM support in the kernel 
nothing can happen.

> Conclusion: Your application (relying on Unshare CLONE_VM feature)
> wouldn't work on previous kernel versions since the old
> check_unshare_flags() was programmed so that CLONE_VM (with current
> process sharing its VM) is implicitly an invalid operation. Thus,
> lacking backward compatibility.

Wrong.  You get a nice error telling you that CLONE_VM doesn't work for
threaded applications on the kernel that you are running.

> I also was reading why CLONE_VM was removed from Unshare syscall, it
> seems a core dump could be processing at the same time, so bad things
> might happen. However, it seems this feature will only be implemented
> when really needed.

Which is like most of the kernel.  If someone cares enough to implement
things properly something is implemented.  If no one cares enough the
feature is never implemented, never merged, or never used and removed
when someone notice no one really cares.

Eric
