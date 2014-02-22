Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960AbaBVLUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 06:20:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbaBVLT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 06:19:57 -0500
Message-ID: <530887AB.1030805@redhat.com>
Date: Sat, 22 Feb 2014 12:19:07 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: =?ISO-8859-1?Q?David_Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 4/8] ARM: sunxi: Add driver for SD/MMC hosts found
 on Allwinner sunxi SoCs
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch> <20140217100234.15040.84232.stgit@pagira.o2s.ch> <20140218153731.GK3142@lukather> <5303C751.5090809@redhat.com> <20140219094615.GT3142@lukather> <5304A042.7090903@redhat.com> <20140222083128.GH3931@lukather>
In-Reply-To: <20140222083128.GH3931@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/22/2014 09:31 AM, Maxime Ripard wrote:

<snip>

>>>>> This should be before the registration. Otherwise, you're racy.
>>>>
>>>> Nope, we only need this to get the data on sunxi_mmc_remove,
>>>> everywhere else the data is found through the mmc-host struct.
>>>
>>> Still, if anyone makes a following patch using the platform_device
>>> for some reason, we will have a race condition, without any way to
>>> notice it.
>>>
>>> Plus, you're doing all the other bits of initialization of your
>>> structures much earlier, why not be consistent and having all of
>>> them at the same place?
>>
>> Most platform drivers I've worked on do platform_set_drvdata as late
>> as possible, so that the drvdata does not get set and never cleared
>> in error paths.
>
> You don't actually have to clear it,

Erm, yes and no, you used to have to manually clear it, so as to not
leave a dangling pointer in there, which may confuse things later.

But since a few kernel releases, the driver core will explicitly
clear it on probe failure, since many many drivers got this wrong.
I know this because I wrote the driver core patch doing the clearing :)

So in drivers which used to get it right, you will see the
platform_set_drvdata call quite late and it being so late
in the sunxi-mmc.c driver is old habits dying hard.

But you're right that this is no longer needed, still I see little
reason to move it up, but if you really want it to be moved up,
I'm fine with that.

> and some frameworks actually require you to call dev_set_drvdata before registration, so that
> statement looks quite odd to me.

And the proper thing to do when using those frameworks was to
manually clear drvdata again on probe failure. Anyways this is
all handled in the driver core now, so this whole discussion
is moot anyways. I was merely trying to explain where my
preference for doing the dev_set_drvdata call as late as
possible comes from.

Regards,

Hans
