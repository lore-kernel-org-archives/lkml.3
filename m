Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3KSSIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:08:12 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:35854 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3KSSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:08:07 -0500
MIME-Version: 1.0
In-Reply-To: <20131119055714.GA3451@adam-laptop>
References: <1384767652-20567-1-git-send-email-adam.lee@canonical.com>
	<CAErSpo7bERHRbBNOzb6g+666jMmFXQvv2T2U6dv82fVh1dU5kA@mail.gmail.com>
	<20131119055714.GA3451@adam-laptop>
Date: Tue, 19 Nov 2013 11:08:06 -0700
Message-ID: <CAL-B5D2WtALi5RMX9JQQmVUShLEN947cdvr7jjnpfCXS3zmPVw@mail.gmail.com>
Subject: Re: [PATCH] pci: check PCI_EXP_FLAGS_SLOT before setting hotplug bridge
From: Myron Stowe <myron.stowe@gmail.com>
To: Adam Lee <adam.lee@canonical.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Amos Kong <kongjianjun@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>, Thomas Renninger <trenn@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:57 PM, Adam Lee <adam.lee@canonical.com> wrote:
> On Mon, Nov 18, 2013 at 10:38:17AM -0700, Bjorn Helgaas wrote:
>> [+cc Myron, Amos, Thomas, Ben]
>>
>> On Mon, Nov 18, 2013 at 2:40 AM, Adam Lee <adam.lee@canonical.com> wrote:
>> > This patch adds the PCI_EXP_FLAGS_SLOT check back before setting
>> > hotplug bridge, which is omitted by an API switching commit,
>> > 59875ae489609b2267548dc85160c5f0f0c6f9d4 "PCI/core: Use PCI Express
>> > Capability accessors".
>> >
>> > Some Lenovo laptops hang in booting without this fix.
>>
>> What kernel version hangs?  I suspect you might be missing 6d3a1741f1
>> ("PCI: Support PCIe Capability Slot registers only for ports with
>> slots"), because it *looks* like the current kernel should work
>> correctly even without your patch.
>
> No, patching 6d3a1741f1 and d3694d4fa3 doesn't fix the hang.

Did you actually try it?  This patch did solve a problem that I
encountered (see below).
>
> It hangs in acpi_evaluate_integer() from
> 59875ae489609b2267548dc85160c5f0f0c6f9d4 "PCI/core: Use PCI Express
> Capability accessors" and before
> ac212b6980d8d5eda705864fc5a8ecddc6d6eacc "ACPI / processor: Use common
> hotplug infrastructure", 3.4~3.11. (double confirmed)
>
> I didn't mention this because:
> 1, that check is omitted obviously, an API switching patch should not
> remove things like that.

That's the confusing thing - the check *is* still there (although it
is somewhat less explicit than it was before) ...

The current internal path for 'set_pcie_hotplug_bridge' is:
  pcie_capability_read_dword
    pcie_capability_reg_implemented
      pcie_cap_has_sltctl
        ...
        pcie_caps_reg(dev) & PCI_EXP_FLAGS_SLOT

The current version is using a cached copy of the PCIe capabilities
reg - 'pcie_flags_reg' - so perhaps you are running into a case of
using 'set_pcie_hotplug_bridge' before 'pcie_flags_reg' has been set?


A little off topic here, but it does show the check is there and, with
commit 6d3a174, works.  I ran into a case where the platform had
values in the "slot capabilities register" even though the "express
capabilities register" indicated the platform had no slots (see data
below).  If there are no slots the platform's hardware or BIOS are
supposed to set the "slot capabilities register" with 0's - this
wasn't the case ;/

Due to the parenthesis prior to commit 6d3a174,
'set_pcie_hotplug_bridge' returned true in this case.  Commit
6d3a174's fixing of the parenthesis fixed that case due to the check
that you seem to think is missing - pcie_caps_reg(dev_ &
PCI_EXP_FLAGS_SLOT - and now 'set_pcie_hotplug_bridge' correctly
returns false in such a scenario.

Data from scenario -
    This device's configuration, as interpreted by 'lspci' is:
      00:1c.0 PCI bridge: Intel Corporation C600/X79 series chipset PCI
      Express Root Port 1 (rev b5) (prog-if 00 [Normal decode])
          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
                   ParErr+ Stepping- SERR+ FastB2B- DisINTx-
          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
                  <TAbort- <MAbort- >SERR- <PERR- INTx-
          Latency: 0, Cache Line Size: 64 bytes
          Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
          Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
                            <TAbort- <MAbort+ <SERR- <PERR-
          BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                  PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
          Capabilities: [40] Express (v2) Root Port (Slot-), MSI 00

    Note that its "Capabilities:" "Slot" entry is '-' which means that it
    is not connected to a slot [4].  This is confirmed by looking at the
    un-interpreted configuration space of the device:
      # lspci -s00:1c.0 -xxx
      00:1c.0 PCI bridge: Intel Corporation C600/X79 series chipset PCI
      Express Root Port 1 (rev b5)
      00: 86 80 10 1d 47 01 10 00 b5 00 04 06 10 00 81 00
      10: 00 00 00 00 00 00 00 00 00 08 08 00 10 10 00 00
      20: 20 f0 30 f0 41 f0 51 f0 00 00 00 00 00 00 00 00
      30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 01 03 00
      40: 10 80 42 00 00 80 00 00 06 00 10 00 42 4c 11 01
      50: 10 00 01 18 60 00 04 00 00 00 40 00 06 00 00 00
      60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
      70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
      80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      90: 0d a0 00 00 3c 10 a9 18 00 00 00 00 00 00 00 00
      a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
      b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      d0: 00 00 00 01 02 0b 00 00 00 80 11 01 00 00 00 00
      e0: 00 3f 00 00 00 00 00 00 01 00 00 00 00 00 00 00
      f0: 00 00 00 00 00 00 00 00 87 0f 07 08 00 00 00 00

    The "PCI Express Capabilities Register" is at offset 0x02 (The PCI
    Express Capability Structure starts at offset 0x40).  So looking at
    offset 0x42 we see the 16-bit register value of 0x0042.  The "Slot
    Implemented" bit is not set confirming the 'lspci' interpretation.

    The "Slot Capabilities Register" is at offset 0x14.  This register exists
    regardless of whether or not a slot is implemented [4].  Since the PCI
    Express Capabilities Register" indicates that the slot is not implemented
    the Slot Capabilities, Status, and Control registers should be hardwired
    to 0 [4].  If we look at the "Slot Capabilities Register", which is
    what 'set_pcie_hotplug_bridge' is reading, we see that it is 0x00040060.
      # setpci -s00:1c.0 0x54.L
      00040060

    So, while the device in question does not implement a slot its "Slot
    Capabilities Register" is erronously indicating that it's "Hot-Plug
    Capable".

    This register has an "HwInit" attribute which indicates that it is either
    hard-wired, or set by firmware.  It is read-only from the OSs perspective
    indicating that it can't be changed.  This seems to suggest that this
    particular p2p bridge device can never be enabled (thus can never support
    slots as its value currently indicates it can).

> 2, have run some tests, adding the check back is harmless.

It's redundant

> 3, I believe ac212b6 just workarounds the hang unexpectedly, bug still
> exists.

I took a quick look at commit ac212b6 and did not see any obvious
relationship to 'set_pcie_hotplug_bridge'.  Can you point that out?

Myron

>
> --
> Adam Lee
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
