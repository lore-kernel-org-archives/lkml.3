Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbaKTNMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:12:44 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:62770 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaKTNMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:12:42 -0500
MIME-Version: 1.0
In-Reply-To: <546DD87B.3080806@ti.com>
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com>
	<1709760.E0jX3Myv0h@wuerfel>
	<546C7FDD.7030906@ti.com>
	<2900095.WIocOu7ue2@wuerfel>
	<CAPDyKFqeZ3YU2OEN4tCOdcQ0pAho67Q8U_eCEOroG9aS0mp+-Q@mail.gmail.com>
	<546DD87B.3080806@ti.com>
Date: Thu, 20 Nov 2014 14:12:41 +0100
Message-ID: <CAPDyKFrBhZyqozM98_4pPdW0EMFt5W6VX1X7cz6Z=yNhW4vYTA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@kernel.org>,
        ssantosh@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2014 13:03, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
> On 11/20/2014 01:34 PM, Ulf Hansson wrote:
>> On 19 November 2014 14:47, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Wednesday 19 November 2014 13:32:45 Grygorii Strashko wrote:
>>>> On 11/18/2014 09:32 PM, Arnd Bergmann wrote:
>>>>> On Tuesday 18 November 2014 20:54:36 Grygorii Strashko wrote:
>>>>>
>>>>> Have one pmdomain driver in the generic code that knows about clocks,
>>>>> possibly also regulators and pins and just turns them on when needed.
>>>>> You can have a "simple-pmdomain" or "generic-pmdomain" compatible
>>>>> string.
>>>>>
>>>>> I'm a bit surprised that your pmdomain code looks up the clocks from the
>>>>> respective device, rather than know about the clocks itself. There is
>>>>> probably a good reason for this, but I don't see it yet.
>>>>
>>>> The keystone 2 uses simple PM schema based on clocks only:
>>>> - clocks enabled -> dev is active
>>>> - clocks disabled -> dev is suspended
>>>>
>>>> To achieve explained above the Generic clock manipulation PM callbacks framework (pm_clk) is used.
>>>> - list of managed clocks is filled for each device (for non-DT case the con_id list
>>>>    is specified by platform code like:
>>>>        .con_ids = { "fck", "master", "slave", NULL },
>>>>          - or -
>>>>        .con_ids = { }, <-- in this case only first clock will be added to pm_clk
>>>>    )
>>
>> According to earlier comments in this thread, device's clocks are
>> split into "functional" and "PM" clocks.
>>
>> If I understand correctly, a typical platform driver will enable it's
>> "functional" clocks during ->probe() and you want the PM domain to
>> take care of the "PM" clocks, when the device changes runtime PM
>> status.
>>
>> How will you describe these different set of device clocks in DT?
>
> True :(  You can dig deeper in the history of this series if you wish.
> - first Geert Uytterhoeven proposed to use CLK_RUNTIME_PM there
>   https://lkml.org/lkml/2014/11/6/319
> - second I proposed to introduce smth. like "clkops-clocks", "pm-clocks" there
>   https://lkml.org/lkml/2014/6/12/436
>  or "fck-clocks"/"opt-clocks" later.
>
> ^failed.
>
> So, this implementation picks up all clocks for each device, which is ok for
> Keystone 2 and, because it's platform specific.
>
>>>
>>> Yes, it would definitely solve the problem that I see with the infrastructure
>>> code that the current version adds into the platform directory.
>>>
>>> The exact binding of course should be reviewed by the pmdomain and
>>> DT maintainers, to ensure that it is done the best possible way, because
>>> I assume we will end up using it a lot, and it would be a shame to get
>>> it slightly wrong.
>>>
>>> One possible variation I can think of would be to just use "simple-pmdomain"
>>> as the compatible string, and use properties in the node itself to decide
>>> what the domain should control, e.g.
>>>
>>>          clk_pmdomain: pmdomain {
>>>                  compatible = "simple-pmdomain";
>>>                  pmdomain-enable-clocks;
>>>                  #power-domain-cells = <0>;
>>>          };
>>>          clk_regulator_pmdomain: pmdomain {
>>>                  compatible = "simple-pmdomain";
>>>                  pmdomain-enable-clocks;
>>>                  pmdomain-enable-regulators;
>>>                  #power-domain-cells = <0>;
>>>          };
>>>
>>> and then have each device link to one of the nodes as the pmdomain.
>>>
>>
>> That's seems like a good approach to me.
>
> Yes, but your previous comment is still actual :(

Agree!

So I really think we need to decide on how to address the split of the
device clocks. Before that's done, I don't think it make sense to add
a "simple-pmdomain" compatible, since it will likely not be that many
SoC that can use it.

So, does anyone have a suggestion on how to deal with the split of the
device clocks into "functional" clocks and into "PM" clocks?

Kind regards
Uffe
