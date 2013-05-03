Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566Ab3ECMXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:23:52 -0400
Received: from multi.imgtec.com ([194.200.65.239]:1119 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab3ECMXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:23:51 -0400
Message-ID: <5183AC54.30503@imgtec.com>
Date: Fri, 3 May 2013 13:23:48 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 5/8] pinctrl-tz1090: add TZ1090 pinctrl driver
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com> <1366727607-27444-6-git-send-email-james.hogan@imgtec.com> <CACRpkdbYwDvF=gNurLzc+wE0BYpoqog7sPdRTY59BGS7yn3n9Q@mail.gmail.com> <517A6B01.5000708@imgtec.com> <CACRpkdYooPNgJuA-fZOiGJV03R_783uAOmR=QgYOahYdHcad9w@mail.gmail.com>
In-Reply-To: <CACRpkdYooPNgJuA-fZOiGJV03R_783uAOmR=QgYOahYdHcad9w@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_05_03_13_23_49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 03/05/13 10:13, Linus Walleij wrote:
> On Fri, Apr 26, 2013 at 1:54 PM, James Hogan <james.hogan@imgtec.com> wrote:
>> On 25/04/13 23:39, Linus Walleij wrote:
>>> On Tue, Apr 23, 2013 at 4:33 PM, James Hogan <james.hogan@imgtec.com> wrote:
>>>> +static const struct cfg_param {
>>>> +       const char *property;
>>>> +       enum tz1090_pinconf_param param;
>>>> +} cfg_params[] = {
>>>> +       {"select",              TZ1090_PINCONF_PARAM_SELECT},
>>>> +       {"pull",                TZ1090_PINCONF_PARAM_PULL},
>>>> +       {"schmitt",             TZ1090_PINCONF_PARAM_SCHMITT},
>>>> +       {"slew-rate",           TZ1090_PINCONF_PARAM_SLEW_RATE},
>>>> +       {"drive-strength",      TZ1090_PINCONF_PARAM_DRIVE_STRENGTH},
>>>> +};
>>>
>>> Almost all exist in <linux/pinctrl/pinconf-generic.h>.
>>>
>>> What is "select"? If you need another config parameter
>>> we can just add it, but explain what it is and we can tell
>>> if it fits.
>>
>> select refers to the registers CR_PADS_GPIO_SELECT{0,1,2} with
>> descriptions like this:
>> Reset values: 0x3fffffc0, 0x3fffffff, 0x3fffffff
>> 29:0    CR_PADS_GPIO_SEL0       GPIO select (1 bit per GPIO pin)
>>                                 0 = serial interface
>>                                 1 = GPIO interface
>>                                 [29] SCB1_SCLK
>>                                 (etc)
>>
>> PARAM_GPIO may be a better name (select seems to have just stuck from
>> when the original gpio driver was written 3 years ago), although it
>> should be noted that the gpio system still has to enable it too, so it's
>> really about taking it out of the "serial interface" so that the
>> connected SoC peripheral cannot mess with it (1) by default (2) if it's
>> not connected to what the peripheral would expect, e.g. controlling
>> board power!
> 
> The GPIO select should not be visible to the outside like this,
> as it is a particular bit that should only be set on request from the
> GPIO framework.
> 
> If what you need is to set the pin into "GPIO mode" to drive it
> to some default state then from pinconf-generic.h you should use
> one of the existing defines like PIN_CONFIG_OUTPUT
> to actively drive it to high or low as default, or
> PIN_CONFIG_BIAS_HIGH_IMPEDANCE for some default
> GPIO input mode.
> 
> Read the new section named "GPIO mode pitfalls" in
> Documentation/pinctrl.txt

Thanks, that was interesting. I've had a think about this (and done some
experiments with a multimeter), and the problem is these generic
pinconfs already have meanings which don't match what the SELECT
register does. For example, having a pin be tristate and not controlled
by the peripheral, and having it tristate as far as the gpio hardware is
concerned (e.g. no pull-up) but still controlled by the peripheral, are
two very different things that need disambiguation.

I think what it comes down to as far as pinctrl is concerned is that the
SELECT registers enable/disable peripheral muxes on a per-pin basis.
Therefore perhaps it makes best sense to just have a custom/generic
pinconf PIN_CONFIG_PERIPHERAL_ENABLE/"peripheral=<1>;" to enable
peripheral muxing in the first place (sets SELECT=0), and require it to
be set on all individual pins that need it (i.e. don't automatically set
SELECT=0 on all pins in a group when the mux is enabled). What do you think?

Thanks
James

