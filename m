Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaKUT36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:29:58 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35266 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaKUT34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:29:56 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        <ssantosh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, mturquette@linaro.org
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com>
	<1709760.E0jX3Myv0h@wuerfel> <546C7FDD.7030906@ti.com>
	<2900095.WIocOu7ue2@wuerfel>
	<CAPDyKFqeZ3YU2OEN4tCOdcQ0pAho67Q8U_eCEOroG9aS0mp+-Q@mail.gmail.com>
	<546DD87B.3080806@ti.com>
	<CAPDyKFrBhZyqozM98_4pPdW0EMFt5W6VX1X7cz6Z=yNhW4vYTA@mail.gmail.com>
	<CAMuHMdWtHT7QX3Kpa-GCLa49ToGODwjnNVgfxDzJzcM-FU1ffg@mail.gmail.com>
	<546E0970.5090301@ti.com> <7hh9xtr5ac.fsf@deeprootsystems.com>
	<CAMuHMdV7zASj8_NtLRir1VubXEKTkq0vBGMXeYXDACu8UC2tZA@mail.gmail.com>
	<7hbno1r1af.fsf@deeprootsystems.com>
	<CAMuHMdVXGPu7x706NxqO3rn3KuRbPbD_ZQsJtDH4Hf31AaRR+Q@mail.gmail.com>
	<7hppchpcfm.fsf@deeprootsystems.com>
	<CAMuHMdU6G35SP-P7bt6RJQk59CrGcKE2XM4N3o8Dv3qxZU7gxA@mail.gmail.com>
	<546F8B39.1080106@ti.com>
Date: Fri, 21 Nov 2014 11:29:53 -0800
In-Reply-To: <546F8B39.1080106@ti.com> (Grygorii Strashko's message of "Fri,
	21 Nov 2014 20:58:01 +0200")
Message-ID: <7hsihcmjwu.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grygorii Strashko <grygorii.strashko@ti.com> writes:

> Hi Kevin,
> On 11/21/2014 10:06 AM, Geert Uytterhoeven wrote:
>> On Fri, Nov 21, 2014 at 2:30 AM, Kevin Hilman <khilman@kernel.org> wrote:
>>> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>>>> On Thu, Nov 20, 2014 at 10:48 PM, Kevin Hilman <khilman@kernel.org> wrote:
>>>>>>> So what exactly are we talking about with "PM" clocks, and why are they
>>>>>>> "special" when it comes to PM domains?  IOW, why are the clocks to be
>>>>>>> managed during PM domain transitions for a given device any different
>>>>>>> than the clocks that need to be managed for a runtime suspend/resume (or
>>>>>>> system suspend/resume) sequence for the same device?
>>>>>>
>>>>>> (Speaking for my case, shmobile)
>>>>>>
>>>>>> They're not. The clocks to be managed during PM domain transitions are the
>>>>>> same as the clocks that need to be managed for a runtime suspend/resume
>>>>>> (or system suspend/resume) sequence.
>>>>>>
>>>>>> The special thing is that this is more a platform than a driver thing: the same
>>>>>> module may have a "PM/functional" clock (that is documented to enable/disable
>>>>>> the module) on one Soc, but noet on another.
>>>>>
>>>>> So why isn't the presence or absence of the clock described in the .dtsi
>>>>> for the SoC instead of being handled by special PM domain logic?
>>>>
>>>> It is. Cfr. the presence/absence of clocks for renesas,rcar-gpio nodes.
>>>
>>> Hmm, OK, Good.
>>>
>>> So now I'm confused about why the PM domain has to do anything special
>>> if the presence/absence of the clocks is already handled by the DT.
>> 
>> Just adding a clock property to a device node in DT doesn't enable the clock
>> automatically, nor make it runtime-managed automatically.
>> Compare this to e.g. pinctrl, where adding pinctrl properties to DT does enable
>> them automatically, without the driver for the device having to care about it.
>> 
>> Drivers interfacing external hardware typically do care about clocks, as they
>> have to program clock generators for the external hardware interface (e.g.
>> driving spi or i2c buses at specific frequencies).
>> 
>> Other random drivers don't care about clocks, so they don't handle them.
>> But as long as they make basic pm_runtime_{enable,get_sync,put}() calls,
>> the (optional) clocks (and hardware PM domains) will "work" fine, if handled
>> by the PM (clock) domain.
>
> Personally, I don't see problems with "functional" clocks.
> The problem, in my opinion, is that we can't specify in DT that some clock is
> "optional", so no one should touch such clock except driver.
> For example:
> Keystone 2 NETCP module has 3 clocks:
> 	clocks = <&papllclk>, <&clkcpgmac>, <&chipclk12>;
> 	clock-names = "clk_pa", "clk_cpgmac", "cpsw_cpts_rft_clk";
>  and CPTS functionality is optional (in general) and can be enabled/disabled.
> Also, usual example is MMC hosts 
> - OMAP hsmmc has "functional" clock "hsmmc1_fclk", and may have
> "optional" clock "mmchsdb_fck". As you may remember, PM runtime
> for OMAP2+ implemented by OMAP PM domain which performs many things,
> but one thing which is done always is enabling/disabling of "fck"
> when get/put() are called.
>
> Actually, pm_clk is very simple case of OMAP PM domain which should only
> handle clocks.
>
> In non-DT case, we have possibility to divide clocks on "fck" and "opt"
> (The way it can be done is not convenient, but it is - .con_id).
>
> For DT-case - no way now. Also, PM domains are not physically present on
> Keystone 2 and GPD was selected as glue layer to integrate DT, pm_clk and
> PM runtime all together (one big-fat-global PM domain :).
>
> So, I was able to find only following way to define "fck" clocks in DT:
> 	clocks = <&papllclk>, <&clkcpgmac>, <&chipclk12>;
> 	clock-names = "clk_pa", "clk_cpgmac", "cpsw_cpts_rft_clk";
> 	fck-clocks = <&papllclk>, <&clkcpgmac>;
> As you can see - this will lead to data duplication in DT (
>
> Any propositions are welcome?

How about you proposed a new (optional) property for the clock bindings
called 'clocks-optional' or something like that.  The clock maintainer
(Mike Turquette, Cc'd) is also very familiar with OMAP and the need for
these different kinds of clocks.

Kevin

