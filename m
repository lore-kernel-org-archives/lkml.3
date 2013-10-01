Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3JAU7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:59:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36671 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3JAU7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:59:48 -0400
Message-ID: <524B37BF.2090300@wwwdotorg.org>
Date: Tue, 01 Oct 2013 14:59:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] pwm-backlight: Use an optional power supply
References: <1379972467-11243-1-git-send-email-treding@nvidia.com> <1379972467-11243-10-git-send-email-treding@nvidia.com> <524B17ED.1080806@wwwdotorg.org> <20131001205310.GD9201@ulmo.nvidia.com>
In-Reply-To: <20131001205310.GD9201@ulmo.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 02:53 PM, Thierry Reding wrote:
> On Tue, Oct 01, 2013 at 12:43:57PM -0600, Stephen Warren wrote:
>> On 09/23/2013 03:41 PM, Thierry Reding wrote:
>>> Many backlights require a power supply to work properly. This
>>> commit uses a power-supply regulator, if available, to power up
>>> and power down the panel.
>> 
>> I think that all backlights require a power supply, albeit the
>> supply may not be SW-controllable. Hence, shouldn't the regulator
>> be mandatory in the binding, yet the driver be defensively coded
>> such that if one isn't specified, the driver continues to work?
> 
> That has already changed in my local version of this patch.
> 
>>> diff --git a/drivers/video/backlight/pwm_bl.c
>>> b/drivers/video/backlight/pwm_bl.c
>> 
>>> @@ -253,6 +264,16 @@ static int pwm_backlight_probe(struct
>>> platform_device *pdev) } }
>>> 
>>> +	pb->power_supply = devm_regulator_get_optional(&pdev->dev,
>>> "power");
>> 
>> ... so I think that should be devm_regulator_get(), since the
>> regulator isn't really optional.
>> 
>>> +	if (IS_ERR(pb->power_supply)) { +		if
>>> (PTR_ERR(pb->power_supply) != -ENODEV) { +			ret =
>>> PTR_ERR(pb->power_supply); +			goto err_gpio; +		} + +
>>> pb->power_supply = NULL;
>> 
>> If devm_regulator_get_optional() returns an error value or a
>> valid value, then I don't think that this driver should transmute
>> error values into NULL; NULL might be a perfectly valid regulator
>> value. Related, I think the if (pb->power_supply) tests should be
>> replaced with if (!IS_ERR(pb->power_supply)) instead.
> 
> All of that is already done in my local tree. This actually turns
> out to work rather smoothly with the new support for optional
> regulators. The regulator core will give you a dummy regulator
> (assuming it's there physically but hasn't been wired up in
> software) that's always on, so the driver doesn't even have to
> special case it anymore.

OK, hopefully it (the regulator core) complains about the missing DT
property though; I assume you're using regulator_get() not
regulator_get_optional(), since the supply really is not optional.
