Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3J3Hy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 03:54:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40812 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3J3Hyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 03:54:55 -0400
Date: Wed, 30 Oct 2013 08:54:46 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] can: c_can: Speed up rx_poll function
Message-ID: <20131030075446.GE20839@pengutronix.de>
References: <1383035267-19604-1-git-send-email-mpa@pengutronix.de>
 <1383035688.2713.2.camel@joe-AO722>
 <20131029085853.GC20839@pengutronix.de>
 <1383063845.2713.15.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1383063845.2713.15.camel@joe-AO722>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:38:09 up 66 days, 17:08, 48 users,  load average: 0.17, 0.13,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 09:24:05AM -0700, Joe Perches wrote:
> On Tue, 2013-10-29 at 09:58 +0100, Markus Pargmann wrote:
> > On Tue, Oct 29, 2013 at 01:34:48AM -0700, Joe Perches wrote:
> > > On Tue, 2013-10-29 at 09:27 +0100, Markus Pargmann wrote:
> > > > This patch speeds up the rx_poll function by reducing the number of
> > > > register reads.
> > > []
> > > > 125kbit:
> > > >   Function                               Hit    Time            Avg             s^2
> > > >   --------                               ---    ----            ---             ---
> > > >   c_can_do_rx_poll                     63960    10168178 us     158.977 us      1493056 us
> > > > With patch:
> > > >   c_can_do_rx_poll                     63939    4268457 us     66.758 us       818790.9 us
> > > > 
> > > > 1Mbit:
> > > >   Function                               Hit    Time            Avg             s^2
> > > >   --------                               ---    ----            ---             ---
> > > >   c_can_do_rx_poll                     69489    30049498 us     432.435 us      9271851 us
> > > > With patch:
> > > >   c_can_do_rx_poll                    103034    24220362 us     235.071 us      6016656 us
> []
> > Yes I just measured the timings again:
> []
> > ./perf_can_test.sh 125000 30
> []
> >   c_can_do_rx_poll                     63941    3764057 us     58.867 us       776162.2 us 
> 
> Good, it's slightly faster still.
> 
> > ./perf_can_test.sh 1000000 30
> []
> >   c_can_do_rx_poll                    207109    24322185 us     117.436 us      171469047 us 
> []
> > It is interesting that the number of hits for c_can_do_rx_poll is twice as much
> > as it was with find_next_bit.
> 
> How is this possible?  Any idea?

Perhaps the can core received more messages in the previous patch
version while being in the poll function. This way it can handle more
messages without a new interrupt/poll call.

The new patch is faster so it does not receive as many new messages as
the old one, leading to more interrupts and less handled messages per
poll call.

Regards,

Markus Pargmann

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
