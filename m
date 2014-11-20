Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbaKTPct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:32:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54369 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbaKTPcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:32:47 -0500
Message-ID: <546E0970.5090301@ti.com>
Date: Thu, 20 Nov 2014 17:32:00 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@kernel.org>,
        <ssantosh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com>	<1709760.E0jX3Myv0h@wuerfel>	<546C7FDD.7030906@ti.com>	<2900095.WIocOu7ue2@wuerfel>	<CAPDyKFqeZ3YU2OEN4tCOdcQ0pAho67Q8U_eCEOroG9aS0mp+-Q@mail.gmail.com>	<546DD87B.3080806@ti.com>	<CAPDyKFrBhZyqozM98_4pPdW0EMFt5W6VX1X7cz6Z=yNhW4vYTA@mail.gmail.com> <CAMuHMdWtHT7QX3Kpa-GCLa49ToGODwjnNVgfxDzJzcM-FU1ffg@mail.gmail.com>
In-Reply-To: <CAMuHMdWtHT7QX3Kpa-GCLa49ToGODwjnNVgfxDzJzcM-FU1ffg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 03:32 PM, Geert Uytterhoeven wrote:
> On Thu, Nov 20, 2014 at 2:12 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>>>> According to earlier comments in this thread, device's clocks are
>>>> split into "functional" and "PM" clocks.
>>>>
>>>> If I understand correctly, a typical platform driver will enable it's
>>>> "functional" clocks during ->probe() and you want the PM domain to
>>>> take care of the "PM" clocks, when the device changes runtime PM
>>>> status.
>>>>
>>>> How will you describe these different set of device clocks in DT?
>>>
>>> True :(  You can dig deeper in the history of this series if you wish.
>>> - first Geert Uytterhoeven proposed to use CLK_RUNTIME_PM there
>>>    https://lkml.org/lkml/2014/11/6/319
>>> - second I proposed to introduce smth. like "clkops-clocks", "pm-clocks" there
>>>    https://lkml.org/lkml/2014/6/12/436
>>>   or "fck-clocks"/"opt-clocks" later.
>>>
>>> ^failed.
>>>
>>> So, this implementation picks up all clocks for each device, which is ok for
>>> Keystone 2 and, because it's platform specific.
>>>
>>>>>
>>>>> Yes, it would definitely solve the problem that I see with the infrastructure
>>>>> code that the current version adds into the platform directory.
>>>>>
>>>>> The exact binding of course should be reviewed by the pmdomain and
>>>>> DT maintainers, to ensure that it is done the best possible way, because
>>>>> I assume we will end up using it a lot, and it would be a shame to get
>>>>> it slightly wrong.
>>>>>
>>>>> One possible variation I can think of would be to just use "simple-pmdomain"
>>>>> as the compatible string, and use properties in the node itself to decide
>>>>> what the domain should control, e.g.
>>>>>
>>>>>           clk_pmdomain: pmdomain {
>>>>>                   compatible = "simple-pmdomain";
>>>>>                   pmdomain-enable-clocks;
>>>>>                   #power-domain-cells = <0>;
>>>>>           };
>>>>>           clk_regulator_pmdomain: pmdomain {
>>>>>                   compatible = "simple-pmdomain";
>>>>>                   pmdomain-enable-clocks;
>>>>>                   pmdomain-enable-regulators;
>>>>>                   #power-domain-cells = <0>;
>>>>>           };
>>>>>
>>>>> and then have each device link to one of the nodes as the pmdomain.
>>>>>
>>>>
>>>> That's seems like a good approach to me.
>>>
>>> Yes, but your previous comment is still actual :(
>>
>> Agree!
>>
>> So I really think we need to decide on how to address the split of the
>> device clocks. Before that's done, I don't think it make sense to add
>> a "simple-pmdomain" compatible, since it will likely not be that many
>> SoC that can use it.
>>
>> So, does anyone have a suggestion on how to deal with the split of the
>> device clocks into "functional" clocks and into "PM" clocks?

Would it be better to say "functional" and "optional"? In my opinion
"PM" == "functional". Also, such clock's separation is used in TRM/DM/UMs on HW.

> 
> That's indeed the tricky part.
> 
> On shmobile, we just use the "NULL" clock, i.e. the first clock, for historical
> reasons.
> 
> Using clock-names (e.g. "fck" and "pm") will conflict with existing bindings
> for devices that already mandate specific clock names.
> 
> As the clock being a "PM" clock is a property of the clock provider
> (at last on shmobile), I originally came up with not handling it in DT,
> but advertising it in the clock provider driver:
> 
>>> - first Geert Uytterhoeven proposed to use CLK_RUNTIME_PM there
>>>    https://lkml.org/lkml/2014/11/6/319

As I mentioned previously I don't like it, because in many cases one driver is used for
all/set_of clocks which support gating function. As result, some sort of tables will
need to be created and maintained in code by these drivers per each SoC
(or even per each SoC revision) for identification that clock is "PM clock".

Additional points are : both parent and child clock can be gated; one clock
can be used by two devices and be "functional" and "optional" at once :)

regards,
-grygorii

