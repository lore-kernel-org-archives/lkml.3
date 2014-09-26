Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbaIZRRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:17:16 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63412 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaIZRRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:17:15 -0400
Message-ID: <54259F83.5020006@gmail.com>
Date: Fri, 26 Sep 2014 10:16:51 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Michael Welling <mwelling@emacinc.com>
CC: linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        linus.walleij@linaro.org, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: GPIO registration for external Ethernet PHY oscillator enable/disable
References: <20140925191722.GA2481@sysresccd> <54247372.40803@gmail.com> <20140926165919.GA3518@sysresccd>
In-Reply-To: <20140926165919.GA3518@sysresccd>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 09:59 AM, Michael Welling wrote:
> On Thu, Sep 25, 2014 at 12:56:34PM -0700, Florian Fainelli wrote:
>> So, PHY drivers are allowed to provide specialized implementations for
>> suspend/resume operations that are called by phy_suspend() and
>> phy_resume(), the current Micrel PHY driver uses the generic
>> suspend/resume implementation and it is best if we can keep doing that.
>>
> 
> In my situation the defualt phy_suspend is not sufficient. We are
> looking to use the board for an application that requires a low sleep
> current. The KZS8081 has a slow oscillator low power mode that is 
> required to meet the requirements.
> 
> So I have already overwritten the suspend/resume to send the required
> commands to the PHY to achieve the slow clock mode.
> 
> If you are interested the sequence is explained in the datasheet pg 34:
> http://www.micrel.com/_PDF/Ethernet/datasheets/KSZ8081MNX-RNB.pdf
> 
>>> Can it be handled outside of the PHY driver?
>>
>> I see a few possible options:
>>
>> - hook a pm_runtime callbacks for your platform, check the device
>> pointer to make sure this is the PHY device, and when that is the case,
>> toggle the GPIO accordingly
> 
> Not too familiar with the pm_runtime callbacks.
> 
> Can you point me to a similar example that is already in the kernel?

drivers/sh/pm_runtime.c is a simple example, there might others in the
OMAP code.

> 
>>
>> - add an additional "osc_gpio" configuration parameter passed to the
>> Ethernet MAC driver (presumably drivers/net/ethernet/cadence/macb.c?)
>> and toggle the GPIO before and after the calls to the PHY state machine
>> (phy_suspend, phy_resume, phy_start, phy_stop), that might be simpler
>>
> 
> This seems the wrong place as the oscillator is specific to the PHY.

Yes and no, this might feel like the wrong place, but ultimately, the
Ethernet MAC is a consumer of the PHY device, and is in control, through
the PHY library of how and when the PHY gets to be powered off.

> 
>> - last but not least, make the PHY driver aware of that optional GPIO,
>> create customized PHY suspend/resume/config_aneg callbacks
>>
> 
> This to me feels like the path of least resistance. Though the driver
> does not appear to be a platform driver so I am not sure how to pass
> GPIOs to it. Maybe I am missing something.

If your platform uses Device Tree, you need to add a probe() and
remove() callbacks to the micrel PHY driver, and fetch the gpio resource
from there.

For non-Device Tree, we might have to find an another to specify such
auxiliary information, but traditionally, people have been using the
help of the Ethernet MAC driver to provide additional information down
to the PHY driver.
--
Florian

