Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762498Ab3DCRGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:06:19 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:33049 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760213Ab3DCRGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:06:16 -0400
MIME-Version: 1.0
In-Reply-To: <5144849A.8050907@metafoo.de>
References: <1363364801-23684-1-git-send-email-ch.naveen@samsung.com>
	<51439846.9090201@metafoo.de>
	<CAD=FV=V+-DwCjGoookySCazazBBYOoRO+=G5Q_WXAw+SrXNc-A@mail.gmail.com>
	<5144849A.8050907@metafoo.de>
Date: Wed, 3 Apr 2013 10:06:14 -0700
X-Google-Sender-Auth: yHxoJXnYms1MdD_Xvt_zEREJtYI
Message-ID: <CAD=FV=VBYHyD6yXBrM1BV3gazDFT0oHgvJM0+5LU1w4AO16Yzg@mail.gmail.com>
Subject: Re: [RFC: PATCH 2/2] iio: adc: exynos_adc: Handle timeout and race conditions
From: Doug Anderson <dianders@chromium.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars,

On Sat, Mar 16, 2013 at 7:41 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> I think you still need the mutex for serialization, otherwise the requests
> would just cancel each other out. Btw. what happens if you start a conversion
> while another is still in progress? Is it possible to abort a conversion?

I was thinking that the spinlock would just replace the mutex for the
purposes of serialization.

I stepped back a bit, though, and I'm wondering if we're over-thinking
things.  The timeout case should certainly be handled properly (thanks
for pointing it out), but getting a timeout is really not expected and
adding a lot of extra overhead to handle it elegantly seems a bit
much?

Specifically, the mutex means that we have one user of the ADC at a
time, and ADC conversion has nothing variable about it.  The user
manual that I have access to talks about 12-bit conversion happening
in 1 microsecond with a 5MHz input clock or 5 microseconds with a 1MHz
input clock.  Even if someone has clocks configured very differently,
it would be hard to imagine a conversion actually taking a full
second.

...so that means that if the timeout actually fires then something
else fairly drastic has gone wrong.  It's _very_ unlikely that the IRQ
will still go off for this conversion sometime in the future.

To me, total modifications to what's landed already ought to be:

* Change timeout to long (from unsigned long)

* Make sure we return errors (negative results) from
wait_for_completion_interruptible_timeout() properly.

* If we get back a value of 0 from
wait_for_completion_interruptible_timeout() then we should print a
warning and attempt machinations to reset the ADC.  Without ever
seeing real-world situtations that would cause a real timeout these
machinations would be a bit of a guess (is resetting the adc useful
when it's more likely that someone accidentally messed with the clock
tree or power gated the ADC?)...  ...or perhaps a warning and a TODO
in the code would be enough?


Thoughts?

-Doug
