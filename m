Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaACQjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:39:42 -0500
Received: from mo4.mail-out.ovh.net ([178.32.228.4]:46971 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaACQjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:39:40 -0500
X-Greylist: delayed 71087 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jan 2014 11:39:40 EST
MIME-Version: 1.0
In-Reply-To: <CAAVeFuL+rbccJTj+Zr=nXwOq1x8p1FQ1R=-_mZ8pPxHQ_g03wA@mail.gmail.com>
References: <1387239745-2890-1-git-send-email-jjhiblot@traphandler.com>
	<CAAVeFuKAGfnnsbtBg=zfmciyMdZHgrX_EpecqPjG=oO6rZdWag@mail.gmail.com>
	<CACh+v5MUsYW-=qaVubzt8CWRGxibKDB3PjMZ6AaeDYgeTNzONA@mail.gmail.com>
	<CAAVeFuJ=s8e8g5LG2CVAkS3guj-HRUYrwKxywFxq36sNpAjQGQ@mail.gmail.com>
	<CACh+v5NhUzoRc4YuPJdSia21XTDh8tLo=oBZyo7Re7deOTjUdA@mail.gmail.com>
	<CAAVeFuL+rbccJTj+Zr=nXwOq1x8p1FQ1R=-_mZ8pPxHQ_g03wA@mail.gmail.com>
Date: Fri, 3 Jan 2014 17:39:34 +0100
Message-ID: <CACh+v5Mu0CciYZwDpZBJV+R8CYtnQymffDGJp94k8jQ54EKPDw@mail.gmail.com>
Subject: Re: [PATCH] Tracing events with GPIOs
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 16697940044456482840
X-Ovh-Remote: 209.85.220.44 (mail-pa0-f44.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/3 Alexandre Courbot <gnurou@gmail.com>:
> On Fri, Dec 20, 2013 at 5:40 PM, Jean-Jacques Hiblot
> <jjhiblot@traphandler.com> wrote:
>> 2013/12/20 Alexandre Courbot <gnurou@gmail.com>:
>>> On Thu, Dec 19, 2013 at 8:38 PM, Jean-Jacques Hiblot
>>> <jjhiblot@traphandler.com> wrote:
>>>> 2013/12/19 Alexandre Courbot <gnurou@gmail.com>:
>>>>> The problems I can see so far:
>>>>>
>>>>> - Using gpiod, GPIOs are not specified as integers, but are typically
>>>>> mapped to a given (device, function) pair (device can be NULL) using
>>>>> device tree/platform data/ACPI and obtained by the corresponding
>>>>> device driver through gpiod_get(). You would need to find a different
>>>>> way to specify GPIOs, maybe using the gpio_chip's label and the GPIO
>>>>> hardware number.
>>>>>
>>>>> - Even if you do so, there is currently no way to arbitrarily obtain a
>>>>> GPIO that has not been explicitly mapped to a (device, function), and
>>>>> IIUC you need to specify the tracing GPIO freely from user-space. This
>>>>> hints that we will need to add a function that is sensibly the same as
>>>>> gpio_request_one() to the gpiod API, but I wonder if that does not
>>>>> defeats the purpose somehow.
>>>>
>>>> This is something I was wondering about for another reason. In many
>>>> cases the GPIOs that are physically available for probing will be
>>>> limited to the GPIOs already assigned a function (backlight control
>>>> for example), others are usually not routed except in eval boards or
>>>> early prototypes. And consequently those GPIOs will be requested by a
>>>> driver long before a probe is set.
>>>> It would be nice not to have to remove the driver to be able to use
>>>> this GPIO  as a probe. Maybe a gpiod_steal() interface and a flag
>>>> indicating that the GPIO can be safely stolen?
>>>
>>> Mmm an explicit way to hijack a GPIO does not sound very safe. Do you
>>> have concrete cases where you need to do so? I guess most boards you
>>> may want to use this patch with would have at least some spare GPIOs
>>> with pins somewhere on the board for this kind of purpose.
>> It's not always true. There are quite a few platforms where GPIOs is a
>> scarce resource (ppc for example). For example, the board I'm working
>> on at the moment is built around a APM powerpc which has only 16
>> GPIOs. Of those 16 GPIOS, some are not routed and most of the others
>> are hidden by the shielding so that I can probe only those that go to
>> external connectors.
>> IMHO it's probably the case for most of the boards that go into a
>> final product where EMI and space constraints are tight.
>> But I agree that's not safe. I thought that maybe a flag indicating
>> when it is safe would help (on my board that would be : ok to use the
>> GPIO that turns on or off the backlight, not ok to use the GPIO that
>> controls the power supply)
>
> Rather than a flag per GPIO or board (my definition of "safe" is
> rather strict ; I'd consider being able to mess with the backlight as
> unsafe), I think I'd be more comfortable with having this as a kernel
> config option, defaulting to 'n', and clearly stating that this can
> potentially allow any GPIO to be hijacked (which is, apart for the
> last point, what you already did). That way people can make an
> informed decision about whether to enable it or not (disabled for
> distro kernels, enabled for the occasional hacker who wants to use
> this feature).
>
> But before doing this, I'd like to make sure we explore every
> possibility to make this safer by design.
I agree and to be honest I'm not comfortable with the hijacker's way.
Maybe I should just stick to the proper way of requesting a GPIO. When
this feature is used,  it'll not be in the field after production but
during the development when building a new kernel is not really an
issue.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-gpio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
