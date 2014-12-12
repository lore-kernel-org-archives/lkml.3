Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967864AbaLLNGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:06:00 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:64222 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967589AbaLLNF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:05:58 -0500
MIME-Version: 1.0
In-Reply-To: <1918116.UxUgDPTmcq@wuerfel>
References: <1418342706-14755-2-git-send-email-rjui@broadcom.com> <1918116.UxUgDPTmcq@wuerfel>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 12 Dec 2014 22:05:37 +0900
Message-ID: <CAAVeFuL2MKRA7YLm_wsyftNy-sxgEYPrmqBm8XTRZQb66YF-qw@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] gpio: Cygnus: define Broadcom Cygnus GPIO binding
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Scott Branden <sbranden@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 9:08 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 11 December 2014 16:05:04 Ray Jui wrote:
>> +
>> +- linux,gpio-base:
>> +    Base GPIO number of this controller
>> +
>>
>
> We've NAK'ed properties like this multiple times before, and it
> doesn't get any better this time. What are you trying to achieve
> here?

I am to blame for suggesting using this property to Ray, and I am
fully aware that this has been rejected before, but look at what
people came with recently to palliate the lack of control over the
GPIO number space for DT platforms:

http://www.spinics.net/lists/arm-kernel/msg384847.html
https://lkml.org/lkml/2014/12/10/133

Right now GPIO numbering for platforms using DT is a very inconsistent
process, subject to change by the simple action of adjusting the value
of ARCH_NR_GPIOS (which we did recently, btw), adding a new GPIO
controller, or changing the probe order of devices. For users of the
integer or sysfs interfaces, this results in GPIO numbers that change,
and drivers and/or user-space programs that behave incorrectly.
Ironically, the only way to have consistent numbers is to use the old
platform files, where you can specify the base number of a gpio_chip.

DT is actually probably not such a bad place to provide consistency in
GPIO numbering. It has a global vision of the system layout, including
all GPIO controllers and the number of GPIOs they include, and thus
can make informed decisions. It provides a consistent result
regardless of probe order. And allowing it to assign GPIO bases to
controllers will free us from the nonsensical dependency of some
arbitrary upper-bound for GPIO numbers that ARCH_NR_GPIOS imposes on
us. Also about ARCH_NR_GPIOS, the plan is to eventually remove it
since we don't need it anymore after the removal of the global
gpio_descs array. This will again interfere with the numbering of GPIO
chips that do not have a base number provided.

Note that I don't really like this, either - but the problem is the
GPIO integer interface. Until everyone has upgraded to gpiod and we
have a replacement for the current sysfs interface (this will take a
while) we have to cope with this. This issue has been bothering users
for years, so this time I'd like to try and solve it the less ugly
way. If there is a better solution, of course I'm all for it.
