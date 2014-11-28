Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaK1OEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:04:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34215 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaK1OEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:04:08 -0500
Date: Fri, 28 Nov 2014 15:04:01 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jean Delvare <jdelvare@suse.de>
Cc: Peter Wu <lekensteyn@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How should dev_[gs]et_drvdata be used?
Message-ID: <20141128140401.GD4431@pengutronix.de>
References: <20130123174204.00463f98@endymion.delvare>
 <2690400.fFjCFlrrIR@al>
 <1387820241.30327.105.camel@bling.home>
 <1716344.EUMSGCAAKK@al>
 <20140108142849.3993341c@endymion.delvare>
 <20141125211432.GA6008@pengutronix.de>
 <20141128144813.3e6fd8d9@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141128144813.3e6fd8d9@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Fri, Nov 28, 2014 at 02:48:13PM +0100, Jean Delvare wrote:
> On Tue, 25 Nov 2014 22:14:32 +0100, Uwe Kleine-König wrote:
> > On Wed, Jan 08, 2014 at 02:28:49PM +0100, Jean Delvare wrote:
> > > Having looked at the code in deeper detail, I think I understand what
> > > is going on. The problem is with:
> > > 
> > > 	i2c_set_adapdata(&priv->adapter, priv);
> > > 
> > > at the beginning of i801_probe(). It triggers the allocation of dev->p
> > > by the driver core. If we bail out at any point before i2c_add_adapter
> > > (and subsequently device_register) is called, then that memory is never
> > > freed.
> > > 
> > > Unfortunately it is not possible to move the i2c_set_adapdata() call
> > > after i2c_add_adapter(), because the data pointer is needed by code
> > > which runs as part of i2c_add_adapter().
> > > 
> > > We could move it right before the call to i2c_add_adapter(), to make
> > > the problem window smaller, but this wouldn't solve the problem
> > > completely, as i2c_add_adapter() itself can fail before
> > > device_register() is called.
> > > 
> > > The only solution I can think of at this point is to stop using
> > > i2c_set_adapdata() altogether, and use i2c_adapter.algo_data instead:
> > > 
> > > From: Jean Delvare <khali@linux-fr.org>
> > > Subject: i2c-i801: Use i2c_adapter.algo_data
> > > 
> > > Use i2c_adapter.algo_data instead of i2c_set/get_adapdata(). The
> > > latter makes use of the driver core's private data mechanism, which
> > > allocates memory. That memory is never released if an error happens
> > > between the call to i2c_set_adapdata() and the actual i2c_adapter
> > > registration.
> >
> > Since commit 1bb6c08abfb6 (which makes the driver core use a pointer in
> > struct device again for dev_set_drvdata; went into v3.16-rc1) this patch
> > is obsolete, right?
> 
> Correct. It was never applied upstream anyway, which is good as I never
> liked it.
I came back to it as it was still in the linux-i2c patchwork queue.
It is set to be superseeded now.

> > (Still there might be the opportunity for a few patches converting all
> > driver to i2c_set_adapdata and then drop adapter.algo_data.)
> 
> That's at least 35 bus drivers that would have to be converted then.
> But you should first check if it is possible to get rid of
> i2c_adapter.algo_data without breaking i2c-algo-bit and i2c-mux. If not
> then converting the bus drivers would really only be a minor cleanup
> with no real benefit (not saying it's not worth it though.)
Yeah. I'm not sure I will address this cleanup, but will keep your hint
on my radar.

Best regards and thanks for your reply,
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
