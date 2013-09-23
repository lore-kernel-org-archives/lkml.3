Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab3IWM2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:28:13 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:38519 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab3IWM2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:28:12 -0400
Date: Mon, 23 Sep 2013 14:28:06 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: prevent deferred probe with
 platform_driver_probe
Message-ID: <20130923122806.GA1454@localhost>
References: <1379926127-8935-1-git-send-email-jhovold@gmail.com>
 <20130923110140.GB21013@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923110140.GB21013@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 12:01:40PM +0100, Mark Brown wrote:
> On Mon, Sep 23, 2013 at 10:48:47AM +0200, Johan Hovold wrote:
> > Prevent drivers relying on platform_driver_probe from requesting
> > deferred probing in order to avoid further futile probe attempts (either
> > the driver has been unregistered or its probe function has been set to
> > platform_drv_probe_fail when probing is retried).
> > 
> > Note that several platform drivers currently return subsystem errors
> > from probe and that these can include -EPROBE_DEFER (e.g. if a gpio
> > request fails).
> 
> This doesn't seem like the right end to address the problem from, it
> seems like it would be better to move these drivers over to being normal
> plaform drivers.  Using module_platform_driver() means relying on init
> ordering which is the sort of thing we're trying to get away from.

I actually started out doing that, but it's getting a bit hard to audit
which drivers could actually request probe deferral since gpio and later
other subsystems started returning -EPROBE_DEFER. I found six by just
grepping for gpio_request, but some of these calls can be made in helper
functions (e.g. mmc_gpio_request_cd even though that one was easy to
find).

Having a warning printed by platform_drv_probe if a platform driver
inadvertently requests probe deferral could be useful to catch any
mistakes even if we start moving probe functions out of __init.

I'll fix up the six drivers I found meanwhile.

Johan
