Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3KFRAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:00:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56171 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3KFRA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:00:28 -0500
Message-ID: <527A75A6.5010904@wwwdotorg.org>
Date: Wed, 06 Nov 2013 10:00:22 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sherman Yin <syin@broadcom.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
References: <1380846199-12829-1-git-send-email-syin@broadcom.com> <051069C10411E24D9749790C498526FA1BE0B7D7@SJEXCHMB12.corp.ad.broadcom.com> <CACRpkdYSLxp2M4HghcUdjEYGh-UQ+DaiCGp6yee+Qds6DR9poA@mail.gmail.com> <201311050026.56321.heiko@sntech.de> <527835FE.2030102@wwwdotorg.org> <5279A319.5060701@broadcom.com>
In-Reply-To: <5279A319.5060701@broadcom.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 07:02 PM, Sherman Yin wrote:
> On 13-11-04 04:04 PM, Stephen Warren wrote:
>> On 11/04/2013 04:26 PM, Heiko Stübner wrote:
>>
>>> I remember we had a discussion about how things like bias-disable
>>> explicitly
>>> shouldn't have a value, when they are represented in the list-format:
>>>
>>>         pcfg_pull_none: pcfg_pull_none {
>>>             bias-disable;
>>>         };
>>>
>>> so a bias-disable = <1> was explicitly "forbidden" [for a lack of a
>>> better
>>> word]. And it was similar for other options, the parameter not meant
>>> to be
>>> indicating if they are active but really only setting the "strength"
>>> or so.
>>
>> Pure Boolean values should be represented as a valueless property. If
>> the property is present, the value is true, otherwise false.
>>
>> However, pinctrl bindings often don't represent Boolean values, but
>> rather tri-states, with the following values:
>>
>> * Don't touch this configuration option at all (missing)
>> * Enable the option (<1>)
>> * Disable the option (<0>)
>>
>> The reason for using tri-states being that you might want to write:
>>
>> xxx1 {
>>      pins = <PINA>, <PINB>, <PINC>;
>>      function = <...>;
>>      // this node doesn't affect pullup
>> }
>> xxx2 {
>>      pins = <PINA>, <PINB>;
>>      // this node doesn't affect function
>>      pull-up = <1>; // change, and enable
>> }
>> xxx3 {
>>      pins = <PINAC>;
>>      // this node doesn't affect function
>>      pull-up = <0>; // change, and disable
>> }
> 
> If I understand correctly, in Stephen's example, if a certain driver
> wants to configure PINA PINB and PINC, the pin configuration nodes
> "xxx1", "xxx2", and "xxx3" will all have to be selected for the
> particular pin state.

You probably don't want to reference the individual xxx1/2/3 nodes in
the client pinctrl properties, but instead wrap them in a higher-level
node that represents the whole pinctrl state. Then, the client pinctrl
properties can reference just that single parent node, instead of many
small nodes. In other words:

pinctrl@... {
	...
	sx: state_xxx {
		xxx1 { ... };
		xxx2 { ... };
		xxx3 { ... };
	};
	sy: state_yyy {
		yyy1 { ... };
		yyy2 { ... };
	};
}

some_client@... {
	...
	pinctrl-names = "default";
	pinctrl-0 = <&sx>;
};

other_client@... {
	...
	pinctrl-names = "default";
	pinctrl-0 = <&sy>;
};

rather than:

pinctrl@... {
	...
	sx1: xxx1 { ... };
	sx2: xxx2 { ... };
	sx3: xxx3 { ... };
	sy1: yyy1 { ... };
	sy2: yyy2 { ... };
}

some_client@... {
	...
	pinctrl-names = "default";
	pinctrl-0 = <&sx1 &sx2 &sx3>;
};

other_client@... {
	...
	pinctrl-names = "default";
	pinctrl-0 = <&sy1 &sy2>;
};

This is exactly how the Tegra pinctrl bindings work for example.


> This works fine.  However, I'm just thinking that
> it would have been easier if we could specify just one node:
> 
> xxx {
>     pins = <PINA>, <PINB>, <PINC>;
>     function = <...>;
>     pull-up = <1 1 0>;
> }
> 
> This "feature" seems a bit more concise to me and is what I did for my
> original pinctrl driver.  The only downside is that with this method,
> one cannot specify "don't touch this option for this pin" if the same
> property must provide values for other pins.

The other downside is that if the lists get even slightly long, it get
really hard to match up the entries in the t properties.

