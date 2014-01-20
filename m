Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaATXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:16:28 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43275 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751517AbaATXQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:16:27 -0500
Date: Mon, 20 Jan 2014 23:16:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
	device probe
Message-ID: <20140120231603.GL15937@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org> <1390208555-27770-2-git-send-email-tushar.behera@linaro.org> <20140120100530.GY15937@n2100.arm.linux.org.uk> <20140120211601.GB634@kroah.com> <20140120213206.GJ15937@n2100.arm.linux.org.uk> <20140120231141.GA2355@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120231141.GA2355@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 03:11:41PM -0800, Greg KH wrote:
> On Mon, Jan 20, 2014 at 09:32:06PM +0000, Russell King - ARM Linux wrote:
> > On Mon, Jan 20, 2014 at 01:16:01PM -0800, Greg KH wrote:
> > > On Mon, Jan 20, 2014 at 10:05:30AM +0000, Russell King - ARM Linux wrote:
> > > > On Mon, Jan 20, 2014 at 02:32:34PM +0530, Tushar Behera wrote:
> > > > > uart_register_driver call binds the driver to a specific device
> > > > > node through tty_register_driver call. This should typically happen
> > > > > during device probe call.
> > > > > 
> > > > > In a multiplatform scenario, it is possible that multiple serial
> > > > > drivers are part of the kernel. Currently the driver registration fails
> > > > > if multiple serial drivers with same default major/minor numbers are
> > > > > included in the kernel.
> > > > > 
> > > > > A typical case is observed with amba-pl011 and samsung-uart drivers.
> > > > 
> > > > The samsung-uart driver is at fault here - the major/minor numbers were
> > > > officially registered to amba-pl011.  Samsung needs to be fixed properly.
> > > 
> > > I agree, the Samsung driver is "broken" here, but that's no reason why
> > > these two drivers can't register with the tty layer _after_ the hardware
> > > is detected, and not before.
> > > 
> > > That saves resources on systems that build the drivers in, yet do not
> > > have the hardware present, which is always a good thing.
> > 
> > Great, so what you're saying is that we need to wait until the first
> > device calls into the probe function.  What about removal... how does
> > a driver know when it's last device has been removed to de-register
> > that?
> 
> The "bus" that the device is on handles that, right?
> 
> > I guess it needs the driver model to provide some way to know when a
> > driver is completely unbound - but isn't that racy?
> 
> How is it racy?  That's how the driver model works...

Think about what happens when the last device unregisters, but a new
device comes along and is probed.

I don't believe the driver model has any locking to prevent a drivers
->probe function running concurrently with it's ->remove function for
two (or more) devices.

The locking against this is done on a per-device basis, not a per-driver
basis.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
