Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418Ab3FSJZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:25:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43511 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032Ab3FSJZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:25:25 -0400
Date: Wed, 19 Jun 2013 10:25:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 2/2] spi/pxa2xx: use a flag to check if the device is
	runtime suspended
Message-ID: <20130619092508.GJ2718@n2100.arm.linux.org.uk>
References: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com> <1371565785-31332-2-git-send-email-mika.westerberg@linux.intel.com> <20130618180948.GP1403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618180948.GP1403@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
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

It's always been something that has been recommended to be dealt with
by the driver.  If reading the interrupt status you read ~0, then it
likely is because the device is powered down or removed from the system.

PCMCIA drivers have done this for years.
