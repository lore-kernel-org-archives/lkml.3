Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaLDPCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:02:50 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:40911 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832AbaLDPCt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:02:49 -0500
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CAAVeFuKx1uWVh-TQeFKN4uS9TyzQH4BbQ2q1yM4uJsnQdfdzPQ@mail.gmail.com>
Date: Thu, 4 Dec 2014 17:02:43 +0200
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Benoit Parrot <bparrot@ti.com>, Jiri Prchal <jiri.prchal@aksignal.cz>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D73736E8-DC33-4F98-82DD-DF42B989A453@antoniou-consulting.com>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com> <1416527684-19017-2-git-send-email-bparrot@ti.com> <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com> <20141201163639.GI25249@lukather> <CAAVeFuLTupDenZdSi8KO+dYsf-ekcqjsDaQ2GEzYpBG34oF7Zw@mail.gmail.com> <CACRpkdZcNcPBYQM438CZJx1gYst9BFBSTj-3Qv2aPGF9pdWa5g@mail.gmail.com> <20141202161227.GH30256@lukather> <CAAVeFu+Gms6ptyK6j1Zy_wWg+9URs+9zBu=pOiwiEERO=8NjNw@mail.gmail.com> <0EF6A712-5FF1-41BE-B8A9-21ABE7FE37F9@antoniou-consulting.com> <CAAVeFu+kfPi8CUR-YergQv9P1wMBzOik_Q1KBKMTVY1Gg_FBzg@mail.gmail.com> <C9DBE2F0-A725-4D05-BEC6-F083F3F83B9F@antoniou-consulting.com> <CAAVeFuKx1uWVh-TQeFKN4uS9TyzQH4BbQ2q1yM4uJsnQdfdzPQ@mail.gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

> On Dec 4, 2014, at 16:58 , Alexandre Courbot <gnurou@gmail.com> wrote:
> 
> On Thu, Dec 4, 2014 at 11:47 PM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
>> Hi Alexandre,
>> 
>>> On Dec 4, 2014, at 16:41 , Alexandre Courbot <gnurou@gmail.com> wrote:
>>> 
>>> On Thu, Dec 4, 2014 at 11:27 PM, Pantelis Antoniou
>>> <panto@antoniou-consulting.com> wrote:
>>>> Hi Alexandre,
>>>> 
>>>> I tried to stay away while things are being fleshed out but…
>>>> 
>>>>> On Dec 4, 2014, at 16:15 , Alexandre Courbot <gnurou@gmail.com> wrote:
>>>>> 
>>>>> On Wed, Dec 3, 2014 at 1:12 AM, Maxime Ripard
>>>>> <maxime.ripard@free-electrons.com> wrote:
>>>>>> On Tue, Dec 02, 2014 at 03:29:46PM +0100, Linus Walleij wrote:
>>>>>>> On Tue, Dec 2, 2014 at 3:13 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
>>>>>>>> On Tue, Dec 2, 2014 at 1:36 AM, Maxime Ripard
>>>>>>>> <maxime.ripard@free-electrons.com> wrote:
>>>>>>> 
>>>>>>>>> The only thing I'd like to have would be that the request here would
>>>>>>>>> be non-exclusive, so that a later driver would still be allowed later
>>>>>>>>> on to request that GPIO later on and manage it itself (ideally using
>>>>>>>>> the usual gpiod_request function).
>>>>>>>> 
>>>>>>>> Actually we have a plan (and I have some code too) to allow multiple
>>>>>>>> consumers per GPIO. Although like Benoit I wonder why you would want
>>>>>>>> to hog a GPIO and then request it properly later. Also, that probably
>>>>>>>> means we should abandon the hog since it actively drives the line and
>>>>>>>> would interfere with the late requested. How to do that correctly is
>>>>>>>> not really clear to me.
>>>>>>> 
>>>>>>> I don't get the usecase. A hogged GPIO is per definition hogged.
>>>>>>> This sounds more like "initial settings" or something, which is another
>>>>>>> usecase altogether.
>>>>>> 
>>>>>> We do have one board where we have a pin (let's say GPIO14 of the bank
>>>>>> A) that enables a regulator that will provide VCC the bank B.
>>>>>> 
>>>>>> Now, both banks are handled by the same driver, but in order to have a
>>>>>> working output on the bank B, we do need to set GPIO14 as soon as
>>>>>> we're probed.
>>>>>> 
>>>>>> Just relying on the usual deferred probing introduces a circular
>>>>>> dependency between the gpio-regulator that needs to grab its GPIO from
>>>>>> a driver not there yet, and the gpio driver that needs to enable its
>>>>>> gpio-regulator.
>>>>> 
>>>>> I don't get it. According to what you said, the following order should
>>>>> go through IIUC:
>>>>> 
>>>>> 1) bank A is probed, gpio 14 is available
>>>>> 2) gpio-regulator is probed, acquires GPIO 14, regulator for Bank B is available
>>>>> 3) bank B is probed, grabs its regulator and turn it on, probes.
>>>>> 
>>>>> What am I missing?
>>>>> 
>>>>>> 
>>>>>> GPIO hogging needs to be the ideal solution for that, since we can
>>>>>> just enforce the GPIO14 value as the driver is probed, which provides
>>>>>> the guarantee that any driver using the bank B will actually drive the
>>>>>> GPIO it might use.
>>>>> 
>>>>> At this point I start wondering if such initial setup should not be
>>>>> the job of the bootloader? GPIO hogging ought to be simple and
>>>>> definitive, adding the possibility to have it just as an initial value
>>>>> would considerably complexify it. E.g. when is the gpio chip driver
>>>>> supposed to release the hogged descriptor in such a case?
>>>>> 
>>>> 
>>>> Do not count on the bootloader setting up anything. The trend is
>>>> for the bootloader to setup the minimal environment to load your kernel
>>>> and jump to it.
>>>> 
>>>> http://www.denx.de/wiki/pub/U-Boot/MiniSummitELCE2013/2013-ELCE-U-Boot-Falcon-Boot.pdf
>>> 
>>> Just wondering. :)
>>> 
>>> But yeah, there are some use-cases (such as this one or
>>> Linux-as-a-bootloader) for which this would not play nicely.
>>> 
>>>> 
>>>> 
>>>>> Note that if the multiple GPIO consumer feature we are planning goes
>>>>> through, you should be able to use both hogging *and* a regulator on
>>>>> the same GPIO and achieve what you want. The expectation of multiple
>>>>> consumers is that the board designers know what they are doing, and
>>>>> this case would certainly fit (chip hogs the line and doesn't touch
>>>>> the value after that, letting the regulator control it without any
>>>>> conflict afterwards), although it would of course be better to solve
>>>>> the issue through regular probing...
>>>> 
>>>> 
>>>> That’s why I was advocating a simple probing driver for all this.
>>>> Figure out a way for this driver to be probed first would be an easier
>>>> solution that what’s going on here.
>>> 
>>> Do you mean, a driver whose sole job is to probe other drivers in the
>>> right order? :/
>> 
>> $DEITY no :)
>> 
>> I mean instead of having the gpio hog in the gpio adapter driver, have
>> a gpio-hog driver, that’s using an undisclosed method to make sure that
>> it’s the first one to be probed afterwards.
> 
> IIUC that would not solve this particular issue - here the GPIO
> controller is both a provider and (indirect) consumer of a GPIO for
> itself. If the hog is in a separate node, if would have to be probed
> from inside the probe() function of the GPIO controller to do the job,
> which would be the same effect as having the hogs directly under the
> controller node, only with more hassle.
> 
> Again, IIUC. >_<

If you had a way to specify the order of probing that would work no?
You don’t have to do it in the gpio-controller, you can do it in the
platform bus probe.

Regards

— Pantelis

