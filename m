Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936905Ab3DIHaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:30:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59786 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934778Ab3DIHay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:30:54 -0400
Date: Tue, 9 Apr 2013 09:30:51 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [BUG] increased us/sys-load due to tty-layer in 2.6.38+ ?!
Message-ID: <20130409073051.GF25003@pengutronix.de>
References: <20130408092558.GD25003@pengutronix.de>
 <20130408150611.GB13824@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408150611.GB13824@kroah.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:22:06 up 289 days, 22:33, 63 users,  load average: 0.11, 0.31,
 0.44
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 08:06:11AM -0700, Greg Kroah-Hartman wrote:
> On Mon, Apr 08, 2013 at 11:25:58AM +0200, Steffen Trumtrar wrote:
> > Hi!
> > 
> > I noticed a problem with the tty subsystem on ARM. Starting with 2.6.38+ load
> > on the serial connection causes a 10-15% increase in system/userspace load.
> > This doesn't change up to v3.9-rc4.
> > 
> > The following setup was used:
> > 
> >   telnet && screen microcom -p /dev/ttyUSB0
> >         |                           +--------+
> >         |-------------->------------|----+   |
> >     +-------+<---------<------------|----+   |
> >     |       |       +------+        |        |
> >     |  UUT  |<-USB->| FTDI |<-UART->|        |
> >     |       |       +------+        |   PC   |
> >     +-------+                       +--------+
> >         ^
> >         |
> >   telnet && top -d1
> > 
> > The unit under test (UUT) is connected via USB->FTDI->UART to a PC. On the PC
> > a "while true; do find /; done" produces some random output.
> > I connect to the UUT via telnet and then open a serial connection to the PC
> > in a screen session, seeing the output produced on the PC. Then screen gets
> > detached. So, basically, what I'm trying to do is producing load only on the
> > USB->FTDI->UART connection and not on the UUT itself.
> > Then another telnet connection is opened, to monitor the UUT with "top -d1".
> > As UUT an imx27, kirkwood and an AT91 were used.
> > 
> > To find the "offending" code, I bisected v2.6.38..v3.0 which gave the following
> > top output (non-scientifically, I know. But the switch in load distribution is
> > obvious nevertheless):
> > 
> > 2.6.38           Cpu(s):  3.8%us,  1.9%sy,  0.0%ni, 94.3%id
> > 2.6.38+          Cpu(s):  1.9%us,  3.8%sy,  0.0%ni, 94.3%id
> > last good commit Cpu(s):  1.9%us,  2.8%sy,  0.0%ni, 95.3%id
> > first bad commit Cpu(s):  4.8%us, 14.5%sy,  0.0%ni, 80.6%id
> > 2.6.39-rc4       Cpu(s): 10.5%us,  8.9%sy,  0.0%ni, 79.8%id
> > 3.0              Cpu(s): 15.9%us, 19.6%sy,  0.0%ni, 62.3%id
> > 
> > This resulted in
> >         f23eb2b2b28547fc70df82dd5049eb39bec5ba12
> >         tty: stop using "delayed_work" in the tty layer
> > 
> > as possible cause. Reverting this commit by hand in v3.8 showed a load distribution
> > similar to 2.6.38.
> > What I haven't done, is measure if the load is really increasing or if top only
> > tells me so. Maybe the algorithm to calculate this somehow produces different
> > results because of the switch from schedule_delayed_work to schedule_work?
> > So, is this a bug, a feature, a symptom,...?
> 
> It's a "fake" load (i.e. no extra cpu is being used, just a "busy" wait
> is happening.)
> 
> You should see an increased throughput with that patch applied, have you
> tested a real workload?
> 

Hi Greg,

we found this "fake" load via a normal userspace program, that is using
UART for communication, if that is what you mean by "real workload".
But the next step would be measuring throughput and the real load.
Sounds like we will not find anything, but will still have an explanation
for the load.

Thanks,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
