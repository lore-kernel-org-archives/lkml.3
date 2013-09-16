Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3IPSOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:14:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51162 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3IPSOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:14:14 -0400
Message-ID: <52374A71.5090305@wwwdotorg.org>
Date: Mon, 16 Sep 2013 12:14:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>
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
Subject: Re: [RFC PATCH alt 4/4] pinctrl: at91: rework debounce configuration
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com> <1379058813-3489-1-git-send-email-b.brezillon@overkiz.com> <52339479.6030402@wwwdotorg.org> <52340B68.5020505@overkiz.com> <523734B2.6050208@wwwdotorg.org> <52373D6D.4010109@overkiz.com>
In-Reply-To: <52373D6D.4010109@overkiz.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 11:18 AM, boris brezillon wrote:
> Hello Stephen,
> 
> On 16/09/2013 18:41, Stephen Warren wrote:
>> On 09/14/2013 01:08 AM, boris brezillon wrote:
...
>>> Let's say you have one device using multiple configuration of pins
>>> ("default", "xxx", "yyy").
>>> The "default" config needs a particular debounce time on a given pin and
>>> the "xxx" and "yyy"
>>> configs need different debounce time on the same pin.
>>>
>>> How would you solve this with this patch approach ?
>>
>> Each state has a different pin configuration node, and hence can specify
>> a different debounce value. ...
...
> Actually it does: this patch removes the debounce time setting option from
> the pin config description. The only thing you can do is enable or
> disable the debounce filter.
> 
> The atmel,default-debounce-div property is not part of the pin group (or
> pin state) node, it is a global property you define for the whole pinctrl
> controller (pinctrl node
> property):
> 
> pinctrl {
>         atmel,default-debounce-div=<100...
...

Oh, I see. Sorry.

It seems this HW has been designed to just set that configuration up
once and be done with it.

There really isn't a way to make anything more complex or dynamic work
correctly. If you try to put the debounce config into a per-state node
rather than the top-level, how will you reconcile any conflicts? What if
the gpio-keys default state's node says 10ms, whereas the SDHCI
controller's default state's node says 100ms? Both those states need to
be active at the same time. The only way to avoid conflict resolution
issues like that is to prevent them, and just put the debounce config at
the top-level, and hence program it once when the driver starts, i.e.
make the DT exactly match the HW capabilities.
