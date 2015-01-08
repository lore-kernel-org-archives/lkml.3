Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbbAHAFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:05:53 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39411 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbAHAFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:05:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com>
References: <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
	<CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
	<alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
	<20150104212659.GC12302@n2100.arm.linux.org.uk>
	<alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
	<CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
	<CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
	<alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr>
	<CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
	<alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
	<20150107205346.GO12302@n2100.arm.linux.org.uk>
	<CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com>
Date: Wed, 7 Jan 2015 16:05:50 -0800
X-Google-Sender-Auth: vRGKEEt35f5yxhr4DB8HZ7vSYls
Message-ID: <CA+55aFz0cjsS4BTwtBt9P1pKHmPjXPYnOvFuP07UVoek7jSYLw@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 2:14 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> We need to look back at the point we added timer-based delay about 2.5
> years ago. Prior to commit d0a533b18235d362, platform A reported
> bogomips 300. After that commit, the *same* platform A (not B),
> started reported 6.
>
> Is the above considered user breakage?

Things change. The only thing that is considered "user breakage" is
when something actually doesn't work any more.

That has always been the rule. It's not that the kernel ABI (with all
the system calls, all the /proc files, all the ioctl's, etc) is set in
stone and "sacred". Absolutely anything can be changed, wildly.

But if it turns out that applications (or hardware) that people use
end up breaking noticeably, then *that* is a regression.

And the important part there are those weasel-words: "that people use"
and "noticeably".

For example, a test-suite giving a different result is *not* a
regression, although it should obviously be considered a big red flag.
So if somebody tells you that some test-suite shows that some ABI
changed, at the very least you should be very nervous about things.

But if that same test-suite result is then used in a production
environment as part of some actual user flow, and it breaks that user
model, then it suddenly becomes a regression.  So the very definition
of "regression" is not really about the API changing, but about
breaking peoples existing setups. Of course, if you never change any
API that is visible to user space, you can never create that kind of
regression, so they are _related_, but some people confuse the two.
They are still very different.

Similarly, theoretical arguments of "so-and-so wouldn't work after
this change" are just that - theoretical arguments. It's something to
worry about, but it's not an actual *regression* until it causes
problems.

For an extreme example of this: we can remove support for whole
platforms and architectures, and sometimes we do. It clearly
completely breaks support for the hardware in question - but it only
counts as a regression if anybody notices and cares. There may still
be active users of that platform that provably cannot possibly work at
all any more, but if they never upgrade the kernel, then it's still
not a regression.

In this case, pretty much all of /proc/cpuinfo is mainly
"informational". Maybe there are applications that show it, but more
likely you have people who ssh in and just do

    cat /proc/cpuinfo

to see what kind of system they are running on. That's the main point
of much of /proc, and things like /proc/cpuinfo in particular.

Now *main* point doesn't necessarily mean "only point". There clearly
are binaries parsing it. Some do it to figure out how many CPU's the
system has, often simply because using /proc is simple from various
scripting environments, for example. So while most of /proc/cpuinfo is
clearly for human consumption, it's also understandable that some
parts of it might matter for people.

And quite frankly, I personally think that any program that parses
/proc/cpuinfo in order to find the bogomips value and use it for
anything is just clearly insane. Why would you ever do that? It makes
no sense. It's crazy. Apparently the crazy audio library didn't even
do it in a meaningful way, and the use of that value seems to be
pretty much random, and the actual value likely doesn't really even
*matter*.

But the rule for "regression" has never been about sanity, or about
whether the ABI changes. There are tons of horribly insane user
programs. Parsing /proc to find bogomips may be insane and odd, but
it's certainly not the worst kind of diseased code I've ever heard
about. We have had major programs that literally depended on totally
insane small details that were never intentional, and just happened to
have some particular implementation detail. And then the
implementation changed, and the interface ostensibly did exactly the
same thing, but because it did it with some meaningless difference
that couldn't *possibly* matter in any sane situation, it caused a
regression.

So the kernel regression rules are very strict in that it's the
absolute #1 rule in kernel development, but at the same time, they are
about as lax as they can possibly be: an interface change is only a
regression if somebody notices.

Changing the bogomips value - even radically - or removing it entirely
isn't a regression in itself.

And in this case, I do suspect that the *actual* value really almost
doesn't matter. It looks more like some internal badly done hint for
some buffer size or other. It is possible that wild fluctuations could
be noticeable, but it's fairly unlikely.

The other "good news" in this area is that I suspect that the random
ARM platforms that actually changed 2.5 years ago are not very widely
used any more.  So not only does the actual real value probably not
matter much to begin with, but the platforms where it really changed
are probably not a major issue.

                            Linus
