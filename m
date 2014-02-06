Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaBFAc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:32:57 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:35480 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaBFAc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:32:56 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
Date: Wed, 5 Feb 2014 16:32:55 -0800
X-Google-Sender-Auth: Rds-R7Vzo2fHLfKCfGI6rv83amU
Message-ID: <CA+55aFxpBkTn3LvSzxFj7ZoxuY=Rrg0OoAVuk5dK-ZLsO8kk4A@mail.gmail.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 2:28 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Comments? This was obviously brought on by my frustration with the
> currently nasty do_notify_resume() always returning to iret for the
> task_work case, and PeterZ's patch that fixed that, but made the asm
> mess even *worse*.

Actually, I should have taken a closer look.

Yes, do_notify_resume() is a real issue, and my stupid open/close
test-case showed that part of the profile.

But the "iretq" that dominates on the kernel build is actually the
page fault one.

I noticed this when I compared "-e cycles:pp" with "-e cycles:p". The
single-p version shows largely the same profile for the kernel, except
that instead of showing "iretq" as the big cost, it shows the first
instruction in "page_fault".

In fact, even when *not* zoomed into the kernel DSO, "page_fault"
actually takes 5% of CPU time according to pref report. That's really
quite impressive.

I suspect the Haswell architecture has made everything else cheaper,
and the exception overhead hasn't kept up. I'm wondering if there is
anything we could do to speed this up - like doing gang lookup in the
page cache and pre-populating the page tables opportunistically.

We're using an interrupt gate for the page fault handling, and I don't
think we can avoid that. For all I know, a trap gate might be slightly
faster (but likely not really noticeable - the microcode is surely
expensive, but the pipeline unwinding is probably the biggest cost of
the page fault), but we have the issue of interrupts causing page
faults for vmalloc pages.. And obviously we can't avoid the iretq for
the return path.

So as far as I can see, there's no sane way to make the page fault
itself cheaper. Looking at opportunistically prepopulating page tables
when it's cheap and easy might be the best we can do..

                 Linus
