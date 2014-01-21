Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaAUAHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 19:07:19 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43324 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751887AbaAUAHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 19:07:16 -0500
Date: Tue, 21 Jan 2014 00:07:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
	device probe
Message-ID: <20140121000706.GN15937@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org> <1390208555-27770-2-git-send-email-tushar.behera@linaro.org> <20140120100530.GY15937@n2100.arm.linux.org.uk> <20140120211601.GB634@kroah.com> <20140120213206.GJ15937@n2100.arm.linux.org.uk> <20140120231141.GA2355@kroah.com> <20140120231603.GL15937@n2100.arm.linux.org.uk> <20140120235128.GA5012@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120235128.GA5012@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 03:51:28PM -0800, Greg KH wrote:
> On Mon, Jan 20, 2014 at 11:16:03PM +0000, Russell King - ARM Linux wrote:
> > I don't believe the driver model has any locking to prevent a drivers
> > ->probe function running concurrently with it's ->remove function for
> > two (or more) devices.
> 
> The bus prevents this from happening.
> 
> > The locking against this is done on a per-device basis, not a per-driver
> > basis.
> 
> No, on a per-bus basis.

I don't see it.

Let's start from driver_register().
This takes no locks and calls bus_add_driver().
This also takes no locks and calls driver_attach().
This walks the list of devices calling __driver_attach() for each.
__driver_attach() tries to match the device against the driver,
locks the parent device if one exists, and the device which is about
to be probed.  It then calls driver_probe_device().
driver_probe_device() inserts a runtime barrier and calls really_probe().
really_probe() ultimately calls either the bus ->probe method or the
driver ->probe method.

At no point in that sequence do I see anything which does any locking
on a per-driver basis.  Let's look at device_add().

device_add() calls bus_probe_device(), which then calls device_attach().
device_attach() takes the device's lock, and walks the list of drivers
calling __device_attach() on each driver.  This then calls down into
driver_probe_device(), and the path is the same as the above.

I don't see any per-driver locking here either.

I've checked the klist stuff, don't see anything there.  Ditto for
bus_for_each_drv().

If you think there's a per-driver lock that's held over probes or removes,
please point it out.  I'm fairly certain that there isn't, because we have
to be able to deal with recursive probes (yes, we've had to deal with
those in the past.)

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
