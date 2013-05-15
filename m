Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab3EOJUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:20:55 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:30838 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3EOJUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:20:53 -0400
Date: Wed, 15 May 2013 11:20:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Robert Norris <robn@opera.com>
Cc: linux-kernel@vger.kernel.org, Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: PROBLEM: modprobe hang at startup (3.8.x, 3.9.x, IBM x3550)
Message-ID: <20130515112044.753bb7bb@endymion.delvare>
In-Reply-To: <20130514231626.GA12961@pyro.melbourne.osa>
References: <1368408152.29197.140661229821177.2C1CC406@webmail.messagingengine.com>
	<20130514231626.GA12961@pyro.melbourne.osa>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Adding the linux-i2c list to Cc.

On Wed, 15 May 2013 09:16:26 +1000, Robert Norris wrote:
> On Mon, May 13, 2013 at 11:22:32AM +1000, Robert Norris wrote:
> > We have a number of Intel x3550 servers (Intel 5000-series). They've
> > been running 3.7.2 fine.
> > 
> > In the last week I've run 3.8.11, 3.8.12 and 3.9.2 on them. All have
> > long hangs at boot, and later hung tasks in modprobe.
> 
> I bisected this and tracked it to this commit:
> 
>     commit 6676a847d48ac48908cf467b42da9045b5463a6e
>     Author: Jean Delvare <khali@linux-fr.org>
>     Date:   Sun Dec 16 21:11:55 2012 +0100
> 
>         i2c-i801: Enable interrupts for all post-ICH5 chips
>         
>         I did not receive a single bug report after interrupt support was
>         added for a limited number of chips. So I'd say the code is good and
>         should be enabled for all supported chips, that is: ICH5 and later.
>         
>         Signed-off-by: Jean Delvare <khali@linux-fr.org>
>         Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
> 
> I've tested by building 3.9.2 with that single commit reverted, and it
> boots without issue.

Thanks a lot for reporting and even more for bisecting it, I know it
takes time. I apologize for the trouble. I suppose I should have been a
bit more cautious with the 63xxESB chips as they are a different family
of hardware.

> According to lspci I have:
> 
>     00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus Controller (rev 09)
> 
> Which has PCI ID 0x269b (ie PCI_DEVICE_ID_INTEL_ESB2_17).


Can you share the full output of lspci -s 00:1f.3 -vv?

I'm also curious if the SMBus controller shares its interrupt line with
another chip. /proc/interrupts should tell but you'll have to make one
of your systems hang again.

> For now I will either revert this commit in my kernel builds or
> blacklist the module on these machines (I haven't decided which I prefer
> yet).

You can also pass parameter disable_features=0x10 to the i2c-i801
driver, this will disable interrupt support without having to rebuild
the driver. I suppose this could be documented in more details in
modinfo, I'll work on that.

> Obviously, I can reproduce this reliably, and am happy to test.

Thanks for the offer. Right now I am stuck in bed and must take some
rest. When I feel better I'll see if I can gain access to systems with
Intel 63xxESB chips to try and reproduce the hang you're seeing. I'll
also take a look at the datasheets again to see if any difference stands
out.

For the time being I plan to simply disable interrupt support again for
the ESB chips, until we fully understand what happens on your systems.

As far as debugging goes, please tell me if you have any I2C/SMBus
slave device driver loaded (check in /sys/bus/i2c/drivers.) Loading the
i2c-i801 driver doesn't do much on its own if there are no slave device
drivers using it.

Thanks,
-- 
Jean Delvare
