Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab3BOUwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:52:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab3BOUwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:52:32 -0500
From: Paul Moore <pmoore@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, coreyb@linux.vnet.ibm.com,
        wad@chromium.org
Subject: Re: [PATCH] x86: remove the x32 syscall bitmask from syscall_get_nr()
Date: Fri, 15 Feb 2013 15:52:26 -0500
Message-ID: <2881752.183WHZTyfJ@sifl>
Organization: Red Hat
User-Agent: KMail/4.10 (Linux/3.7.3-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <511E8659.6030601@zytor.com>
References: <20130215172143.12549.10292.stgit@localhost> <511E8659.6030601@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 15, 2013 11:02:49 AM H. Peter Anvin wrote:
> On 02/15/2013 09:21 AM, Paul Moore wrote:
> > Commit fca460f95e928bae373daa8295877b6905bc62b8 simplified the x32
> > implementation by creating a syscall bitmask, equal to 0x40000000, that
> > could be applied to x32 syscalls such that the masked syscall number
> > would be the same as a x86_64 syscall.  While that patch was a nice
> > way to simplify the code, it went a bit too far by adding the mask to
> > syscall_get_nr(); returning the masked syscall numbers can cause
> > confusion with callers that expect syscall numbers matching the x32
> > ABI, e.g. unmasked syscall numbers.
> > 
> > This patch fixes this by simply removing the mask from syscall_get_nr()
> > while preserving the other changes from the original commit.  While
> > there are several syscall_get_nr() callers in the kernel, most simply
> > check that the syscall number is greater than zero, in this case this
> > patch will have no effect.  Of those remaining callers, they appear
> > to be few, seccomp and ftrace, and from my testing of seccomp without
> > this patch the original commit definitely breaks things; the seccomp
> > filter does not correctly filter the syscalls due to the difference in
> > syscall numbers in the BPF filter and the value from syscall_get_nr().
> > Applying this patch restores the seccomp BPF filter functionality on
> > x32.
> > 
> > I've tested this patch with the seccomp BPF filters as well as ftrace
> > and everything looks reasonable to me; needless to say general usage
> > seemed fine as well.
> 
> Hi... it isn't 100% clear from the description if you have audited *all*
> the callers?

I audited all of the syscall_get_nr() callers using the LXR at 
http://lxr.free-electrons.com with the 3.7 sources.  If you exclude all of the 
architecture dependent stuff that is non-x86 you arrive at the following list 
of callers:

* kernel/seccomp.c:seccomp_bpf_load()
This is where I noticed the problem, broken w/o the patch.

* lib/syscall.c:collect_syscall()/task_current_syscall()
The task_current_syscall() function is really only called by 
proc_pid_syscall() which displays the syscall number back to the user via a 
/proc entry, in which case this patch appears to correct a problem similar to 
what was seen with seccomp.

* kernel/trace/trace_syscalls.c:ftrace_syscall_enter()
* kernel/trace/trace_syscalls.c:ftrace_syscall_exit()
* kernel/trace/trace_syscalls.c:perf_syscall_enter()
* kernel/trace/trace_syscalls.c:perf_syscall_exit()
The ftrace/perf is the one user that I am least sure about, as noted above, I 
did some simple tests based on what I could find via Google but a quick review 
by someone who is more familiar with this code would be appreciated.  I'm most 
concerned about the syscall_metadata bits ...

* include/trace/events/syscall.h
Another, what I assume, is a ftrace user; I'm assuming the patch is reasonable 
based on my testing, but once again further review would be appreciated.

* arch/x86/kernel/ptrace.c:putreg32()
* arch/x86/kernel/signal.c:handle_signal()
* arch/x86/kernel/signal.c:do_signal()
Simple grater than zero checks.

-- 
paul moore
security and virtualization @ redhat

