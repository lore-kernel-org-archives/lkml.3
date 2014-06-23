Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaFWWqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:46:30 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:52737 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaFWWq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:46:27 -0400
MIME-Version: 1.0
In-Reply-To: <53A8AAC9.8030407@gmail.com>
References: <1403155273-1057-1-git-send-email-dianders@chromium.org>
	<7h8uosyc3k.fsf@paris.lan>
	<CAD=FV=XxNVmF+N5HF4SnZoJRJvkSUkpEx6ct4v2gtmAQ9n28-Q@mail.gmail.com>
	<7hwqcbs166.fsf@paris.lan>
	<CAD=FV=Uz9O0i2gmuk2+BHa-Tksvyxv0+MTi2UEjVREAMNCK7Ug@mail.gmail.com>
	<7h7g4brx6w.fsf@paris.lan>
	<CAD=FV=VmPMf6tCNmKJ1o5J7PyAXoU8fb6+s+Fkv18FH2WaQp7A@mail.gmail.com>
	<53A4CADA.4030002@gmail.com>
	<CAD=FV=VkxA01eEFiXSp+c+GDuVJi7TctAdnyrMggk1gRw6BStQ@mail.gmail.com>
	<7ha993p8v4.fsf@paris.lan>
	<CAD=FV=U0P2kyfnxdU2E1Gm8TdD_cFd6brmtQ7-gpajNJuKmWSA@mail.gmail.com>
	<53A8AAC9.8030407@gmail.com>
Date: Mon, 23 Jun 2014 15:46:26 -0700
X-Google-Sender-Auth: WhFsQTj3oDjhPx6SAnxgj4a0o6g
Message-ID: <CAD=FV=WzHrqc3G-1gXDjWjY5eL1gOHEpnv8ETXJp2mBfJybJqg@mail.gmail.com>
Subject: Re: [PATCH] i2c: exynos5: Properly use the "noirq" variants of suspend/resume
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Kevin Hilman <khilman@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        naveen krishna <ch.naveen@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Simon Glass <sjg@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Mon, Jun 23, 2014 at 3:31 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>
>
> On 24.06.2014 00:27, Doug Anderson wrote:
>> Kevin,
>>
>> On Mon, Jun 23, 2014 at 3:19 PM, Kevin Hilman <khilman@linaro.org> wrote:
>>> Doug Anderson <dianders@chromium.org> writes:
>>>
>>> [...]
>>>
>>>> On Fri, Jun 20, 2014 at 4:59 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>>>>>
>>>>> I'm not sure noirq is going to work correctly, at least not with current
>>>>> callbacks. I can see a call to clk_prepare_enable() there which needs to
>>>>> acquire a mutex.
>>>>
>>>> Nice catch, thanks!  :)
>>>>
>>>> OK, looking at that now.  Interestingly this doesn't seem to cause us
>>>> problems in our ChromeOS 3.8 tree.  I just tried enabling:
>>>>   CONFIG_DEBUG_ATOMIC_SLEEP=y
>>>>
>>>> ...and confirmed that I got it on right:
>>>>
>>>> # zgrep -i atomic /proc/config.gz
>>>> CONFIG_DEBUG_ATOMIC_SLEEP=y
>>>>
>>>> I can suspend/resume with no problems.  My bet is that it works fine because:
>>>>
>>>> * resume_noirq is not considered "atomic" in the sense enforced by
>>>> CONFIG_DEBUG_ATOMIC_SLEEP (at least not in 3.8--I haven't tried on
>>>> ToT)
>>>
>>> The reason is because "noirq" in the suspend/resume path actually means
>>> no *device* IRQs for that specific device.
>>>
>>> It's often assumed that the "noirq" callbacks are called with *all*
>>> interrupts disabled, but that's not the case.  Only the IRQs for that
>>> specific device are disabled when its noirq callbacks run.
>>
>> Ah, so even with my fix of moving to noirq we could still be broken if
>> the system decided to enable interrupts for the device before the i2c
>> controller get resumed then we'd still be SOL.
>>
>> ...oh, but if it matches probe order then maybe we're guaranteed for
>> that not to happen?  We know that we will probe the i2c bus before the
>> devices on it, right?
>
> If the mentioned device is a child of the I2C controller then the
> parent-child relation determines the order. Otherwise (e.g. another,
> non-I2C interrupt source that just triggers some operation on an I2C
> device like voltage regulator) we're doomed. ;)

Wow, that would be seriously screwed up.

OK, so to summarize my current plans: I won't spin this patch and we
can see what Wolfram thinks.  It may not be as beautiful as Kevin's
suggestion to use Runtime PM but I also don't think it's insane.
...and I've got a request in to Samsung to use Runtime PM in the long
run.

If anyone at Samsung working on suspend/resume on exynos5420-pit or
exynos5800-pi wants to add their Tested-by (or bug reports) I'm sure
that would be appreciated.

-Doug
