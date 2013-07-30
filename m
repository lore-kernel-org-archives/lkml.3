Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab3G3Dug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:50:36 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:13572 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab3G3Due (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:50:34 -0400
Message-ID: <51F73730.9070402@huawei.com>
Date: Tue, 30 Jul 2013 11:46:56 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>, Paul Bolle <pebolle@tiscali.nl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>, Oliver Neukum <oneukum@suse.de>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH -v3 3/3] PCI,pciehp: use PCIe DSN to identify device change
 during suspend
References: <1373621543-54836-1-git-send-email-wangyijing@huawei.com> <1373621543-54836-4-git-send-email-wangyijing@huawei.com> <CAErSpo4XhONYq3CZnPKgdMD4V5o8fgFc=NGVUGgFz0y5zM3GyA@mail.gmail.com>
In-Reply-To: <CAErSpo4XhONYq3CZnPKgdMD4V5o8fgFc=NGVUGgFz0y5zM3GyA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not sure this is implemented at the correct place.  The idea of
> using the serial number to detect card swaps is not really specific to
> pciehp.  I know the Device Serial Number capability is defined in the
> PCIe spec, but it doesn't *require* any PCIe functionality, and
> there's no reason a similar capability couldn't be defined for
> conventional PCI.
> 
> I don't know much about it, but conventional PCI *does* in fact
> support the VPD capability, which can contain a serial number.  I
> wonder if we should enhance pci_device_serial_number() to look for a
> VPD serial number if there's no PCIe DSN.  Then we would want this
> check for card swap in a more generic place, e.g., somewhere in
> pci_scan_slot(), so all forms of hotplug would benefit from it.

Hi Bjorn,
   I'm reworking this patch, but found some strange info about vpd serial number.
I have two x86 machines, they almost have the same hardware topology. But by lspci,
I found two different Broadcom BCM5709 NIC in different machine have the same vpd serial
number. If this is normal, vpd serial number seems to be useless for identify device change.

The first machine:
linux:/home/yijing # lspci -vvv -s 0000:01:00.0
01:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 20)
	Subsystem: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 28
	Region 0: Memory at c0000000 (64-bit, non-prefetchable) [size=32M]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
		Product Name: Broadcom NetXtreme II Ethernet Controller
		Read-only fields:
			[PN] Part number: BCM95706A0
			[EC] Engineering changes: 220197-2
			[SN] Serial number: 0123456789
			[MN] Manufacture ID: 31 34 65 34
			[RV] Reserved: checksum good, 31 byte(s) reserved
		End
	Capabilities: [58] MSI: Enable- Count=1/16 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
        ..............[snip]...................

The second machine:
linux-suse-vmdq:~/pciutils-3.2.0 # ./lspci -vvv -s 01:00.0
01:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 20)
	Subsystem: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 28
	Region 0: Memory at f6000000 (64-bit, non-prefetchable) [size=32M]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
		Product Name: Broadcom NetXtreme II Ethernet Controller
		Read-only fields:
			[PN] Part number: BCM95706A0
			[EC] Engineering changes: 220197-2
			[SN] Serial number: 0123456789
			[MN] Manufacture ID: 31 34 65 34
			[RV] Reserved: checksum good, 31 byte(s) reserved
		End
	.......[snip]........


> 
> Also, I think it's possible to use acpiphp for ExpressCard slots, and
> this patch doesn't help acpiphp detect card swaps.  I don't see any
> mention of suspend/resume in acpiphp, so I don't know if it does
> anything at all to detect card changes while suspended.  Maybe Rafael
> can shed some light?
> 
> I put the first two patches on a pci/yijing-dsn-v3 branch while we
> work out the details of this one.
> 
> Bjorn
> 
>>         } else if (!list_empty(&pbus->devices)) {
>>                 pciehp_disable_slot(slot);
>>         }
>> --
>> 1.7.1
>>
>>
> 
> .
> 


-- 
Thanks!
Yijing

