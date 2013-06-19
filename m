Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab3FSHkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:40:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:50704 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab3FSHki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:40:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,895,1363158000"; 
   d="scan'208";a="356006025"
Date: Wed, 19 Jun 2013 10:44:37 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 2/2] spi/pxa2xx: use a flag to check if the device is
 runtime suspended
Message-ID: <20130619074437.GF11878@intel.com>
References: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com>
 <1371565785-31332-2-git-send-email-mika.westerberg@linux.intel.com>
 <20130618180948.GP1403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618180948.GP1403@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 07:09:48PM +0100, Mark Brown wrote:
> On Tue, Jun 18, 2013 at 05:29:45PM +0300, Mika Westerberg wrote:
> > Current code calls pm_runtime_suspended() in the interrupt handler to check
> > if the device is suspended or not. However, runtime PM status of the device
> > is only set to suspended once all PM runtime suspend hooks have executed.
> 
> > In our case we have the device bound to the ACPI power domain and its
> > runtime suspend hook will put the device to D3hot (or D3cold if possible).
> > This effectively means that the device is powered off before its state is
> > set to runtime suspended. During this time, it might get an interrupt that
> > is meant for another device (as the interrupt line is shared), and because
> > the device is powered off accessing its registers will return 0xffffffff
> > that the driver misinterprets as an invalid state. When this happens user
> > will see messages like below on the console:
> 
> This sounds like a problem which will affect a lot of devices and hence
> ought to be handled better by the PM core or at least frameworks in
> general.  Is it really device specific?

No, it's not device specific. However, I've seen it only happen with the
SPI controller on Lynxpoint.

I agree that it is better handled outside of the driver (or provide some
API for drivers). One thing that immediately came to mind is
adding pm_runtime_suspending() that could be used here like:

ssp_int()
{
	if (pm_runtime_suspending(dev) || pm_runtime_suspending(dev))
		return IRQ_NONE;
	...

or something like that?
