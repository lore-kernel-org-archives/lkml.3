Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab3BPB0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 20:26:08 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:37833 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3BPB0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 20:26:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6x2WXdbO-_qeheQKwqqJ9zze8Z9pnj-wtU0yTJEh-NJg@mail.gmail.com>
References: <CAE9FiQUkmnV_On5+ZpH2pF4Li1HxLpkO8bp4TnYB46=pc9Safg@mail.gmail.com>
	<1360696283-20313-1-git-send-email-yinghai@kernel.org>
	<5988763.6WpnEvTV2f@vostro.rjw.lan>
	<CAE9FiQX=yLyBV3AbP43N91Tx5-ic-f5f+=_r_RBLxq1Ct32Z_Q@mail.gmail.com>
	<CAErSpo6x2WXdbO-_qeheQKwqqJ9zze8Z9pnj-wtU0yTJEh-NJg@mail.gmail.com>
Date: Fri, 15 Feb 2013 17:26:04 -0800
X-Google-Sender-Auth: aOq0HjuviETEaTN2BhHOHBep41Y
Message-ID: <CAE9FiQXan3J7-m2Wgd0pVybed_BgRAiqMGofh7t+vX_6e8zh7g@mail.gmail.com>
Subject: Re: [PATCH] ACPI, PCI: Get PRT entry during acpi_pci_enable_irq()
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 4:39 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Feb 14, 2013 at 5:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Tue, Feb 12, 2013 at 12:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> On Tuesday, February 12, 2013 11:11:23 AM Yinghai Lu wrote:
>>>> Peter Hurley found "irq 18 nobody cared" with pci-next, and dmesg has
>>>>
>>>> [    8.983246] pci 0000:00:1e.0: can't derive routing for PCI INT A
>>>> [    8.983600] snd_ctxfi 0000:09:02.0: PCI INT A: no GSI - using ISA IRQ 5
>>>>
>>>> bisect to
>>>> | commit 4f535093cf8f6da8cfda7c36c2c1ecd2e9586ee4
>>>> |     PCI: Put pci_dev in device tree as early as possible
>>>>
>>>> It turns out we need to call acpi_pci_irq_add_prt() after the pci bridges
>>>> are scanned.
>>>>
>>>> Bjorn said:
>>>>  The bus number binding means acpi_pci_irq_add_prt() has to happen
>>>>  after enumerating everything below a bridge, and it will prevent us
>>>>  from doing any bus number reassignment for hotplug.
>>>>
>>>>  I think we should remove the bus numbers from the cached _PRT (or
>>>>  maybe even remove the _PRT caching completely).  When we enable a PCI
>>>>  device's IRQ, we should search up the PCI device tree looking for a
>>>>  _PRT associated with each node, and applying normal PCI bridge
>>>>  swizzling when we don't find a _PRT.  I think this can be done without
>>>>  using PCI bus numbers at all.
>>>>
>>>> So here we try to remove _PRT caching completely.
>>>>
>>>> -v2: check !handle early.
>>>>
>>>> Reported-and-tested-by: Peter Hurley <peter@hurleysoftware.com>
>>>> Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>
>>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>>> ---
>>>>  drivers/acpi/pci_irq.c      |   95 +++++++++++++++++---------------------------
>>>>  drivers/acpi/pci_root.c     |   18 --------
>>>>  drivers/pci/pci-acpi.c      |   24 -----------
>>>>  include/acpi/acpi_drivers.h |    5 --
>>>>  4 files changed, 38 insertions(+), 104 deletions(-)
>>
>> Bjorn,
>>
>> Can you put this one into pci/next?
>
> I'm not sure what this patch is based on or what the best way to merge
> it is.  It doesn't apply cleanly to my next or
> pci/yinghai-root-bus-hotplug branches.

My fault, that is based on pci/next + pm/linux-next

linux-next removed
acpi_power_resource_(un)register_device ...

>
> I did apply it manually on top of pci/yinghai-root-bus-hotplug to try
> it out, but we need to tweak the messages a little bit.
>
> Previously we printed "ACPI: PCI Interrupt Routing Table [%s._PRT]"
> once when loading it, which was fine.  Now we print it every time we
> look at a _PRT, which is too much because it isn't really adding any
> information.
>
> We also print "ACPI Exception: AE_NOT_FOUND, Evaluating _PRT
> [AE_NOT_FOUND] (20121018/pci_irq-259)" if we find ACPI nodes without
> _PRTs, which we shouldn't do, because that's a common and normal
> situation.

Sure. Can you have separated patch to do that ?

Or want me to resend the patch.

Thanks

Yinghai
