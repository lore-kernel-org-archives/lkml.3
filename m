Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaLDBmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:42:53 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:45310 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaLDBmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:42:50 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1415403984.git.luto@amacapital.net>
References: <cover.1415403984.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Dec 2014 17:42:28 -0800
Message-ID: <CALCETrVLFtg=VqYTaBenD+U9uQJENTZx7Nd30LVsQg7HQ_ydrQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] x86_64,entry: Rearrange the syscall exit optimizations
To: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>
Cc: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding potentially interested people]

On Fri, Nov 7, 2014 at 3:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> The syscall exit asm is a big mess.  There's a really fast path, some
> kind of fast path code (with a hard-coded optimization for audit), and
> the really slow path.  The result is that it's very hard to work with
> this code.  There are some asm paths that are much slower than they
> should be (context tracking is a major offender), but no one really
> wants to add even more asm to speed them up.
>
> This series takes a different, unorthodox approach.  Rather than trying
> to avoid entering the very slow iret path, it adds a way back out of the
> iret path.  The result is a dramatic speedup for context tracking, user
> return notification, and similar code, as the cost of a few lines of
> tricky asm.  Nonetheless, it's barely a net addition of asm code,
> because we get to remove the fast path optimizations for audit and
> rescheduling.
>
> Thoughts?  If this works, it opens the door for a lot of further
> consolidation of the exit code.
>
> Note: patch 1 in this series has been floating around on the list
> for quite a while.  It's mandatory for this series to work, because
> the buglet that it fixes almost completely defeats the optimization
> that I'm introducing.

It turns out that sysret_audit may be rather buggy.  I think it leaves
edx and edi in a confused state, and it interacts badly with
SCHEDULE_USER if context tracking is on.  My preferred long-term
solution is to delete sysret_audit entirely, which this patch set
does.  Can you (x86 people and people who, for reasons that escape me,
enjoy reviewing this stuff) take a look?

This clearly isn't 3.18 material, and it may want to soak in -next
(can -tip do that?  I can do it myself, I suppose), but it might also
be a good idea to try to do this for 3.19 to get rid of sysret_audit.

For those who haven't followed all the recent threads: the asm that's
deleted in patch 3 currently has a nasty RCU + context tracking +
audit bug that has become much easier to trigger as a result of the
seccomp changes in 3.18.  This isn't directly a bug in the seccomp
changes -- it's just that the seccomp changes make it much easier to
cause the offending ask to be executed.

--Andy

>
> Andy Lutomirski (3):
>   x86_64,entry: Fix RCX for traced syscalls
>   x86_64,entry: Use sysret to return to userspace when possible
>   x86_64,entry: Remove the syscall exit audit and schedule optimizations
>
>  arch/x86/kernel/entry_64.S | 103 ++++++++++++++++++++++++---------------------
>  1 file changed, 55 insertions(+), 48 deletions(-)
>
> --
> 1.9.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
