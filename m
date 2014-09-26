Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaIZQ7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:59:30 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:60467 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaIZQ73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:59:29 -0400
Date: Fri, 26 Sep 2014 11:59:19 -0500
From: Michael Welling <mwelling@emacinc.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        linus.walleij@linaro.org, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: GPIO registration for external Ethernet PHY oscillator
 enable/disable
Message-ID: <20140926165919.GA3518@sysresccd>
References: <20140925191722.GA2481@sysresccd>
 <54247372.40803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54247372.40803@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 12:56:34PM -0700, Florian Fainelli wrote:
> So, PHY drivers are allowed to provide specialized implementations for
> suspend/resume operations that are called by phy_suspend() and
> phy_resume(), the current Micrel PHY driver uses the generic
> suspend/resume implementation and it is best if we can keep doing that.
>

In my situation the defualt phy_suspend is not sufficient. We are
looking to use the board for an application that requires a low sleep
current. The KZS8081 has a slow oscillator low power mode that is 
required to meet the requirements.

So I have already overwritten the suspend/resume to send the required
commands to the PHY to achieve the slow clock mode.

If you are interested the sequence is explained in the datasheet pg 34:
http://www.micrel.com/_PDF/Ethernet/datasheets/KSZ8081MNX-RNB.pdf

> > Can it be handled outside of the PHY driver?
> 
> I see a few possible options:
> 
> - hook a pm_runtime callbacks for your platform, check the device
> pointer to make sure this is the PHY device, and when that is the case,
> toggle the GPIO accordingly

Not too familiar with the pm_runtime callbacks.

Can you point me to a similar example that is already in the kernel?

> 
> - add an additional "osc_gpio" configuration parameter passed to the
> Ethernet MAC driver (presumably drivers/net/ethernet/cadence/macb.c?)
> and toggle the GPIO before and after the calls to the PHY state machine
> (phy_suspend, phy_resume, phy_start, phy_stop), that might be simpler
>

This seems the wrong place as the oscillator is specific to the PHY.

> - last but not least, make the PHY driver aware of that optional GPIO,
> create customized PHY suspend/resume/config_aneg callbacks
> 

This to me feels like the path of least resistance. Though the driver
does not appear to be a platform driver so I am not sure how to pass
GPIOs to it. Maybe I am missing something.

