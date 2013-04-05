Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161844Ab3DEHyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 03:54:14 -0400
Received: from smtp-out-239.synserver.de ([212.40.185.239]:1061 "EHLO
	smtp-out-237.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751949Ab3DEHyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 03:54:11 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25423
Message-ID: <515E90FD.10006@metafoo.de>
Date: Fri, 05 Apr 2013 10:53:17 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>
Subject: Re: [RFC: PATCH 2/2] iio: adc: exynos_adc: Handle timeout and race
 conditions
References: <1363364801-23684-1-git-send-email-ch.naveen@samsung.com> <51439846.9090201@metafoo.de> <CAD=FV=V+-DwCjGoookySCazazBBYOoRO+=G5Q_WXAw+SrXNc-A@mail.gmail.com> <5144849A.8050907@metafoo.de> <CAD=FV=VBYHyD6yXBrM1BV3gazDFT0oHgvJM0+5LU1w4AO16Yzg@mail.gmail.com>
In-Reply-To: <CAD=FV=VBYHyD6yXBrM1BV3gazDFT0oHgvJM0+5LU1w4AO16Yzg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 07:06 PM, Doug Anderson wrote:
> Lars,
> 
> On Sat, Mar 16, 2013 at 7:41 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> I think you still need the mutex for serialization, otherwise the requests
>> would just cancel each other out. Btw. what happens if you start a conversion
>> while another is still in progress? Is it possible to abort a conversion?
> 
> I was thinking that the spinlock would just replace the mutex for the
> purposes of serialization.
> 

Since we sleep inside the protected section we need to use a mutex.

> I stepped back a bit, though, and I'm wondering if we're over-thinking
> things.  The timeout case should certainly be handled properly (thanks
> for pointing it out), but getting a timeout is really not expected and
> adding a lot of extra overhead to handle it elegantly seems a bit
> much?
> 
> Specifically, the mutex means that we have one user of the ADC at a
> time, and ADC conversion has nothing variable about it.  The user
> manual that I have access to talks about 12-bit conversion happening
> in 1 microsecond with a 5MHz input clock or 5 microseconds with a 1MHz
> input clock.  Even if someone has clocks configured very differently,
> it would be hard to imagine a conversion actually taking a full
> second.
> 
> ...so that means that if the timeout actually fires then something
> else fairly drastic has gone wrong.  It's _very_ unlikely that the IRQ
> will still go off for this conversion sometime in the future.
> 

It's not the timeout case I'm worried about, but the case where the transfer
is interrupted by the user. Even though it is rather unlikely for the
problem to occur we should still try to avoid it, this is one of these
annoying heisenbugs that happen once in a while and nobody is able to
reproduce them.

> To me, total modifications to what's landed already ought to be:
> 
> * Change timeout to long (from unsigned long)
> 
> * Make sure we return errors (negative results) from
> wait_for_completion_interruptible_timeout() properly.
> 
> * If we get back a value of 0 from
> wait_for_completion_interruptible_timeout() then we should print a
> warning and attempt machinations to reset the ADC.  Without ever
> seeing real-world situtations that would cause a real timeout these
> machinations would be a bit of a guess (is resetting the adc useful
> when it's more likely that someone accidentally messed with the clock
> tree or power gated the ADC?)...  ...or perhaps a warning and a TODO
> in the code would be enough?
> 
> 
> Thoughts?

I think most of this is already implemented and Naveen sent a patch to reset
the controller in case of a timeout, which is a good idea and works fine,
but you still should handle the case where the user aborted the transfer.
Just resetting the core should work as well in that case.

- Lars
