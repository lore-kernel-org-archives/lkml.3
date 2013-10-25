Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab3JYWtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:49:15 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4442 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab3JYWsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:48:52 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Sherman Yin" <syin@broadcom.com>
To: "Linus Walleij" <linus.walleij@linaro.org>
cc: "Mark Rutland" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Christian Daudt" <bcm@fixthebug.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "Rob Landley" <rob@landley.net>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
Thread-Topic: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl
 driver
Thread-Index: AQHOwJjvlt3ZyknjmUucDC303MwucJnskuoAgAHzuwCAASFSgIAANMjQgBFlnYCABNWBYA==
Date: Fri, 25 Oct 2013 22:48:38 +0000
Message-ID: <051069C10411E24D9749790C498526FA1BE0B7D7@SJEXCHMB12.corp.ad.broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
 <1380846199-12829-4-git-send-email-syin@broadcom.com>
 <CACRpkdZah4fFuJL2Vh5JmbBCgnekg8MKqMWHzeheOx3N1Kzwng@mail.gmail.com>
 <051069C10411E24D9749790C498526FA1BE027EA@SJEXCHMB12.corp.ad.broadcom.com>
 <CACRpkdarPC+LxAAezT2LRiz=Y2RduUsb75YYHUgq7HqePzkD3Q@mail.gmail.com>
 <051069C10411E24D9749790C498526FA1BE03D43@SJEXCHMB12.corp.ad.broadcom.com>
 <051069C10411E24D9749790C498526FA1BE0841D@SJEXCHMB12.corp.ad.broadcom.com>
In-Reply-To: <051069C10411E24D9749790C498526FA1BE0841D@SJEXCHMB12.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E742ABF1SC1662093-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>As well as all this stuff...
>>>>
>>>> OK.  Will see if I can find something suitable for "input disable" and "mode"
>>>
>>>Let's discuss this. What exactly does "input disable" and "mode"
>>>mean, in electrical terms?
>>>
>>>When you come down to what actually happens it may turn out that
>>>"input disable" is PIN_CONFIG_OUTPUT, which implicitly turns
>>>off input does it not?
>>
>>I'm going to verify the details with our hardware team first, and will let you
>>know if we think we can use one of the existing generic parameters or if we
>>need a new one.
>
>"input disable"
>This setting disconnects the input (DIN) to the internal logic from the pin pad.
>However, the output (DOUT) can still drive the pad.  It seems to match
>PIN_CONFIG_OUTPUT, but the current generic option is either "output-low" or
>"output-high" - are these referring to a static output of 0 and 1?
>
>"mode"
>This controls several aspect of the pin (slew rate, pull up strength, etc) to meet
>I2C specs for Standard/Fast mode vs High Speed mode.  I think the best
>way is to map this to slew rate, which would require some explanation because
>the meaning of slew rate differs depending on what pin function is selected:
>- When I2C (*_SCL or *_SDA) function is selected for the pin: 0: Standard (100kbps)
>  & Fast mode (400kbps), 1: High Speed mode (3.4Mbps)
>- When IC_DM or IC_DP function is selected, 0: normal slew rate, 1: fast slew rate
>- Else: 0: fast slew rate, 1: normal slew rate
>
>Also, it seems like I have to add "slew-rate" to dt_params[] in pinconf-generic.c and
>pinctrl-bindings.txt.

Hi Linus,

So I will go ahead and make the change in pinconf-generic.c and pinctrl-bindings.txt
to include parsing of the "slew-rate" property and submit it as part of my pinctrl
changes.

Question regarding pinctrl-generic: in pinctrl-bindings.txt, this is said about the
"function" property:

169- function takes a list of function names/IDs as a required argument. The
170  specific binding for the hardware defines:
171  - Whether the entries are integers or strings, and their meaning.
172  - Whether only a single entry is allowed (which is applied to all entries
173    in the pins property), or whether there may alternatively be one entry per
174    entry in the pins property, in which case the list lengths must match, and
175    for each list index i, the function at list index i is applied to the pin
176    at list index i.

(Although it looks like pinconf_generic_dt_subnode_to_map() does not support
the "one entry per pin feature" for the "function" property yet.)

In my driver, I have the "one entry per pin" support for all my properties instead
of just the function property, like the "drive_str" property below:

+		grp_1 {
+			brcm,pins	= "pin1", "pin2", "pin3";
+			brcm,function	= "alt1", "alt2", "alt1";
+			brcm,drive_str	= <2 4 6>;
+			brcm,slew	= <1>;
+		};

I thought that would be convenient and allow users to group pins together based 
on functionality and without the restriction that the pins must have the same 
properties.  Do you think that's a good idea and are there plans to support that in
the generic pinconfig?  If so, I can look into porting my implementation to
pinconf-generic.c - but first I have to figure out how some of the properties would
work if more than one value could be specified (eg. "bias-disable" which takes no
values)

Thanks,
Sherman


