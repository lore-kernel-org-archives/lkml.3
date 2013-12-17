Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3LQSAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:00:01 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:34392 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3LQR76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:59:58 -0500
Message-ID: <52B090E0.5040006@gmail.com>
Date: Tue, 17 Dec 2013 19:58:56 +0200
From: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <bcousson@baylibre.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        =?UTF-8?B?0JjQstCw0Lk=?= =?UTF-8?B?0LvQviDQlNC40LzQuNGC0YDQvtCy?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, "pavel@ucw.cz" <pavel@ucw.cz>
Subject: Re: Re: [RFCv4 06/11] misc: Introduce Nokia CMT driver
References: <1387150085-23173-1-git-send-email-sre@debian.org> <1387150085-23173-7-git-send-email-sre@debian.org> <CACRpkdYjjXgE_W8gq1e6z=nGMF=r-m+o2kkvrBFrEMm3o0=RwQ@mail.gmail.com> <20131216121524.GA6177@earth.universe> <CACRpkdbx=Ye8xo4wMkyntME45xv15DeyqV32aeCAcSaa+vDpfA@mail.gmail.com> <20131216183448.GA10614@earth.universe>
In-Reply-To: <20131216183448.GA10614@earth.universe>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 16.12.2013 20:34, Sebastian Reichel wrote:
> Hi,
>
> On Mon, Dec 16, 2013 at 02:31:53PM +0100, Linus Walleij wrote:
>> I am very reluctant in letting device trees specify exports of GPIOs
>> to userspace, not so much because it's Linux-specific but for
>> the fact that people are doing things in userspace that should not
>> be done in userspace.
>>
>> Last time it was proposed I asked to the specific usecase,
>> exactly why userspace needed this handle on a physical
>> GPIO line, and why it can't use another userspace interface
>> (example: leds, keys etc.)
> There are a couple of lines ("cmt_apeslpx", "cmt_rst_rq", "cmt_en",
> "cmt_rst", "cmt_bsi"), which are handled by ofono to do the correct
> power sequence for the modem. The relevant ofono code is here:
>
> https://git.kernel.org/cgit/network/ofono/ofono.git/tree/plugins/nokia-gpio.c
>
> In MeeGo etc. they have a little board specific init script, which
> exports the gpio lines and setups some symlinks. IMHO at least the
> board specific stuff should be handled by the kernel, thus I added
> this code to the driver. I guess you prefer to move the power
> sequencing completly to the kernel?

Don't forget there is not only ofono, but rtcom-call-ui and all the 
telephony stack in Maemo 5 :). However, power sequencing and control is 
specific not only to the modem model, but to the firmware version the 
modem is running as well (afaik). IMO you can't simply move the modem 
power/reset/sleep control to the kernel and hope for the best, I am not 
sure there is enough documentation (if any) for this to be done 
reliably, esp on n900 with its BB5 modem. The point is that those gpios 
are used not only for the initial power-up, but for control of the modem 
state and reset (if needed) during normal usage. The APE reset line is 
an example of stuff that can't be moved to the kernel without providing 
some interface/feedback to/from the userspace IMO - what if she is 
dialing 112 at the moment the modem decides it is too hot and wants a 
device reset (or whatever reason there could be for a modem to request a 
device reset)? The same goes for the APE sleep request line 
(cmt_apeslpx) - based on what should the kernel decide whether to put 
the modem in sleep?

Sure, exporting gpios to userspace might not be the best way to achieve 
the required functionality, but every way could be argued if it is the 
best. And for sure labeling a modem "LED" won't make it such.

Regards,
Ivo
