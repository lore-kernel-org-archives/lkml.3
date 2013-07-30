Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab3G3HFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:05:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58588 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab3G3HFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:05:37 -0400
Message-ID: <51F7659E.3040302@ti.com>
Date: Tue, 30 Jul 2013 12:35:02 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 4/9] dma: edma: Find missed events and issue them
References: <1375104595-16018-1-git-send-email-joelf@ti.com> <1375104595-16018-5-git-send-email-joelf@ti.com>
In-Reply-To: <1375104595-16018-5-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 July 2013 06:59 PM, Joel Fernandes wrote:
> In an effort to move to using Scatter gather lists of any size with
> EDMA as discussed at [1] instead of placing limitations on the driver,
> we work through the limitations of the EDMAC hardware to find missed
> events and issue them.
> 
> The sequence of events that require this are:
> 
> For the scenario where MAX slots for an EDMA channel is 3:
> 
> SG1 -> SG2 -> SG3 -> SG4 -> SG5 -> SG6 -> Null
> 
> The above SG list will have to be DMA'd in 2 sets:
> 
> (1) SG1 -> SG2 -> SG3 -> Null
> (2) SG4 -> SG5 -> SG6 -> Null
> 
> After (1) is succesfully transferred, the events from the MMC controller
> donot stop coming and are missed by the time we have setup the transfer
> for (2). So here, we catch the events missed as an error condition and
> issue them manually.

Are you sure there wont be any effect of these missed events on the
peripheral side. For example, wont McASP get into an underrun condition
when it encounters a null PaRAM set? Even UART has to transmit to a
particular baud so I guess it cannot wait like the way MMC/SD can.

Also, wont this lead to under-utilization of the peripheral bandwith?
Meaning, MMC/SD is ready with data but cannot transfer because the DMA
is waiting to be set-up.

Did you consider a ping-pong scheme with say three PaRAM sets per
channel? That way you can keep a continuous transfer going on from the
peripheral over the complete SG list.

Thanks,
Sekhar

