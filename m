Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaIYT44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:56:56 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34769 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaIYT4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:56:54 -0400
Message-ID: <54247372.40803@gmail.com>
Date: Thu, 25 Sep 2014 12:56:34 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Michael Welling <mwelling@emacinc.com>, linux-kernel@vger.kernel.org
CC: grant.likely@linaro.org, linus.walleij@linaro.org, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: GPIO registration for external Ethernet PHY oscillator enable/disable
References: <20140925191722.GA2481@sysresccd>
In-Reply-To: <20140925191722.GA2481@sysresccd>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 12:17 PM, Michael Welling wrote:
> Looks like my original message got buried in the mailing list.
> 
> Lets try this again with a few key developers CC'd.
> 
> Original Message:
> I have some questions that span multiple subsystems including
> gpio/pinctrl, apm, and net subsystems.
> 
> On some of our system on module designs, we use a GPIO to toggle the
> enable pin on external oscillators. In particular, we are using a 50Mhz
> oscillator to drive a clock on a RMII Ethernet PHY.
> 
> Though I can configure the pin such that the Ethernet interface works we
> are looking to disable the oscillator during APM sleep but after the PHY
> is put into a low power mode.
> 
> How do I register a GPIO for use in the PHY suspend and resume code?

So, PHY drivers are allowed to provide specialized implementations for
suspend/resume operations that are called by phy_suspend() and
phy_resume(), the current Micrel PHY driver uses the generic
suspend/resume implementation and it is best if we can keep doing that.

> Can it be handled outside of the PHY driver?

I see a few possible options:

- hook a pm_runtime callbacks for your platform, check the device
pointer to make sure this is the PHY device, and when that is the case,
toggle the GPIO accordingly

- add an additional "osc_gpio" configuration parameter passed to the
Ethernet MAC driver (presumably drivers/net/ethernet/cadence/macb.c?)
and toggle the GPIO before and after the calls to the PHY state machine
(phy_suspend, phy_resume, phy_start, phy_stop), that might be simpler

- last but not least, make the PHY driver aware of that optional GPIO,
create customized PHY suspend/resume/config_aneg callbacks


> If so how do ensure the appropriate suspend and resume sequencing?
> 
> For reference, we are using a Micrel KSZ8081 PHY connected to a
> AT91SAMA5D35 processor.
> 
> Addendum:
> I ran into another situation where a GPIO enabled oscillator was used.
> The oscillator in this case drives the master clock for a audio codec.
> In the old days (before device tree), I could initialize the GPIO in the
> platform board file. Now with device tree I can setup the pin multipler
> but the initial state of the GPIO I am not sure how to set.
> 
> Is there a way to directly change the state of a GPIO pin from a
> devicetree entry?
> 

