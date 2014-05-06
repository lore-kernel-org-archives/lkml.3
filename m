Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308AbaEFH6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:58:17 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:33016 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934069AbaEFH6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:58:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWLfKcKLORPJ9f-0TLoWM5EfCZ0G5MfxjUiJCRJG555Sg@mail.gmail.com>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
	<1398334403-26181-4-git-send-email-geert+renesas@glider.be>
	<CAPDyKFr02yyhGNncYX2AgBXTA3Sc0AGQcExjtLvQ5QU0_=YJwg@mail.gmail.com>
	<535B130C.1000007@gmail.com>
	<CAPDyKFqG0dV+-y2=t=d3w6_hxWsYi+sOmNdvS6ECPOuoQ61Pmw@mail.gmail.com>
	<CAMuHMdWLfKcKLORPJ9f-0TLoWM5EfCZ0G5MfxjUiJCRJG555Sg@mail.gmail.com>
Date: Tue, 6 May 2014 09:58:13 +0200
Message-ID: <CAPDyKFoqGr=ED3v_yubL8sqcsAy8xxRXhn30pm40=dV1skFEaQ@mail.gmail.com>
Subject: Re: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM
 with the PM core
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-sh list <linux-sh@vger.kernel.org>,
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

On 2 May 2014 16:58, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Ulf, Tomasz,
>
> On Fri, May 2, 2014 at 10:13 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>>>>> +static int of_clk_register(struct device *dev, struct clk *clk)
>>>>> +{
>>>>> +       int error;
>>>>> +
>>>>> +       if (!dev->pm_domain) {
>>>>> +               error = pm_clk_create(dev);
>>>>> +               if (error)
>>>>> +                       return error;
>>>>> +
>>>>> +               dev->pm_domain = &of_clk_pm_domain;
>>>>
>>>>
>>>> I am concerned about how this will work in conjunction with the
>>>> generic power domain.
>>>>
>>>> A device can't reside in more than one pm_domain; thus I think it
>>>> would be better to always use the generic power domain and not have a
>>>> specific one for clocks. Typically the genpd should invoke
>>>> pm_clk_resume|suspend from it's runtime PM callbacks.
>>>
>>> I'm not sure about this. A typical use case would be to gate clocks ASAP and
>>> then wait until device is idle long enough to consider turning off the power
>>> domain worthwhile. Also sometimes we may want to gate the clocks, but
>>> prevent power domain from being powered off to retain hardware state (e.g.
>>> because there is no way to read it and restore later).
>>
>> So, in principle you prefer to have driver's handle clock gating to
>> save power from their runtime PM callbacks, instead of from the power
>> domain, right? Just to clarify, that's my view as well.
>
> If there's both a gate clock and a power domain, and the driver's Runtime PM
> callbacks handle clock gating, who's handling the power domain?

This is my view, not sure everybody agrees :-)

1. If you have a hardware power domain you need to implement a
pm_domain (preferably use the generic power domain).

2. If you don't have a hardware power domain, but still cares about
having a centralized solution for dev_pm_qos - you may use the generic
power domain, since it supports this.

3. If none of the above, you don't need a pm_domain at all.

Kind regards
Ulf Hansson

>
> Gr{oetje,eeting}s,
>
>                         Geert (still trying to fit all pieces of the
> puzzle together)
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
