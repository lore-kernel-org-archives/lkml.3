Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbaCDJHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:07:30 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59615 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbaCDJHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:07:03 -0500
Date: Tue, 04 Mar 2014 10:06:50 +0100
From: Christian Riesch <christian.riesch@omicron.at>
To: Jon Ringle <jon@ringle.org>
cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, netdev@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: Ethernet controller not starting
Message-ID: <71F7AD3B89A7BF1E126CB3B1@C9882B18C00BA04428877CD4>
X-Mailer: Mulberry/4.0.8 (Win32)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ed netdev and davinci-linux-open-source]

--On March 03, 2014 19:39 -0500 Jon Ringle <jon@ringle.org> wrote:

> On Mon, Mar 3, 2014 at 6:43 PM, Rafael J. Wysocki <rjw@rjwysocki.net>
> wrote:
>> On Monday, March 03, 2014 02:41:01 PM Jon Ringle wrote:
>>> I'm working on porting an ARM board from linux-3.10 to linux-3.12 (now
>>> the latest LTS kernel).
>>> I found that Ethernet controller on the board no longer comes up on
>>> linux-3.12. I was able to bisect the issue I'm having to the following
>>> commit:
>>>
>>> >   45f0a85c8258741d11bda25c0a5669c06267204a is the first bad commit
>>> >   commit 45f0a85c8258741d11bda25c0a5669c06267204a
>>> >   Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> >   Date:   Mon Jun 3 21:49:52 2013 +0200
>>> >
>>> >       PM / Runtime: Rework the "runtime idle" helper routine
>>> >
>>> >       The "runtime idle" helper routine, rpm_idle(), currently ignores
>>> >       return values from .runtime_idle() callbacks executed by it.
>>> >       However, it turns out that many subsystems use
>>> >       pm_generic_runtime_idle() which checks the return value of the
>>> >       driver's callback and executes pm_runtime_suspend() for the
>>> >       device unless that value is not 0.  If that logic is moved to
>>> >       rpm_idle() instead, pm_generic_runtime_idle() can be dropped
>>> >       and its users will not need any .runtime_idle() callbacks any
>>> >       more.
>>> >
>>> >       Moreover, the PCI, SCSI, and SATA subsystems' .runtime_idle()
>>> >       routines, pci_pm_runtime_idle(), scsi_runtime_idle(), and
>>> >       ata_port_runtime_idle(), respectively, as well as a few drivers'
>>> >       ones may be simplified if rpm_idle() calls rpm_suspend() after
>>> >       0 has been returned by the .runtime_idle() callback executed by
>>> >       it.
>>> >
>>> >       To reduce overall code bloat, make the changes described above.
>>> >
>>> >       Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>>> >       Tested-by: Kevin Hilman <khilman@linaro.org>
>>> >       Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> >       Acked-by: Kevin Hilman <khilman@linaro.org>
>>> >       Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
>>> >       Acked-by: Alan Stern <stern@rowland.harvard.edu>
>>>
>>> Can anyone offer any suggestions on what I should be looking for to
>>> fix this on my board?
>>
>> Any pointers to the driver in question?
>
> drivers/net/ethernet/ti/davinci_emac.c
>

Hi Jon,
I have successfully used the davinci_emac driver on a custom board with an 
AM1808 SoC with Kernel 3.13 a few weeks ago. So at least 3.13 should work. 
Did you try more recent kernel versions than 3.12?

> I also get the following output:
>
>          Starting Network Manager Wait Online...
> [   30.946509] davinci_mdio davinci_mdio.0: resetting idled controller
> [   30.953220] net net0: attached PHY driver [Generic PHY]
> (mii_bus:phy_addr=davinci_mdio-0:00, id=7c0f1)
> [   30.962938] IPv6: ADDRCONF(NETDEV_UP): net0: link is not ready
> [   31.082087] genirq: Flags mismatch irq 33. 00000000 (net0) vs.
> 00000000 (net0)

Is it correct that this warning can only appear in case of shared 
interrupts? See kernel/irq/manage.c. Since we don't use shared interrupts 
here: Are you sure your board configuration is correct with regard to emac 
interrupts? Is your configuration using device tree or not (my 
configuration is a none-devicetree one)? I also wonder why your network 
device is net0, on my board it's eth0, maybe this triggers some bug?

Christian



