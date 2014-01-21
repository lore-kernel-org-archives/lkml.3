Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbaAUAjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 19:39:09 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43344 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754146AbaAUAjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 19:39:05 -0500
Date: Tue, 21 Jan 2014 00:38:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
	device probe
Message-ID: <20140121003856.GP15937@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org> <1390208555-27770-2-git-send-email-tushar.behera@linaro.org> <20140120100530.GY15937@n2100.arm.linux.org.uk> <20140120211601.GB634@kroah.com> <20140120213206.GJ15937@n2100.arm.linux.org.uk> <20140120231141.GA2355@kroah.com> <20140120231603.GL15937@n2100.arm.linux.org.uk> <20140120235128.GA5012@kroah.com> <20140121000706.GN15937@n2100.arm.linux.org.uk> <20140121002623.GA6173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121002623.GA6173@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 04:26:23PM -0800, Greg KH wrote:
> On Tue, Jan 21, 2014 at 12:07:06AM +0000, Russell King - ARM Linux wrote:
> > On Mon, Jan 20, 2014 at 03:51:28PM -0800, Greg KH wrote:
> > > On Mon, Jan 20, 2014 at 11:16:03PM +0000, Russell King - ARM Linux wrote:
> > > > I don't believe the driver model has any locking to prevent a drivers
> > > > ->probe function running concurrently with it's ->remove function for
> > > > two (or more) devices.
> > > 
> > > The bus prevents this from happening.
> > > 
> > > > The locking against this is done on a per-device basis, not a per-driver
> > > > basis.
> > > 
> > > No, on a per-bus basis.
> > 
> > I don't see it.
> > 
> > Let's start from driver_register().
> 
> Which happens from module probing, which is single-threaded, right?

Yes, to _some_ extent - the driver is added to the bus list of drivers
before existing drivers are probed, so it's always worth bearing in
mind that if a new device comes along, it's possible for that device
to be offered to even a driver which hasn't finished returning from
its module_init().

> > If you think there's a per-driver lock that's held over probes or removes,
> > please point it out.  I'm fairly certain that there isn't, because we have
> > to be able to deal with recursive probes (yes, we've had to deal with
> > those in the past.)
> 
> Hm, you are right, I think that's why we had to remove the locks.  The
> klist stuff handles us getting the needed locks for managing our
> internal lists of devices and drivers, and those should be fine.
> 
> So, let's go back to your original worry, what are you concerned about?
> A device being removed while probe() is called?

My concern is that we're turning something which should be simple into
something unnecessarily complex.  By that, I mean something along the
lines of:

static DEFINE_MUTEX(foo_mutex);
static unsigned foo_devices;

static int foo_probe(struct platform_device *pdev)
{
	int ret;

	mutex_lock(&foo_mutex);
	if (foo_devices++ == 0)
		uart_register_driver(&driver);

	ret = foo_really_probe_device(pdev);
	if (ret) {
		if (--foo_devices == 0)
			uart_unregister_driver(&driver);
	}
	mutex_unlock(&foo_mutex);

	return ret;
}

static int foo_remove(struct platform_device *pdev)
{
	mutex_lock(&foo_mutex);
	foo_really_remove(pdev);
	if (--foo_devices == 0)
		uart_unregister_driver(&driver);
	mutex_unlock(&foo_mutex);

	return 0;
}

in every single serial driver we have...  Wouldn't it just be better to
fix the major/minor number problem rather than have to add all that code
repetitively to all those drivers?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
