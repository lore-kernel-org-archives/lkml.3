Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbbANMSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:18:24 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:62682 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbbANMSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:18:22 -0500
MIME-Version: 1.0
In-Reply-To: <20150105174723.GA11391@sysresccd>
References: <20141224215352.GA26482@sysresccd>
	<CAAVeFuJcWizqtW4mmD8ow5eg2841vgXhZ=7bHDiO3ZJfE2ezog@mail.gmail.com>
	<20150105174723.GA11391@sysresccd>
Date: Wed, 14 Jan 2015 13:18:21 +0100
Message-ID: <CACRpkdathuQYLba1wMGLsV2TqhfBqGNQQAWqPfZ7XH1Oj+UFZg@mail.gmail.com>
Subject: Re: Linux GPIO internals
From: Linus Walleij <linus.walleij@linaro.org>
To: Michael Welling <mwelling@emacinc.com>, linux-api@vger.kernel.org
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Roland Stigge <stigge@antcom.de>,
        Wolfgang Grandegger <wg@grandegger.com>, tstratman@emacinc.com,
        Rojhalat Ibrahim <imr@rtschenk.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 6:47 PM, Michael Welling <mwelling@emacinc.com> wrote:
> On Sat, Jan 03, 2015 at 02:12:06PM +0100, Alexandre Courbot wrote:

>> It seems like your mail is coming just at the right time. We have
>> recently merged a patch that allows setting several GPIOs at the same
>> time, if the hardware supports it:
>>
>> http://patchwork.ozlabs.org/patch/406666/
>
> This looks like a good starting point. Being able to access to multiple
> GPIOs simultaneously on the same controller bank is great.

It's intended to handle the case when several GPIOs can be
switched at the same time by a single register write. It implies
being on the same controller.

> What is nice about the EMAC class is that the GPIOs do not necessarily
> have to be on the same bank (or controller) to be grouped together. The
> system call overhead of accessing a single IO is the same as multiple
> IOs in the same group.

You're comparing pears and apples now I think.

A userspace ABI making it possible to switch several GPIOs
on several controllers is perfectly doable both with and without
the above interface.

In this latter case you're more worried about the latency
incurred by the userspace/kernelspace switch, whereas
the former is about the delays incurred by several register
writes.

Userspace/kernelspace switch delay is a few magnitudes
larger than the delay between sequenced register writes I
suspect.

> Still wondering what happened to the gpioblock patch.

Roland?

> The sysfs interface is great for command line and scripting languages
> but it has more overhead. It requires string conversion at both the
> kernel and userspace. More system calls are typically required for
> similar transactions.

Agree. I have a problem with it too.

>> Considering the constraints that we have (no GPIO integers for
>> exporting, sysfs-based, uses gpiod_*array()), do you think we could
>> satisfy your goals as well?
>
> This should be satisfactory for most use cases. I will try to support
> efforts toward modernizing the sysfs interface.
>
> Would a character interface to gpiolib ever be considered?

I like the character interface idea actually.

/dev/gpiochip0
/dev/gpiochip1
(...)

Then ioctl() operations to do all the magic to figure out what GPIOs
are there and how to read/write them etc. To me this reflects the
system properly and gives all kind of freedom to manipulate the
GPIOs with efficient context switches. Plus we can deliberately
avoid including any GPIO numbers anywhere, just allow names
and nothing else.

But I'm no userspace/kernelspace expert, let's hear what
the linux-api mailing list has to say.

Yours,
Linus Walleij
