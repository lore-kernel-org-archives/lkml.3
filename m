Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaBNAHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:07:30 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35437 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751199AbaBNAH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:07:28 -0500
Date: Fri, 14 Feb 2014 00:07:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
	device probe
Message-ID: <20140214000717.GG30257@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org> <1390208555-27770-3-git-send-email-tushar.behera@linaro.org> <20140120100415.GX15937@n2100.arm.linux.org.uk> <20140213181216.GB24155@kroah.com> <20140213181559.GB30257@n2100.arm.linux.org.uk> <20140213182701.GA32578@kroah.com> <20140213184249.GC30257@n2100.arm.linux.org.uk> <20140213232606.GA27372@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213232606.GA27372@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 03:26:06PM -0800, Greg KH wrote:
> On Thu, Feb 13, 2014 at 06:42:49PM +0000, Russell King - ARM Linux wrote:
> > We went through this before, and I stated the paths, and no one disagreed
> > with that.
> > 
> > It /is/ racy.
> 
> Ok, I just went and looked at the uart driver register path, and I don't
> see the race (note, if there is one, it's there today, regardless of
> this patch).

The race isn't the uart code, it's the driver model.

Consider what happens when this happens:

* Two pl011 devices get registered at the same time by two different
  threads.

* Both devices have a lock taken on the _device_ itself before matching
  against the driver.

* Both devices get matched to the same driver.

* Both devices are passed into the driver's probe function.

* Both check uart_reg.state, both call uart_register_driver() on that
  at the same time, which results in two allocations inside
  uart_register_driver(), one gets overwritten...

So, the /only/ thing which stops this happening is that the devices
are generally available before the driver is registered, and driver
registration results in devices being probed serially.  Moreover, both
attempt to call tty_register_driver()... one succeeds, the other fails.

However, what about the userspace bind/unbind methods.  Yes, userspace
can ask the driver core to unbind devices from a driver or bind - and
again, there's no per-driver locking here.  So, if you can trigger two
concurrent binds from userspace, you hit the same race as above.

So, if you want to accept these patches, go ahead, introduce races, but
personally I'd recommend plugging these races.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
