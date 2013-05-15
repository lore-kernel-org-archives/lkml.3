Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab3EOTtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:49:35 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:4869 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab3EOTte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:49:34 -0400
Date: Wed, 15 May 2013 21:49:23 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Robert Norris <robn@opera.com>
Cc: linux-kernel@vger.kernel.org, Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: PROBLEM: modprobe hang at startup (3.8.x, 3.9.x, IBM x3550)
Message-ID: <20130515214923.036dabdb@endymion.delvare>
In-Reply-To: <20130515112741.GA23766@pyro.melbourne.osa>
References: <1368408152.29197.140661229821177.2C1CC406@webmail.messagingengine.com>
	<20130514231626.GA12961@pyro.melbourne.osa>
	<20130515112044.753bb7bb@endymion.delvare>
	<20130515112741.GA23766@pyro.melbourne.osa>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

On Wed, 15 May 2013 21:27:41 +1000, Robert Norris wrote:
> On Wed, May 15, 2013 at 11:20:44AM +0200, Jean Delvare wrote:
> > Can you share the full output of lspci -s 00:1f.3 -vv?
> 
> 00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus Controller (rev 09)
>     Subsystem: IBM Device 02dd
>     Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
>     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>     Interrupt: pin B routed to IRQ 0

Hmm, this "IRQ 0" is quite odd. I'm wondering if this could be the
reason for this hang. Was it with the i2c-i801 driver loaded, or
blacklisted? Please check if it makes a difference.

Do you see the same (and more generally, this issue) on one, some or
all of your x3550 servers?

Are you using IPMI on these machines?

>     Region 4: I/O ports at 0440 [size=32]
> 
> > I'm also curious if the SMBus controller shares its interrupt line
> > with another chip. /proc/interrupts should tell but you'll have to
> > make one of your systems hang again.
> 
> I'm not sure how to read it, so here it is (3.9.2, immediately after
> boot, no options to i2c_i801):
> 
>            CPU0       CPU1       CPU2       CPU3       
> (...)
>  20:          0          0          0          0   IO-APIC-fasteoi   i801_smbus

Here the IRQ looks correct, and it isn't shared. But I am surprised
that the counters are all 0. If an SMBus transaction had been
attempted, there should be a 1 somewhere, even if the transaction
ultimately failed.

> (...)
> I went with blacklisting for now because this driver doesn't appear to
> be doing anything useful for us (sensors etc are working without it).
> I'll confess to not really knowing much about its purpose though.

It all depends on what I2C/SMBus slaves are connected to the SMBus.
Often there are the SPD EEPROMs from your memory modules, sometimes
with integrated thermal sensors (on DDR3 only - driver is jc42.) And in
your case a clock chip as well, for which IBM contributed a driver.

> > (...)
> > As far as debugging goes, please tell me if you have any I2C/SMBus
> > slave device driver loaded (check in /sys/bus/i2c/drivers.) Loading the
> > i2c-i801 driver doesn't do much on its own if there are no slave device
> > drivers using it.
> 
> $ modprobe i2c-i801 disable_features=0x10
> $ dmesg | tail
> ...
> [28876.193408] i801_smbus 0000:00:1f.3: Interrupt disabled by user
> [28876.201168] ics932s401 4-0069: ics932s401 chip found
> $ ls /sys/bus/i2c/drivers
> dummy  ics932s401

The dummy driver is a helper stub for i2c-core, it doesn't actually
access the SMBus. ics932s401 is for the clock chip, and I know clock
chips can be tricky and error prone. OTOH I can only guess that IBM had
a good reason to contribute the driver and make it auto-load on the
x3550.

I would appreciate if you could test the following:
* Blacklist i2c-i801 and ics932s401 so that none of them get
  auto-loaded.
* Manually load i2c-i801 with interrupts enabled, and see what happens.
* If no hang happens, load i2c-dev, find the i801 bus number with
  i2cdetect -l (from the i2c-tools package - it should be 4 according
  to what you reported so far but there is no guarantee that it won't
  change across reboots.) Then do a simple read from a random address
  with:
  # i2cget 4 0x50 0x00
  (Adjust the bus number as needed.)
  I am curious if this will hang as well or only when accessing the
  clock chip at address 0x69.

Thanks,
-- 
Jean Delvare
