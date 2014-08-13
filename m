Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaHMLbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:31:51 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38803 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaHMLbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:31:50 -0400
Message-ID: <53EB4CA0.3010006@collabora.co.uk>
Date: Wed, 13 Aug 2014 13:31:44 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] ARM: dts: Add tps65090 FETs constraints
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk> <1407861868-20097-7-git-send-email-javier.martinez@collabora.co.uk> <20140812172552.GU17528@sirena.org.uk> <53EA61B9.2070805@collabora.co.uk> <20140812212757.GY17528@sirena.org.uk>
In-Reply-To: <20140812212757.GY17528@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 08/12/2014 11:27 PM, Mark Brown wrote:
> On Tue, Aug 12, 2014 at 08:49:29PM +0200, Javier Martinez Canillas wrote:
> 
>> So, is adding these voltages ranges (the design limits) in the Peach Pit DTS
>> file directly an acceptable solution? Basically what my previous patch [0] did.
> 
>> That matches what is in the board schematic so I assume that it's safe to use
>> these voltage ranges for that machine. If so I'll drop this series and repost
>> that patch fixing the typo error and commit message pointed by Doug that were
>> already addressed in $subject.
> 
> Well, I think the question is if you understand where those numbers come
> from and if they make sense.  I've not seen the schematic for the board
> so I can't comment but it is quite unusual to see ranges listed for so
> many supplies, for things like SD it's obviously normal but things like
> video_mid are a bit more surprising.  Does anything actually vary those
> voltages?
> 

You are right, in fact even the voltage for the SD supply (tps65090 fet4) does
not change but still their constraints have to be defined, since it is used as a
vmmc-supply and the series "Adding UHS support for dw_mmc driver" [0] calls
mmc_regulator_get_ocrmask()/mmc_regulator_set_ocr() for mmc->supply.vmmc.

For fixed regulators (like fet4), mmc_regulator_set_ocr() just skips varying the
regulator voltage but still expects to be able to obtain its voltage.

Since the FET is just a switch and doesn't have an output voltage, the regulator
core gets its parent supply voltage but regulator_list_voltge() [1] checks that
the obtained parent voltage is between the child regulator constraints.

So in this particular case it makes sense to compare that the parent voltage is
between the (design limits) voltage ranges for the FET but I agree that it may
not make sense on other boards.

Since I needed to add the ranges for fet4 I (wrongly) thought that it would make
sense to add the ranges for all the other FETs in case other boards had a
similar need. But now I understand your concerns about this series so I'll drop
it and just post a patch that adds to the Peach Pit and Pi DTS, the constraints
for the fet4 used as vmmc-supply instead of pretending that it's a common setup.

> The change where you fix up the supply mappings still makes sense of
> course.
>

Good to know, again thanks a lot for your feedback and explanations.

Best regards,
Javier

[0]: http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/265657.html
[1]:
https://git.kernel.org/cgit/linux/kernel/git/broonie/regulator.git/tree/drivers/regulator/core.c?h=for-next#n2209
