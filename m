Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbbAFWeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:34:01 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:40485 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbbAFWd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:33:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAHkRjk5EAUvdR5ED_M=dB+5yu3RtZLgo_aighUrozovHKnOp=w@mail.gmail.com>
References: <20150104190123.GA20153@amd>
	<alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
	<CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
	<alpine.LFD.2.11.1501041526390.18844@knanqh.ubzr>
	<CA+55aFxRRcSJ5i=EcQ-qqMrz0icn28JKjQuH3xGU65hjpVm9hw@mail.gmail.com>
	<20150104211555.GB12302@n2100.arm.linux.org.uk>
	<20150105142206.76ca2e18@lxorguk.ukuu.org.uk>
	<CAHkRjk5EAUvdR5ED_M=dB+5yu3RtZLgo_aighUrozovHKnOp=w@mail.gmail.com>
Date: Tue, 6 Jan 2015 14:33:57 -0800
X-Google-Sender-Auth: KrUOmlyTBBqvFibFphdk8doKbS8
Message-ID: <CA+55aFwfnT2M1OXzYiy74WCdoRHpKgMby20eqCBe-pEoS6ds-w@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 10:22 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> If the always constant bogomips is not desirable, we are left with
> having to do a dummy calibration to guess some value to be reported to
> user as BogoMIPS.

Not at all.

Just use whatever counter frequency you use for the delay loop (and
traditionally, you multiply by two, since the *original* bogomips loop
was two instructions).

That's why the bogomips printout has that "500000" value. It's
multiplying by two, and then dividing by a million to get MHz.

That's what bogomips *is*, for chrissake! It's a bogus measure of how
many times you go through the delay loop.

And the delay loop does *not* have to be that "decrement and loop". It
can be "read timer and loop". Since the delay loop is all about
microseconds, your timer had betterr have a frequency in the MHz range
anyway.

On some platforms, it could be the traditional sw-based loop counter
because it's the only thing you have. On others, it could be a CPU
cycle counter. On yet others, it could be a specialized timer counter.
It doesn't matter, all is valid.

What is *not* valid is clearly:

 - removing the bogomips line.

   You can try again in a couple of years. Maybe nobody will notice.
But people *did* notice, and that commit got reverted. End of story,
anybody who argues for removal is simply wrong.

 - making shit up

   Bogomips is a bogus benchmark, but it is *not* a constant number,
and it *does* have to do with the timing loop.

The "making shit up" case is less wrong (pretty much by definition,
since "breaking user space applications" is the most wrong you can
ever be), but you know what? bogomips has a long history of bogosity.
It's integral. It goes back a long time. It has historical
significance. It isn't 0.01 material, but it was certainly added
before 1.0.

.. and it's still a better benchmark than dhrystone.

                           Linus
