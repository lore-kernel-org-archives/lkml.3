Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaKYNbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:31:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45548 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbaKYNbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:31:08 -0500
Message-ID: <5474846C.2000308@ti.com>
Date: Tue, 25 Nov 2014 15:30:20 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kevin Hilman <khilman@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Rob Herring" <robh+dt@kernel.org>, <ssantosh@kernel.org>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <15074721.IbfeeI3ajE@wuerfel> <54746349.3000306@ti.com> <2301239.aDOlWg3gEs@wuerfel>
In-Reply-To: <2301239.aDOlWg3gEs@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 02:09 PM, Arnd Bergmann wrote:
> On Tuesday 25 November 2014 13:08:57 Grygorii Strashko wrote:
>> On 11/25/2014 12:33 PM, Arnd Bergmann wrote:
>>> On Monday 24 November 2014 22:44:06 Mike Turquette wrote:
>>>> Quoting Arnd Bergmann (2014-11-24 02:50:28)
>>>>>
>>>
>>> I'm not sure I even understand what you intended the example to look
>>> like, it does't parse
>>>
>>> My point above was completely different, the suggestion I made was
>>> to not classify the clocks in DT at all, but to leave it all in
>>> the client driver.
>>
>> I slept with this idea  From one side it sounds good. Pls, Correct me if I'm wrong:
>> - there still will be "simple-pmdomain" and all devices will be attached to it by
>>     default (or as specified in DT power-domains = <&simple_pmdomain>;);
> 
> I would assume only devices that set "power-domains = <&simple_pmdomain>"
> 
>> - drivers will use smth. like pm_clk_remove() to remove optional clocks from pm_clk;
> 
> Right. Regarding the naming of the function, I would pick something other
> than remove, since the main purpose is not to have that clock abandoned
> by the pm-domain code (this is still a side-effect), but to have the
> clock put under control of the driver itself.

pm_clk_remove() is implemented already.

> 
> It might be possible to do this implicitly if the driver calls clk_get(),
> basically doing clk_get() (or another call if necessary) would prevent the
> simple pmdomain from turning it off during suspend.

Unfortunately, clk_get() will not work, because drivers still need to use it
to get functional clocks even if they are not going to control them explicitly.
For example, if it need to know clock's rate.

> 
>>  From another side:
>> - drivers will get dependency from pm_clk;
> 
> There are three cases here:
> 
> - A device that is always used with a pm-domain, the driver doesn't
>    have to worry about it but do need the dependency on having the
>    simple-pmdomain code enabled.
> 
> - A device that may or may not have clocks, but if it has them, they
>    are managed through a pm-domain. In this case, it's platform dependent
>    whether we have the dependency. We may want to prevent the device from
>    being probed if a power-domain property is present but no driver
>    for the domain.

Seems, solved by PM core - .probe() will be deferred forever if pm-domain is
not ready.

> 
> - A device that uses the pm-domain on some machines but not on others:
>    this is a bit tricky, because the driver will still have to know
>    about all the clocks, although we could choose not to turn off the
>    clocks during suspend if the power-domain is not set.
> 
>> - HW limitations can't be taken into account - it's possible that some clocks should
>>    not be enabled until it's allowed. And only driver know when it's allowed.
>>    Otherwise, HW state may become unspecified or wrong output can be generated.
> 
> Correct: if you have a device that you don't want to be handled by a simple
> pm-domain, then you have to connect it to a different pm-domain, e.g. one that
> manages a fixed set of clocks itself.

regards,
-grygorii
