Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab3DAVs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:48:28 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:38090 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758291Ab3DAVs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:48:26 -0400
Message-ID: <515A00A6.7000301@fold.natur.cuni.cz>
Date: Mon, 01 Apr 2013 23:48:22 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Zheng Yan <zheng.z.yan@intel.com>
Subject: Re: [Update][PATCH] PCI / PM: Disable runtime PM of PCIe ports
References: <2282655.IicBMMa6jN@vostro.rjw.lan> <1378320.ernsY1JWPv@vostro.rjw.lan> <CAErSpo7kGBNEkLOftJ1J7ivaxZL-yVWyAwmoiQ1=NADpmJ67XA@mail.gmail.com> <3943547.m5K1tfygWn@vostro.rjw.lan> <CAErSpo5iyziiGDKiy-416UQ2xr+2hvcHz6do+ueMmnPM5oy6Cw@mail.gmail.com>
In-Reply-To: <CAErSpo5iyziiGDKiy-416UQ2xr+2hvcHz6do+ueMmnPM5oy6Cw@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Mon, Apr 1, 2013 at 2:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Monday, April 01, 2013 11:34:46 AM Bjorn Helgaas wrote:
>>> [+cc Zheng, who added this with 71a83bd727]
>>>
>>> On Sat, Mar 30, 2013 at 4:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>>
>>>> The runtime PM of PCIe ports turns out to be quite fragile, as in
>>>> some cases things work while in some other cases they don't and we
>>>> don't seem to have a good way to determine whether or not they are
>>>> going to work in advance.
>>>
>>> Do you have any references to problems encountered when enabling
>>> runtime PM for PCIe ports?  That information will be useful to anybody
>>> who wants to take another crack at getting this working.
>>
>> Well, bug 53811 is one example and problems recently reported by
>> Martin are another.  Do you want me to dig deeper?
> 
> OK, I got this one:
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=53811
> 
> Martin has reported a lot of problems lately, and I don't know which
> are related to runtime PM for PCIe ports.  I was hoping for a couple
> URLs to put in the changelog so that when somebody gets the itch to
> make this work, they have some useful info to start from.  If you
> point me at a specific message, I'll dig up an archive URL for it.

In the thread

Re: 3.8.2: xhci port is dead until pcieport PME# goes to disabled
http://marc.info/?t=136328222600002&r=1&w=2

I reported that if an upstream express root port 1c.4 of the xHCI controller
at 0b:00 is suspended the USB3 socket on the laptop appears dead.
Initially I found that 'lsusb -v' rescues the dead socket and is accompanied
by these in logs:

[ 1445.597641] pcieport 0000:00:1c.4: PME# disabled
[ 1445.617667] xhci_hcd 0000:0b:00.0: PME# disabled

Ying Huang then realized elsewhere I am running laptop-mode-tools although
in their config file I set that they should NOT be run when on AC power.
Looks they do enable 'auto' power mode as seen in
/sys/bus/pci/devices/*/power/control files already upon bootup.
BTW, even worse, if I do /etc/init.d/laptop-mode-tools stop
they restore to some initial values. :(( So, if I meanwhile forced
'on' for some device they will return me back to 'auto' and the device
will immediately do suspend. ;-)

Provided I uninstalled the laptop-mode-tools and made sure all control
files say 'on' (and hence runtime_status files say 'active') then
my problem is with a dead xHCI port 'obeyed'.

Myself it weird that suspend of the port happens only upon USB device
unplug. The port does not suspend by itself if unused.


What is not clear to me how kernel is going to handle laptop-mode-tools
which enabled powersaving on the 1c.4. In my naive, user view kernel does
not realize and *check* that no user tool or a desperate user tried to
suspend an upstream port while there is something bound to it and it
does not apply a check for cascaded devices (1c.4 > 0b:00 and
1c.7 -> 11:00 in my case).

I am writing this without a reference but modprobe of a driver can overcome
suspended root port. I am in this particular case meaning my 1c.7 port
and its downstream 11:00 express card device. From the top of my head
I am not sure if modprobe overcame both 1c.7 and 11:00 being initially
suspended. I could dig it out from the

Re: 3.9-rc1: pciehp and eSATA card SiI 3132, no XHCI
http://marc.info/?t=136305008800001&r=1&w=2

thread if you want. Or it might be easier for you to test it yourself.



So, for me the issue is not fixed but if you decide to disable runtime
power saving for devices under pcieport I don't mind. Their mishandling
definitely causes my acpiphp hotplug issues under 3.7-3.8 kernels
(3.9-rc not tested) whereas these PM issues do not answer why pciehp
is broken on 3.7-3.9-rc1.


Anyway, this patch maybe only good because I would like to use the
laptop-mode-tools and they for sure will put one of the devices into 'auto'
and it will likely fall into suspend.
Martin



> 
> Otherwise, I'm afraid we'll just oscillate between "enable PM, find
> bug, disable PM, enable PM, find same bug, disable PM, etc..."
> 
> Bjorn
> 
>>>> For this reason, avoid enabling runtime PM for PCIe ports by
>>>> keeping their runtime PM reference counters always above 0 for the
>>>> time being.
>>>>
>>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>> ---
>>>>
>>>> This version also removes the no longer necessary (and empty anyway)
>>>> port_runtime_pm_black_list[] table.
>>>>
>>>> Thanks,
>>>> Rafael
>>>>
>>>> ---
>>>>  drivers/pci/pcie/portdrv_pci.c |   13 -------------
>>>>  1 file changed, 13 deletions(-)
>>>>
>>>> Index: linux-pm/drivers/pci/pcie/portdrv_pci.c
>>>> ===================================================================
>>>> --- linux-pm.orig/drivers/pci/pcie/portdrv_pci.c
>>>> +++ linux-pm/drivers/pci/pcie/portdrv_pci.c
>>>> @@ -185,14 +185,6 @@ static const struct dev_pm_ops pcie_port
>>>>  #endif /* !PM */
>>>>
>>>>  /*
>>>> - * PCIe port runtime suspend is broken for some chipsets, so use a
>>>> - * black list to disable runtime PM for these chipsets.
>>>> - */
>>>> -static const struct pci_device_id port_runtime_pm_black_list[] = {
>>>> -       { /* end: all zeroes */ }
>>>> -};
>>>> -
>>>> -/*
>>>>   * pcie_portdrv_probe - Probe PCI-Express port devices
>>>>   * @dev: PCI-Express port device being probed
>>>>   *
>>>> @@ -225,16 +217,11 @@ static int pcie_portdrv_probe(struct pci
>>>>          * it by default.
>>>>          */
>>>>         dev->d3cold_allowed = false;
>>>> -       if (!pci_match_id(port_runtime_pm_black_list, dev))
>>>> -               pm_runtime_put_noidle(&dev->dev);
>>>> -
>>>>         return 0;
>>>>  }
>>>>
>>>>  static void pcie_portdrv_remove(struct pci_dev *dev)
>>>>  {
>>>> -       if (!pci_match_id(port_runtime_pm_black_list, dev))
>>>> -               pm_runtime_get_noresume(&dev->dev);
>>>>         pcie_port_device_remove(dev);
>>>>         pci_disable_device(dev);
>>>>  }
>>>>
>> --
>> I speak only for myself.
>> Rafael J. Wysocki, Intel Open Source Technology Center.
> 
> 
