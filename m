Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaEBINT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 04:13:19 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:44359 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaEBINM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 04:13:12 -0400
MIME-Version: 1.0
In-Reply-To: <535B130C.1000007@gmail.com>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
	<1398334403-26181-4-git-send-email-geert+renesas@glider.be>
	<CAPDyKFr02yyhGNncYX2AgBXTA3Sc0AGQcExjtLvQ5QU0_=YJwg@mail.gmail.com>
	<535B130C.1000007@gmail.com>
Date: Fri, 2 May 2014 10:13:11 +0200
Message-ID: <CAPDyKFqG0dV+-y2=t=d3w6_hxWsYi+sOmNdvS6ECPOuoQ61Pmw@mail.gmail.com>
Subject: Re: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM
 with the PM core
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-sh@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>>
>> Normally I don't think it's a good idea to "automatically" manage
>> clocks from PM core or any other place but from the driver (and
>> possibly the subsystem).
>>
>> The reason is simply that we hide things that normally is supposed to
>> be handled by the driver. Typically a cross SOC driver should work
>> fine both with and without a pm_domain. It should also not rely on
>> CONFIG_PM_RUNTIME.

[Snip]

>>
>>> +static int of_clk_register(struct device *dev, struct clk *clk)
>>> +{
>>> +       int error;
>>> +
>>> +       if (!dev->pm_domain) {
>>> +               error = pm_clk_create(dev);
>>> +               if (error)
>>> +                       return error;
>>> +
>>> +               dev->pm_domain = &of_clk_pm_domain;
>>
>>
>> I am concerned about how this will work in conjunction with the
>> generic power domain.
>>
>> A device can't reside in more than one pm_domain; thus I think it
>> would be better to always use the generic power domain and not have a
>> specific one for clocks. Typically the genpd should invoke
>> pm_clk_resume|suspend from it's runtime PM callbacks.
>
>
> I'm not sure about this. A typical use case would be to gate clocks ASAP and
> then wait until device is idle long enough to consider turning off the power
> domain worthwhile. Also sometimes we may want to gate the clocks, but
> prevent power domain from being powered off to retain hardware state (e.g.
> because there is no way to read it and restore later).

So, in principle you prefer to have driver's handle clock gating to
save power from their runtime PM callbacks, instead of from the power
domain, right? Just to clarify, that's my view as well.

Kind regards
Ulf Hansson

>
> I believe, though, that for devices that are not inside a controllable power
> domain, this might be a good solution.
>
> Best regards,
> Tomasz
