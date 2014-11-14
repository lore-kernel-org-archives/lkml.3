Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964970AbaKNAuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:50:40 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62950 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964816AbaKNAuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:50:39 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrVJE25Txr5vRKAxHpeKx9p0VJBbat44w+X4gT8qX7a4bg@mail.gmail.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com> <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
 <CALCETrUpqSpcKFRM6a1zJWebEVZxNd-5pyBW4fU19+HgcBv+2Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292CB9A@ORSMSX114.amr.corp.intel.com>
 <CALCETrVx7hGZodWfAoU1oee1SW7XXSn3Lr8Vs9JTOUMNtLXY4A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292D57B@ORSMSX114.amr.corp.intel.com>
 <CALCETrVB9VQPqFb7GQyxmVEKYtPhppmZS8SewQmtre+3_su9FA@mail.gmail.com> <CALCETrVJE25Txr5vRKAxHpeKx9p0VJBbat44w+X4gT8qX7a4bg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Nov 2014 16:50:16 -0800
Message-ID: <CALCETrVYWAOzaHqet8gS5hafvQC9prrH05qgc+v5dxSL9AF8bg@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 3:13 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Nov 13, 2014 at 2:47 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Thu, Nov 13, 2014 at 2:33 PM, Luck, Tony <tony.luck@intel.com> wrote:
>>>> Are you sure that this works in an unmodified kernel
>>>
>>> Unmodified kernel has run tens of thousands of injection/consumption/recovery cycles.
>>>
>>> I did get a crash with the entry/exit traces you asked for.  Last 20000 lines of console log
>>> attached.  There are a couple of OOPs before things fall apart completely.  I haven't yet
>>> counted all the entry/exits from the last cycle to see if they match.
>>>
>>
>> That log was a good hint, and I am a fool.  I'll send a v3 once I test it.
>
> ...or not.  I confused myself there.  I thought I had a bug, but I was wrong.
>
> I'm stress-testing sleeping in an int3 handler that entered from user
> space, and I'm not seeing any problems, even with perf firing lots of
> NMIs.  I'm also passing the kprobes smoke test with my patch applied,
> and the stack switching code is correctly not switching stacks.
>
> Any chance you could try to trigger this this again with regs->sp,
> regs->ip, and regs->cs added to the cpu=%d regs=... message?  I feel
> like I'm missing something weird here.

Can you also try rebasing onto what will probably be v3?

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/tag/?id=paranoid-stack-v2.9

It adds debugging for inappropriate reschedules from the wrong stack.
Setting CONFIG_DEBUG_ATOMIC_SLEEP might also be a good idea.

It seems plausible to me that the failure mode is worst ==
MCE_AR_SEVERITY but regs->cs == 0 (i.e. in kernel).  This could blow
up in one of two ways:

1. current is the idle thread.  This causes the warning you saw.

2. current is a real user process, but that MCE was nested inside
another exception somehow or otherwise didn't switch stacks.  Now
we're on an IST stack and we schedule.  So far so good, but the next
thing that tries to use that IST stack cause lots of corruption.

It looks like if bug 1 is happening, then you might never notice it
without mce-stack.patch applied -- you'll set TIF_MCE_NOTIFY on the
idle thread, but the idle thread never returns to userspace, so the
mce notifier never has a chance to crash.

--Andy
