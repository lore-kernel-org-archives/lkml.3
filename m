Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaLFMJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 07:09:00 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37240 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaLFMI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 07:08:57 -0500
MIME-Version: 1.0
In-Reply-To: <20141205102427.GU30256@lukather>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
 <1416527684-19017-2-git-send-email-bparrot@ti.com> <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
 <20141201163639.GI25249@lukather> <CAAVeFuLTupDenZdSi8KO+dYsf-ekcqjsDaQ2GEzYpBG34oF7Zw@mail.gmail.com>
 <CACRpkdZcNcPBYQM438CZJx1gYst9BFBSTj-3Qv2aPGF9pdWa5g@mail.gmail.com>
 <20141202161227.GH30256@lukather> <CAAVeFu+Gms6ptyK6j1Zy_wWg+9URs+9zBu=pOiwiEERO=8NjNw@mail.gmail.com>
 <20141204142741.GQ30256@lukather> <CAAVeFuJTjWPzQYYkV3jW3+h6uigzzeKS9d7pY2cQ-dK119msXg@mail.gmail.com>
 <20141205102427.GU30256@lukather>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 6 Dec 2014 21:08:36 +0900
Message-ID: <CAAVeFuL2CYtcDnwnuWD5wfMLGK-GEwBA09BXkhBMFJCjr2rEcg@mail.gmail.com>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Benoit Parrot <bparrot@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 7:24 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Thu, Dec 04, 2014 at 11:49:19PM +0900, Alexandre Courbot wrote:
>> On Thu, Dec 4, 2014 at 11:27 PM, Maxime Ripard
>> <maxime.ripard@free-electrons.com> wrote:
>> > Hi,
>> >
>> > On Thu, Dec 04, 2014 at 11:15:38PM +0900, Alexandre Courbot wrote:
>> >> On Wed, Dec 3, 2014 at 1:12 AM, Maxime Ripard
>> >> <maxime.ripard@free-electrons.com> wrote:
>> >> > On Tue, Dec 02, 2014 at 03:29:46PM +0100, Linus Walleij wrote:
>> >> >> On Tue, Dec 2, 2014 at 3:13 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
>> >> >> > On Tue, Dec 2, 2014 at 1:36 AM, Maxime Ripard
>> >> >> > <maxime.ripard@free-electrons.com> wrote:
>> >> >>
>> >> >> >> The only thing I'd like to have would be that the request here would
>> >> >> >> be non-exclusive, so that a later driver would still be allowed later
>> >> >> >> on to request that GPIO later on and manage it itself (ideally using
>> >> >> >> the usual gpiod_request function).
>> >> >> >
>> >> >> > Actually we have a plan (and I have some code too) to allow multiple
>> >> >> > consumers per GPIO. Although like Benoit I wonder why you would want
>> >> >> > to hog a GPIO and then request it properly later. Also, that probably
>> >> >> > means we should abandon the hog since it actively drives the line and
>> >> >> > would interfere with the late requested. How to do that correctly is
>> >> >> > not really clear to me.
>> >> >>
>> >> >> I don't get the usecase. A hogged GPIO is per definition hogged.
>> >> >> This sounds more like "initial settings" or something, which is another
>> >> >> usecase altogether.
>> >> >
>> >> > We do have one board where we have a pin (let's say GPIO14 of the bank
>> >> > A) that enables a regulator that will provide VCC the bank B.
>> >> >
>> >> > Now, both banks are handled by the same driver, but in order to have a
>> >> > working output on the bank B, we do need to set GPIO14 as soon as
>> >> > we're probed.
>> >> >
>> >> > Just relying on the usual deferred probing introduces a circular
>> >> > dependency between the gpio-regulator that needs to grab its GPIO from
>> >> > a driver not there yet, and the gpio driver that needs to enable its
>> >> > gpio-regulator.
>> >>
>> >> I don't get it. According to what you said, the following order should
>> >> go through IIUC:
>> >>
>> >> 1) bank A is probed, gpio 14 is available
>> >> 2) gpio-regulator is probed, acquires GPIO 14, regulator for Bank B is available
>> >> 3) bank B is probed, grabs its regulator and turn it on, probes.
>> >>
>> >> What am I missing?
>> >
>> > It would be true if bank A and B were exposed through different
>> > drivers (or at least different instances of the same driver), which is
>> > not the case.
>> >
>> > In our case, banks A and B are handled by the same instance.
>>
>> Ok, so both banks A and B are part of the same device/DT node. Now I
>> think I understand the issue. You need to hog the pin so that bank B
>> will work right after the device is probed.
>
> Exactly.
>
>> But you will still have the problem that the regulator device will
>> *not* be available when your device is probed, so you cannot call
>> regulator_get() for bank B anyway. I guess your only choice is to hog
>> that pin and leave it active ad vitam eternam.
>
> Hmmm, indeed.
>
> I'll stop boring you with this then :)

Please *keep* bothering us with any doubt you may have until they are
all cleared and you are sure this feature will be useful to you.
Especially since we are designing DT bindings that will have to be
carried over forever. We really want to get them right, and need input
of potential users for that.

Having a few design arguments is a small thing compared to the hassle
of having to work with unadapted features and bindings.
