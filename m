Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaJOKDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:03:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53056 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaJOKC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:02:59 -0400
Date: Wed, 15 Oct 2014 12:02:47 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: atull <atull@opensource.altera.com>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, dinh.linux@gmail.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reset: socfpga: use arch_initcall for early
 initialization
Message-ID: <20141015100247.GB6255@pengutronix.de>
References: <1412822646-11257-1-git-send-email-dinguyen@opensource.altera.com>
 <1412845410.6809.3.camel@pengutronix.de>
 <54368AA2.9000104@opensource.altera.com>
 <20141009132835.GI15799@pengutronix.de>
 <alpine.DEB.2.02.1410090950540.17462@atx-linux-37>
 <20141009151935.GK15799@pengutronix.de>
 <alpine.DEB.2.02.1410101123590.11270@atx-linux-37>
 <alpine.DEB.2.02.1410141322160.11888@atx-linux-37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1410141322160.11888@atx-linux-37>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:17:08 up 35 days,  2:04, 58 users,  load average: 0,18, 0,17,
 0,14
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, Oct 14, 2014 at 01:45:29PM -0500, atull wrote:
> The FPGA bridge driver that I submitted last year handled the following
> things:
>  * The bridges might have been brought out of reset in the bootloader. Some
>    of the bridges have write-only registers (!) so this information had to
>    be passed in DT

Regmap has infrastructure to handle this.

>  * fpga2sdram bridge widths configured in DT

This should hold true for all bridges but the LWHPS.

>  * Supports enabling the following Altera fpga bridges:
>    * fpga2sdram
>    * fpga2hps
>    * hps2fpga
>    * lwhps2fpga
>  * interface in sysfs for each bridge to be put in reset/taken out of reset
>    * Enable (take out of reset):
>      $ echo 1 > /sys/class/fpga-bridge/fpga2hps/enable
>    * Disable (hold in reset):
>      $ echo 0 > /sys/class/fpga-bridge/fpga2hps/enable
>    * Check enable/disable status (checks for all bits set):
>      $ cat /sys/class/fpga-bridge/fpga2hps/enable
>        (will print '0' or '1')
>

I don't like that. The proper solution should be unloading/loading the
module for the bridge. On a reset the driver has to completely reset its state.

> Now that I'm enabling programming the FPGA from DT overlays, I also want
> to support DT control of the bridges at the proper time.  So that would
> support the use case where adding a DT overlay would:
>  1. program the FPGA
>  2. bring the appropriate bridges out of reset
>  3. modprobe the driver
> 
> Deleting the DT overlay would undo these steps in reverse order.
> 
> I submitted it on 10/8/2013 (I copied you on it), but I don't see it on
> lkml.org.  Probably because I submitted it from a gmail email address and
> that sometimes doesn't play well with lkml.  I'm planning on resubmitting
> when we have it better integrated with the reset subsystem.  If you can
> give me an early idea of how this fits in with your needs, that would be
> great.
>

I actually remember seeing that driver. The problem with the approach is,
that the bridges are not some IP that you just turn on/off.
The bridges are the busses that connect the FPGA to the SoC. So the driver
and the DT has to accommodate for that.
So, for the (LW)HPS that means we have a bus master driver, that has to

booting:
	- check if FPGA manager is enabled in DT
	  - EPROBE_DEFER if FPGA manager isn't loaded
	- check if FPGA is programmed
	  - EPROBE_DEFER otherwise
	- probe subnodes of bridge DT node

dynamic:
	- remove all drivers/devices previously probed by the bridge
	  - put bridge in reset (maybe the remove call should always do that ?)
	- program FPGA with (different) bitstream
	- (update the DT)

I haven't had time to really look at the overlay stuff, but I guess it will then
just
	- probe bridge drivers with 'status = "okay"' which will probe subdevices

Question is: who will remove the bridge driver? Do the DT overlays do that kind
of stuff?

With the FPGA2HPS(SDRAM) bridges it gets a little difficult I guess.
Who is the master on the FPGA2HPS bridge? Depends on your FPGA config.

Regards,
Steffen
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
