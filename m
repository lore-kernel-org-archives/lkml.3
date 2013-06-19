Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934540Ab3FSKFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:05:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43527 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933830Ab3FSKFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:05:32 -0400
Date: Wed, 19 Jun 2013 11:05:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 2/2] spi/pxa2xx: use a flag to check if the device is
	runtime suspended
Message-ID: <20130619100515.GK2718@n2100.arm.linux.org.uk>
References: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com> <1371565785-31332-2-git-send-email-mika.westerberg@linux.intel.com> <20130618180948.GP1403@sirena.org.uk> <20130619092508.GJ2718@n2100.arm.linux.org.uk> <20130619093938.GT1403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619093938.GT1403@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:39:38AM +0100, Mark Brown wrote:
> On Wed, Jun 19, 2013 at 10:25:08AM +0100, Russell King - ARM Linux wrote:
> > On Tue, Jun 18, 2013 at 07:09:48PM +0100, Mark Brown wrote:
> 
> > > This sounds like a problem which will affect a lot of devices and hence
> > > ought to be handled better by the PM core or at least frameworks in
> > > general.  Is it really device specific?
> 
> > It's always been something that has been recommended to be dealt with
> > by the driver.  If reading the interrupt status you read ~0, then it
> > likely is because the device is powered down or removed from the system.
> 
> > PCMCIA drivers have done this for years.
> 
> I know, some PCI devices too.  It's not just an issue for memory mapped
> devices, the same thing happens with devices on other buses - there's a
> whole bunch of issues around moving out of the various suspend states
> and getting interrupts (things like getting an interrupt controller
> waking up and delivering interrupts before the control bus for a device
> connected to it has woken up).  
> 
> The driver does need to be the one deciding what to do about being in
> suspend but we really ought to be able to do something without having to
> interact with the hardware partly just for neatness but more because on
> general buses the error handling is too painful.

And that's why doing it by "read the ISR and check its value" is the
best way, and not doing the "what state does the kernel think this
device is in".

The latter may be fine if the device is only connected to a non-shared
interrupt, but as soon as you start sharing interrupts, it fails - what
do you do if the device signals an interrupt on a level-sensitive input
but the kernel's state says that it's not yet active?  The answer -
you spin forever entering the same interrupt handler until the IRQ
input gets disabled permanently until you reboot the system.

As far as device sequencing, that is where the tree topology of the
device model is supposed to save you - the parenting of devices is
supposed to reflect their relationship, and the way things like PM
and runtime PM work, those relationships dictate the order in which
PM operations occur.  For instance, with runtime PM, a parent will
not be placed into a suspend state unless its children are already
suspended, unless the parent signals that it is independent of the
childs states.

Now, what might be a common pitfall with that is if you have a device
which is runtime PM enabled but its children aren't - does that block
or allow the parent device.  I've seen at least one instance where
it means that the children don't, so that's an argument that runtime
PM is either broken, or we need greater coverage with runtime PM
conversions.
