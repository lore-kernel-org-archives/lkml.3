Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaATXVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:21:51 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43286 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752475AbaATXVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:21:48 -0500
Date: Mon, 20 Jan 2014 23:21:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tushar Behera <tushar.behera@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
	device probe
Message-ID: <20140120232141.GM15937@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org> <1390208555-27770-2-git-send-email-tushar.behera@linaro.org> <20140120100530.GY15937@n2100.arm.linux.org.uk> <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com> <20140120214305.54f65ffa@www.etchedpixels.co.uk> <20140120231457.GZ17314@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120231457.GZ17314@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 11:14:57PM +0000, Mark Brown wrote:
> On Mon, Jan 20, 2014 at 09:43:05PM +0000, Alan Cox wrote:
> > If the hardware isn't present then the driver shouldn't even register
> > with the tty layer in the first place so it doesn't make any resource
> > differeneces either for properly written code.
> 
> Right, that's not the idiom that has been followed by any of serial
> drivers though so needs fixing too.

It's not followed by serial drivers because it gets f*scking complicated
to do it that way.

In order to do it that way, what we need to do is:

1. On the first device probe, register the UART driver.
2. On subsequent device probes, don't register the UART driver because
   it's already registered.
3. When devices are removed, do nothing until the last device.
4. When the last device is removed, unregister the UART driver.

The first bit is easy... but we need to add locks to every serial
driver to prevent two probes operating concurrently...

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
