Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3KGWCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:02:40 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2245 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab3KGWCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:02:34 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <527C0DB6.5060303@broadcom.com>
Date: Thu, 7 Nov 2013 14:01:26 -0800
From: "Sherman Yin" <syin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-Version: 1.0
To: "Stephen Warren" <swarren@wwwdotorg.org>,
        "=?ISO-8859-1?Q?Heiko_St=FCb?= =?ISO-8859-1?Q?ner?=" 
	<heiko@sntech.de>,
        "Linus Walleij" <linus.walleij@linaro.org>
cc: "Laxman Dewangan" <ldewangan@nvidia.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Christian Daudt" <bcm@fixthebug.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "Rob Landley" <rob@landley.net>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
 <051069C10411E24D9749790C498526FA1BE0B7D7@SJEXCHMB12.corp.ad.broadcom.com>
 <CACRpkdYSLxp2M4HghcUdjEYGh-UQ+DaiCGp6yee+Qds6DR9poA@mail.gmail.com>
 <201311050026.56321.heiko@sntech.de> <527835FE.2030102@wwwdotorg.org>
 <5279A319.5060701@broadcom.com> <527A75A6.5010904@wwwdotorg.org>
In-Reply-To: <527A75A6.5010904@wwwdotorg.org>
X-WSS-ID: 7E62D2504RS5944221-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-11-06 09:00 AM, Stephen Warren wrote:
> You probably don't want to reference the individual xxx1/2/3 nodes in
> the client pinctrl properties, but instead wrap them in a higher-level
> node that represents the whole pinctrl state. Then, the client pinctrl
> properties can reference just that single parent node, instead of many
> small nodes. In other words:
>
> pinctrl@... {
> 	...
> 	sx: state_xxx {
> 		xxx1 { ... };
> 		xxx2 { ... };
> 		xxx3 { ... };
> 	};
> 	sy: state_yyy {
> 		yyy1 { ... };
> 		yyy2 { ... };
> 	};
> }
>
> some_client@... {
> 	...
> 	pinctrl-names = "default";
> 	pinctrl-0 = <&sx>;
> };
>
> other_client@... {
> 	...
> 	pinctrl-names = "default";
> 	pinctrl-0 = <&sy>;
> };
>
> rather than:
>
> pinctrl@... {
> 	...
> 	sx1: xxx1 { ... };
> 	sx2: xxx2 { ... };
> 	sx3: xxx3 { ... };
> 	sy1: yyy1 { ... };
> 	sy2: yyy2 { ... };
> }
>
> some_client@... {
> 	...
> 	pinctrl-names = "default";
> 	pinctrl-0 = <&sx1 &sx2 &sx3>;
> };
>
> other_client@... {
> 	...
> 	pinctrl-names = "default";
> 	pinctrl-0 = <&sy1 &sy2>;
> };
>
> This is exactly how the Tegra pinctrl bindings work for example.

Ok, right, I mistakenly thought the "xxx1" nodes are pin config nodes. 
Actually that's the way my original driver works as well, other than the 
fact that I don't have as many "xxx1" type nodes as decribed in the 
"xxx" node below.

>> This works fine.  However, I'm just thinking that
>> it would have been easier if we could specify just one node:
>>
>> xxx {
>>      pins = <PINA>, <PINB>, <PINC>;
>>      function = <...>;
>>      pull-up = <1 1 0>;
>> }
>>
>> This "feature" seems a bit more concise to me and is what I did for my
>> original pinctrl driver.  The only downside is that with this method,
>> one cannot specify "don't touch this option for this pin" if the same
>> property must provide values for other pins.
>
> The other downside is that if the lists get even slightly long, it get
> really hard to match up the entries in the t properties.

Agree that it would start to get difficult to read if a subnode has too 
many pins.  I guess the solution would be to somehow split up the pins 
to more subnodes with fewer pins each.

Regards,
Sherman



