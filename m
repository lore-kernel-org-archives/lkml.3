Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab3ECPGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:06:15 -0400
Received: from multi.imgtec.com ([194.200.65.239]:26460 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530Ab3ECPGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:06:14 -0400
Message-ID: <5183D262.7000107@imgtec.com>
Date: Fri, 3 May 2013 16:06:10 +0100
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
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com> <1366727607-27444-6-git-send-email-james.hogan@imgtec.com> <CACRpkdbYwDvF=gNurLzc+wE0BYpoqog7sPdRTY59BGS7yn3n9Q@mail.gmail.com> <517A6B01.5000708@imgtec.com> <CACRpkdYooPNgJuA-fZOiGJV03R_783uAOmR=QgYOahYdHcad9w@mail.gmail.com> <5183AC54.30503@imgtec.com> <CACRpkdYYhsY-2vQnxpM-rB9_6yXiY4XBNhb4eyNvK=eD=dxK5w@mail.gmail.com>
In-Reply-To: <CACRpkdYYhsY-2vQnxpM-rB9_6yXiY4XBNhb4eyNvK=eD=dxK5w@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_05_03_16_06_12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 03/05/13 14:03, Linus Walleij wrote:
> On Fri, May 3, 2013 at 2:23 PM, James Hogan <james.hogan@imgtec.com> wrote:
>> [Me]
>>> If what you need is to set the pin into "GPIO mode" to drive it
>>> to some default state then from pinconf-generic.h you should use
>>> one of the existing defines like PIN_CONFIG_OUTPUT
>>> to actively drive it to high or low as default, or
>>> PIN_CONFIG_BIAS_HIGH_IMPEDANCE for some default
>>> GPIO input mode.
>>>
>>> Read the new section named "GPIO mode pitfalls" in
>>> Documentation/pinctrl.txt
>>
>> Thanks, that was interesting. I've had a think about this (and done some
>> experiments with a multimeter), and the problem is these generic
>> pinconfs already have meanings which don't match what the SELECT
>> register does. For example, having a pin be tristate and not controlled
>> by the peripheral, and having it tristate as far as the gpio hardware is
>> concerned (e.g. no pull-up) but still controlled by the peripheral, are
>> two very different things that need disambiguation.
> 
> I don't know if that is necessary.
> 
> While I do recognize that it is possible that we need to put
> pins into "GPIO mode", i.e. drive them actively low or high,
> as PIN_CONFIG_OUTPUT does, I'm not convinced that
> pin config should handle the case where a signal is passed
> through from a peripheral.
> 
> I think that for every pin that is put to use for a peripheral
> you must anyway at some point call .enable() on the
> struct pinmux_ops of the pin controller.
> 
> Thus this part of the problem (poking that "select" bit)
> should be handled by the pinmux part of the driver.
> 
> The pinconf part does not need to know about it.

Okay, so how would you recommend handling the case of a pin in a muxing
pingroup that shouldn't be put into peripheral mode?

E.g. imagine an 18bit display is wired to the (24bit) tft pins (which
are muxed as a group to "tft" function), and the least significant tft
pins are used as GPIOs to control something like board power supplies.

Without using pinconf I think the muxing pingroups would have to overlap
like below (is that acceptable?):

pingroup "tft_pins"
	pins:      "red0"..."red7"
	functions: "tft", "lcd"

pingroup "red0"
	pins:      "red0"
	functions: "peripheral" (OR "none")
...
pingroup "red7"
	pins:      "red7"
	functions: "peripheral" (OR "none")

and then do something like this?

map {
	tft_mux {
		pins = "tft_pins";
		function = "tft";
		/* mux tft pins to tft panel interface */
	};
	tft_pins {
		pins = "red7", "red6", "red5", "red4", "red2";
		function = "peripheral";
		/* mux pins to peripherals */
	};
};

or maybe this:

map {
	tft_mux {
		pins = "tft_pins";
		function = "tft";
		/* auto sets individual pins to peripheral */
	};
	tft_pins {
		pins = "red1", "red0";
		function = "none";
		/* set individual pins to !peripheral */
	};
};

Cheers
James

