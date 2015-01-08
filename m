Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbbAHE4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 23:56:11 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:54629 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbAHE4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 23:56:10 -0500
Date: Wed, 7 Jan 2015 23:56:06 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <CA+55aFyKz2tZDq6ANjKVmuvipKtjr+UP4c7ypNXtbXBcapOpKg@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1501072228440.1322@knanqh.ubzr>
References: <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr> <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com> <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr> <20150104212659.GC12302@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
 <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com> <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com> <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr> <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
 <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr> <20150107205346.GO12302@n2100.arm.linux.org.uk> <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com> <CA+55aFz0cjsS4BTwtBt9P1pKHmPjXPYnOvFuP07UVoek7jSYLw@mail.gmail.com>
 <alpine.LFD.2.11.1501071914250.1322@knanqh.ubzr> <CA+55aFyKz2tZDq6ANjKVmuvipKtjr+UP4c7ypNXtbXBcapOpKg@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Linus Torvalds wrote:

> On Wed, Jan 7, 2015 at 4:45 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> >
> > Would you mind if on ARM we used the bogomips line as an informative
> > approximation for the CPU speed?  After all, this is the meaning it had
> > for nearly 20 years.  And unlike on X86 we don't have the actual CPU
> > clock in there.  And that's still the meaning it has on most ARM systems
> > out there.
> 
> Yes, I actually would mind, unless you have a damn good reason for it.

Consistency.

> On x86, we have bogomips, but we also have this line:
> 
>    cpu MHz : 2275.109

On ARM we just can't find the CPU clock in a generic way.  Yes, this is 
part of the ARM hardware environment where every implementer can do 
whatever they want with things that are not architected.  That's not 
something we kernel developers can do anything about.

What we can do in a generic way, though, is counting the number of loops 
the CPU can perform during a jiffy.

> and I really don't see why you should lie in your /proc/cpuinfo.

You keep harping on with that statement.  Could you just tell me _what_ 
we would be lying about and to _whom_?  It's probably the third time I'm 
asking this with no rational answer so far.

What I'm telling you is that a kernel on a machine that used to show 800 
bogomips and suddenly start showing 6 bogomips is lying.  But for some 
contrived reasons that's fine with you.

> Quite frankly, the *only* actual real reason I've heard from you for
> not having the real bogomips there is "waste of time".

Quite the reverse. In fact this is getting hilarious.  Either you keep 
on understanding all I say only half way, or you purposely twist my 
words.  What kind of game are you playing?

What I said is that:

1) The user space bogomips reporting on ARM, for the best part of the 
   last 20 years, was based on the number of loops the CPU can perform 
   during a jiffy.  Given its history that's what I'd call the real 
   bogomips.

2) Because of some relatively recent internal kernel changes, the 
   bogomips reporting became totally useless for its consumers as it was 
   orders of magnitude smaller than it used to be.  Like moving from 800 
   to 6 on the same hardware. Those consumers started complaining.

3) We told those consumers: bogomips is evil, stop wasting everyone's 
   time and don't use it, because a value of 8 is no longer the real 
   bogomips. It was unreliable before, now it is meaningless. Go consume 
   another metric instead.

4) Complaints still came by, so we decided to solve the issue by simply 
   removing the meaningless bogomips reporting altogether. This worked 
   wonderfully for more than a year, at least from our perspective.

5) The lack of a bogomips reporting broke some user space applications. 
   This is an unacceptable regression and the meaningless bogomips was 
   reinstated as in (3).

6) Now I'm claiming that if we're going to need the bogomips reporting 
   not to break user space, we should at least go back to the real 
   bogomips as it has been for the best part of the last 20 years i.e 
   like in (1), not the meaningless one.

For (6) I have the patch, it is non intrusive, and doesn't touch generic 
code at all. The diffstat for my latest version is:

 2 files changed, 2 insertions(+), 15 deletions(-)

So, instead of telling me _why_ the above is not the sanest thing to do, 
you come up with diatribes like:

> And this whole thread has been *nothing* but waste of time. But it has
> been *you* wasting time, and that original commit. If you had just
> left it alone, and had just let the revert do its job, none of this
> waste of time would have happened.

You are just full of b/s.  I'm bringing rational arguments to this 
discussion, and when you can't debunk them you have nothing better than 
accusing me of wasting time with a stream of emotions. Sorry but I'm 
holding you up to better standards.

Sure my NAK on the revert was premature.  I was envisioning a revert 
that would also include (6) above.  But the issue is no longer about the 
revert. We can do (6) separately.


Nicolas
