Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3C3FKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 01:10:25 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:40262 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab3C3FKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 01:10:23 -0400
MIME-Version: 1.0
In-Reply-To: <CA+i8gKL3PCBW_KxkYSOKE7-PHdHVsP6eLUBTuYRtunBheALJMg@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
	<CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
	<CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>
	<CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>
	<1364609309.1818.8.camel@buesod1.americas.hpqcorp.net>
	<CA+i8gK+LP_4SU8GwLMau0QvyGswZ5sKqOYnJVPZNWXZY_W9dEA@mail.gmail.com>
	<CA+55aFzqzHa_6bHrqaa+6k3PZiibuJuDd1VwVD7jL047BjR=hA@mail.gmail.com>
	<CA+i8gKL3PCBW_KxkYSOKE7-PHdHVsP6eLUBTuYRtunBheALJMg@mail.gmail.com>
Date: Fri, 29 Mar 2013 22:10:20 -0700
X-Google-Sender-Auth: 4IeaXSzMM91yDzyI4PgSjQeMVBM
Message-ID: <CA+55aFy7OtkWiqO+CxmDgkyfR_58=hdkc-VoaqWCngETw19Euw@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 9:33 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>
> I just tried the 7 original patches + the 2 one liners from -next +
> modified Linus' patch (attached)

.. that patch looks fine.

> on the top of 3.9-rc4 using
> PREEMPT_NONE and after moving sem_lock(sma, NULL, -1) as explained
> above. I was building two packages at the same time, went away for 30
> seconds, came back and everything froze as soon as I touched the
> laptop's touchpad. Maybe a coincidence but anyway... Another shot in
> the dark, I had this weird message when trying to build gcc:
> semop(2): encountered an error: Identifier removed

This came from the gcc build?

That's just crazy. No normal app uses sysv semaphores. I have an older
gcc build environment, and some grepping shows it has some ipc
semaphore use in the libstdc++ testsuite, and some libmudflap hooks,
but that should be very very minor.

You seem to trigger errors really trivially easily, which is really
odd. It's sounding less and less like some subtle race, and more like
the error just happens all the time. If you can make even the gcc
build generate errors, I don't think they can be some rare blue-moon
thing.

I notice that your dmesg says that your kernel is compiled by
gcc-4.8.1 prerelease. Is there any chance that you could try to
install a known-stable gcc, like 4.7.2 or something. It's entirely
possible that it's a kernel bug even if it's triggered by some more
aggressive compiler optimization or something, but it would be really
good to try to see if this might be gcc-specific.

For example, I wonder if your gcc might miscompile idr_alloc() or
something, so that we get the same ID for different ipc objects. That
would certainly potentially cause chaos.

Hmm?

                      Linus
