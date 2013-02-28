Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab3B1TLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 14:11:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40737 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134Ab3B1TLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 14:11:32 -0500
Message-ID: <512FABD7.3090000@wwwdotorg.org>
Date: Thu, 28 Feb 2013 12:11:19 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
References: <Pine.LNX.4.44L0.1302281346120.1352-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1302281346120.1352-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 11:52 AM, Alan Stern wrote:
> On Thu, 28 Feb 2013, Stephen Warren wrote:
> 
>> I think this patch might cause unintended consequences.
>>
>> When the Tegra PHY code is converted to a driver (i.e. has its own
>> probe), the initial order of execution of the PHY and EHCI driver probes
>> will not be guaranteed.
>>
>> In particular, since the EHCI probe will attempt to "find" the PHY
>> device, and defer the EHCI probe until it can do so, this guarantees
>> that the PHY's probe() will have completed before EHCI's probe()
>> completes (although EHCI's probe may start running first some number of
>> times, and be retried with -EPROBE_DEFERRED for a variety of reasons).
>>
>> Now, if the PHY driver's probe() actually touches HW and sets up some
>> registers, isn't this reset call going to trash any of that register
>> setup? Or, will PHY probe() not touch registers, but only do so during
>> the standard PHY open/init "op"/API calls?
>>
>> I think the way to solve this is to put the reset call into the PHY
>> driver. I assume it has access to the appropriate clock object. This may
>> also address Alan's query re: when the unexpected interrupt occurs; it's
>> triggered by (or correlated with at least) the PHY (or USB port in
>> general) being in device mode due to the boot ROM setting it up this
>> way, then switching to host mode via the Linux driver. I /think/ that
>> device/host mode switching is more related to the PHY than EHCI driver,
>> although I could well be wrong here.
> 
> With the PCI platform driver, the handoff from the firmware (we can
> categorize U-Boot as firmware for this discussion) is handled as soon
> as the controller is discovered by the platform-specific code.  
> There's a special pci-quirks.c file to take care of it.  It is not
> handled by the driver or the glue layer.
> 
> In general I think that's what needs to be done.  Errant interrupt 
> sources should be disabled as quickly as possible.
> 
> In this case I don't know exactly when the earliest opportunity is.  I
> assume that the EHCI driver and/or the PHY driver gets probed because
> some platform-layer code has registered the device.  If this is so then
> that platform-layer code is the right place to do the reset.

The first platform-specific code that is executed in this case is the
(struct platform_driver) probe() functions for the PHY and/or EHCI device.

On Tegra, all devices are listed in device tree, and core kernel code
instantiates platform devices based on the information in device tree.
The first non-core code that runs on a platform device is the driver's
probe() method. That probe() method is for a very specific piece of HW,
and hence seems to be the best place to put any quirks for it. Putting
the quirks outside the driver would mean some piece of the core DT code
would need to have a quirk list, and be able to map the registers for
the device, acquire clocks, etc. etc., implement the quirk, and tear it
all down again. All of which would just be duplicated with the driver's
own probe() function.
