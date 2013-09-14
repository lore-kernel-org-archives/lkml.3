Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3INHJl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 03:09:41 -0400
Received: from 6.mo1.mail-out.ovh.net ([46.105.43.205]:57604 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752404Ab3INHJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 03:09:39 -0400
Message-ID: <52340B68.5020505@overkiz.com>
Date: Sat, 14 Sep 2013 09:08:24 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC PATCH alt 4/4] pinctrl: at91: rework debounce configuration
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com> <1379058813-3489-1-git-send-email-b.brezillon@overkiz.com> <52339479.6030402@wwwdotorg.org>
In-Reply-To: <52339479.6030402@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 871165053619173453
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

Le 14/09/2013 00:40, Stephen Warren a écrit :
> On 09/13/2013 01:53 AM, Boris BREZILLON wrote:
>> AT91 SoCs do not support per pin debounce time configuration.
>> Instead you have to configure a debounce time which will be used for all
>> pins of a given bank (PIOA, PIOB, ...).
>> diff --git a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>> +Optional properties for iomux controller:
>> +- atmel,default-debounce-div: array of debounce divisors (one divisor per bank)
>> +  which describes the debounce timing in use for all pins of a given bank
>> +  configured with the DEBOUNCE option (see the following description).
>> +  Debounce timing is obtained with this formula:
>> +  Tdebounce = 2 * (debouncediv + 1) / Fslowclk
>> +  with Fslowclk = 32KHz
>> +
>>   Required properties for pin configuration node:
>>   - atmel,pins: 4 integers array, represents a group of pins mux and config
>>     setting. The format is atmel,pins = <PIN_BANK PIN_BANK_NUM PERIPH CONFIG>.
>> @@ -91,7 +99,6 @@ DEGLITCH	(1 << 2): indicate this pin need deglitch.
>>   PULL_DOWN	(1 << 3): indicate this pin need a pull down.
>>   DIS_SCHMIT	(1 << 4): indicate this pin need to disable schmit trigger.
>>   DEBOUNCE	(1 << 16): indicate this pin need debounce.
>> -DEBOUNCE_VAL	(0x3fff << 17): debounce val.
> This change would break the DT ABI since it removes a feature that's
> already present.

I missed this point in my cons list.
This won't be an issue for in kernel DT definitions (nobody is currently 
using the
DEBOUCE option), but may be for out-of-tree DT definitions.

> I suppose it's still up to the Atmel maintainers to decide whether this
> is appropriate, or whether the impact to out-of-tree DT files would be
> problematic.
>
> Assuming the DT ABI can be broken, I think I'd prefer to do so, rather
> than take "non-alt" patch 4/4, since a per-pin DEBOUNCE_VAL clearly
> doesn't correctly model the HW, assuming the patch description is
> correct. I don't think arguments re: the generic pinconf debounce
> property hold; if the Linux-specific/internal generic property doesn't
> apply, the DT binding should not be bent to adjust to it, but should
> rather still represent the HW itself.

What about the last point in my list: "reconfigure debounce after startup" ?

Here is an example that may be problematic:

Let's say you have one device using multiple configuration of pins 
("default", "xxx", "yyy").
The "default" config needs a particular debounce time on a given pin and 
the "xxx" and "yyy"
configs need different debounce time on the same pin.

How would you solve this with this patch approach ?


Best Regards,

Boris

