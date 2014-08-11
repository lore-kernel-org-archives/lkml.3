Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaHKPBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:01:34 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37510 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaHKPBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:01:32 -0400
MIME-Version: 1.0
In-Reply-To: <53E32C09.5000704@roeck-us.net>
References: <1406139132-5404-1-git-send-email-linux@roeck-us.net>
 <CAAVeFuKsJpSYo2DMyTdYE2J5Cu_ZD=b9o-=S0DLDccyNmwniNg@mail.gmail.com>
 <53D0A8B7.2010005@roeck-us.net> <CAAVeFuK5uKhpkpEnoRFGKU4G4Fey0+giz5wwmtr+OCLJHPvnLQ@mail.gmail.com>
 <53E32C09.5000704@roeck-us.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 12 Aug 2014 00:01:11 +0900
Message-ID: <CAAVeFuJohBznnjELvJj0OUCK+anbZ-j1xPc9gyKDGVq9X0MDSA@mail.gmail.com>
Subject: Re: [RFC PATCH] gpiolib: Provide and export gpiod_export_name
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 4:34 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> Or you could have a platform device which sole purpose is to request
>> the GPIOs to export and export them using gpio_export() and
>> gpio_export_link() using itself as the device parameters. All your
>> links would then appear under the same sysfs directory, and that
>> directory name would be consistent across platforms. What is wrong
>> with this approach?
>>
> The link does not appear in /sys/class/gpio. I understand you don't like the
> idea of having named gpio pins in that directory, but that is supported
> today,
> it works, and others do like it.

Who are these "others" that like it?

>
>
>> As for the patch itself, as I said before I am not a huge fan of
>> putting randomly-named exports under /sys/class/gpio, but since there
>> is a precedent with the driver GPIO names array I don't think this
>> makes the situation much worse. Still I'd like you to explain me what
>> I missed and why you cannot use the technique described above to
>> achieve your goal with the currently existing interfaces.
>>
>
> I thought I explained it before; my users (ie the people writing user space
> applications accessing the pins) expect to see the exported pins in
> /sys/class/gpio
> and not in a more or less arbitrary directory. They are used to this
> approach, and they are less than enthusiastic to change it. The code needed
> to generate the exported pin names is a bit messy, it being tied to the
> driver,
> but it does both exist and work. This patch was an attempt to provide a
> cleaner API to accomplish the same without having to touch various gpio
> drivers which don't provide the ability to configure the names array.
>
> Note that I don't consider the names "random". They are much less random
> than gpioX, where X can change each time the system boots or, for OIR
> capable systems, each time a gpio driver is instantiated or removed.
> In today's system, without well defined names, one never knows if gpioX
> points
> to the pin the user is looking for. If the pin is named "this-is-your-pin"
> it is much easier to write user space code using it.
>
> Oddly enough, if I would use the platform driver approach you suggest,
> I would still need a well defined directory, say, /sys/class/named_gpios,

Which you would have through your platform device, and I guess you are
not denying that it is possible to do it that way using the existing
APIs. The discussion now seems to be "let's allow named GPIOs in
/sys/class/gpio". Why? Because the customer wants it this way. The
point is, that in mainline we don't merge changes because to make the
customer happy, but because they generally make sense. I fail to see
how it makes more sense to allow named GPIOs in /sys/class/gpio
instead of the node of the device controlled by these GPIOs.

Let me elaborate some more on why: GPIOs are generally tied to fulfil
a precise function for a given device. Having them appearing under the
node of the device in question makes it clear what their relationship
to that device is ; and the name of the node can then be a reflection
of that function. On the contrary, letting them all bloom under a
single directory forces you to resort to complex and confusing names
to differenciate your GPIOs, with everyone coming with their own
naming pattern and so on. If it doesn't look like a bad idea to you,
I'm afraid I cannot be any more convincing.

Also, it did not occur to me until now, but with this patch alone you
are going to be hit by the objection that we don't add APIs that do
not have upstream users. That policy is quite strongly enforced, and
I'm afraid this makes this patch even more unlikely to be accepted.

So my final word on this is that it seems quite clear that exporting
GPIOs under the device they control is a more elegant solution for
mainline, and a solution that is already doable using currently
existing APIs. I encourage you to explore that direction and work with
your customer to make them accept that small change ; if that is not
possible this will have to be maintained out of mainline ; sorry.
