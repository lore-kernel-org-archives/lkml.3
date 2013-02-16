Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3BPVzB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 16:55:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46985 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530Ab3BPVzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 16:55:01 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFy821kt0cz=nNB45e0K-hGUfairbTEgNP6E65jkA6bWaA@mail.gmail.com>
References: <20130213041629.GA28622@redhat.com> <alpine.LNX.2.00.1302122121170.15020@eggly.anvils> <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com> <20130215011503.GA11914@redhat.com> <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com> <20130215174435.GA2792@linux.vnet.ibm.com> <CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com> <CA+55aFwHtFeN97E-zW2QKQWH8vu=g29cxevvEnpEnHc8dx7oWA@mail.gmail.com> <CA+55aFyXo89LQ0mboxVYB5SJ08D8=Kv0=cqYHAd6-H7nmp=S-w@mail.gmail.com> <20130216192554.GB7035@linux.vnet.ibm.com> <CA+55aFy821kt0cz=nNB45e0K-hGUfairbTEgNP6E65jkA6bWaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 16 Feb 2013 13:53:22 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Message-ID: <e752ea3f-b236-4c34-9e8a-a5ff7df4f93c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syscall generation *should* make files with different names only, but I'll look.

Linus Torvalds <torvalds@linux-foundation.org> wrote:

>On Sat, Feb 16, 2013 at 11:25 AM, Paul E. McKenney
><paulmck@linux.vnet.ibm.com> wrote:
>>
>> Sorry for the delay in testing this, but there was a need to upgrade
>> my laptop, and bozo here figured "why not go to 64 bits while I am at
>> it?" -- and then proceeded to learn the hard way that it is necessary
>> to do "make mrproper" before doing a build in 64-bit mode.  :-/
>
>Hmm. Our object file dependency check includes checking that the
>compiler options are the same, but that's only true for normal C
>files. Some of the other rules do *not* test the full range of config
>options, so in general, if you change architecture etc models, you do
>indeed want to make sure that you do a "make distclean" (aka "make
>mrproper") or something like "git clean -dqfx".
>
>For a number of other files, we just depend on the normal make
>timestamp logic, which means that "if the object file is newer than
>the sources", we'll trust it. Which obviously doesn't work for cases
>where the object file may have been generated under totally different
>architecture rules..
>
>(That said, what kind of old environment did you do this in?
>stub32_sigaltstack was removed during the merge window, so I'm
>assuming you applied my patch on top of plain 3.7 or something?)
>
>> The kernel build system's way of telling you this at the moment is:
>>
>> arch/x86/built-in.o:(.rodata+0x4990): undefined reference to
>`stub32_sigaltstack'
>
>Adding Peter Anvin to the people, just in case he sees what's wrong
>with the system call stub generation that keeps excessively old object
>files around. If it's easy to fix, it might be worth trying to make it
>ok to switch from i386 to x86-64 and back in the same tree.
>
>Peter? Not a big deal, but if you see something obvious, let's just
>try to fix it, ok?
>
>> Anyway, with this patch, I see CPU stall warnings when running
>rcutorture
>> as shown below.  This is not a hard failure:
>
>Yeah, there's something wrong with the patch, I didn't bother trying
>to figure it out for now. It also causes a hard failure with lockdep
>(or lock proving/debugging, I'm not sure which one triggered it) - and
>it happens too early to even see anything on the screen.
>
>So I'd like to make that "downgrade from hardirq to softirq" atomic,
>and I think it would clean up the crazy code too (currently it does a
>*lot* of back-and-forth on the preempt flags), but I clearly missed
>some case where we used a wrapper or two to add some tracepoint or a
>RCU scheduling point. And I'm not going to worry about it right now,
>since I'm preparing to make v3.8 soon.
>
>But if somebody spots the bug, holler.
>
>                     Linus

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
