Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab3EGVjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:39:13 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:43687 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3EGVjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:39:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130507213250.GA22773@google.com>
References: <5AA430FFE4486C448003201AC83BC85E03DEA379@EXHQ.corp.stratus.com>
 <1366940827-15336-1-git-send-email-yinghai@kernel.org> <20130507213250.GA22773@google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 7 May 2013 14:38:50 -0700
Message-ID: <CAErSpo635J8+p-0-CtxxTJdTRB70zKVYwOF+fmt3kcj6tpz_0Q@mail.gmail.com>
Subject: Re: [PATCH] PCI: move down pci_fixup_final for hotplug path
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Bulkow <David.Bulkow@stratus.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 2:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Apr 25, 2013 at 06:47:07PM -0700, Yinghai Lu wrote:
>> David found some resource conflict issue after
>> | PCI: Put pci_dev in device tree as early as possible
>> | commit 4f535093cf8f6da8cfda7c36c2c1ecd2e9586ee4
>>
>> and
>> | USB: Fix handoff when BIOS disables host PCI device
>> | commit: cab928ee1f221c9cc48d6615070fefe2e444384a
>>
>> for usb qirks for hotplug path.
>>
>> After checking pci_fixup_device() with pci_fixup_final,
>> now we have different path for boot path and hotadd path.
>>
>> Boot path: because pci_apply_fix_final_quirks is not set yet,
>>       so pci_fixup_device(pci_fixup_final) will be skipped
>>       from pci_device_add().
>>         And later pci_apply_final_quirks will be called for all
>>       pci devices via fs_initcall.
>>       That is after pci_assign_unassign resource.
>>       In that case quirk could use bars with problem.
>>
>> Hotadd path: pci_fixup_device(pci_fixup_final) will be executed
>>       via pci_device_add(), and that is too early for hotplug
>>       path, as pci bar for hot add devices is not assigned yet
>>       after commit 4f535093.
>>
>> So we need to move down that for hotplug path, call that in
>> pci_bus_add_devices instead, as at that time just before
>> drivers get attached.
>> And that is simliar calling place for pci_device_add before
>> commit 4f535093 is applied.
>>
>> We should apply this fix for v3.9, but is too late now.
>> so get it into v3.10 and could get into v3.9 stable instead.
>>
>> Reported-by: David Bulkow <David.Bulkow@stratus.com>
>> Tested-by: David Bulkow <David.Bulkow@stratus.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> I applied the following slightly tweaked patch to for-linus and will
> ask Linus to pull it for v3.10.  Let me know if it looks OK.
>
> Bjorn
>
> commit a939563f3fd9cd6226c7fb7135d0b93507c53888
> Author: Bjorn Helgaas <bhelgaas@google.com>

(I did already fix the Author: to be Yinghai, sorry about that)

> Date:   Tue May 7 14:35:44 2013 -0600
>
>     PCI: Delay final fixups until resources are assigned
>
>     Commit 4f535093cf "PCI: Put pci_dev in device tree as early as possible"
>     moved final fixups from pci_bus_add_device() to pci_device_add().  But
>     pci_device_add() happens before resource assignment, so BARs may not be
>     valid yet.
>
>     Typical flow for hot-add:
>
>         pciehp_configure_device
>           pci_scan_slot
>             pci_scan_single_device
>               pci_device_add
>                 pci_fixup_device(pci_fixup_final, dev)  # previous location
>           # resource assignment happens here
>           pci_bus_add_devices
>             pci_bus_add_device
>               pci_fixup_device(pci_fixup_final, dev)    # new location
>
>     [bhelgaas: changelog, move fixups to pci_bus_add_device()]
>     Reference: https://lkml.kernel.org/r/20130415182614.GB9224@xanatos
>     Reported-by: David Bulkow <David.Bulkow@stratus.com>
>     Tested-by: David Bulkow <David.Bulkow@stratus.com>
>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     CC: stable@vger.kernel.org  # v3.9+
>
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 748f8f3..32e66a6 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -174,6 +174,7 @@ int pci_bus_add_device(struct pci_dev *dev)
>          * Can not put in pci_device_add yet because resources
>          * are not assigned yet for some devices.
>          */
> +       pci_fixup_device(pci_fixup_final, dev);
>         pci_create_sysfs_dev_files(dev);
>
>         dev->match_driver = true;
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 43ece5d..67cd045 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1341,7 +1341,6 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>         list_add_tail(&dev->bus_list, &bus->devices);
>         up_write(&pci_bus_sem);
>
> -       pci_fixup_device(pci_fixup_final, dev);
>         ret = pcibios_add_device(dev);
>         WARN_ON(ret < 0);
>
