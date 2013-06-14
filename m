Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab3FNDaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 23:30:07 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:61145 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3FNDaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 23:30:04 -0400
MIME-Version: 1.0
In-Reply-To: <51BA8524.9050507@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQX1xVJA3MZc4LndWU7kx0mxC-YPE1R8JD4W2-Gg9zq3Zw@mail.gmail.com>
	<51BA7B3D.1020402@huawei.com>
	<CAE9FiQX-jCZYPyxeHCp2h-6qx1GMyQYuaTk5JwZR6H1t4jRg9g@mail.gmail.com>
	<51BA8524.9050507@huawei.com>
Date: Thu, 13 Jun 2013 20:30:03 -0700
X-Google-Sender-Auth: EhI43SRH1IeCNGE8P4HZGqVdUWQ
Message-ID: <CAE9FiQWTD8RpRodPGgZv_ikfVgBnS6GRn2KUJg+5+siFy40Xrg@mail.gmail.com>
Subject: Re: [BUGFIX 0/9] Fix bug 59501 and code improvement for dock driver
From: Yinghai Lu <yinghai@kernel.org>
To: "Jiang Liu (Gerry)" <jiang.liu@huawei.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 7:51 PM, Jiang Liu (Gerry) <jiang.liu@huawei.com> wrote:
> On 2013/6/14 10:30, Yinghai Lu wrote:
>>
>> On Thu, Jun 13, 2013 at 7:09 PM, Jiang Liu (Gerry) <jiang.liu@huawei.com>
>> wrote:
>
> Not sure. But a little concern about check_hotplug_bridge(), it treats
> dock station and devices on dock station with _EJD as hot-plug-gable
> PCI bus and reserve extra resources for possible hot-adding. But I
> think we should only reserve extra resource for dock station, and should
> not reserve resource for devices on station with _EJD method.

That is should be...
if there is children hotplug slots, we should add extra...

>
>
>>
>>>      Currently I'm trying to change acpiphp to respect BIOS resource
>>> assignment by calling pcibios_survey_resource_bus(), as in pci_root.c.
>>> The other way is to change the IOMM resource allocation algorithm,
>>> but obviously it's much more risky of regressions if changing the
>>> algorithm.
>>
>>
>> that is not going to help, need to increase bridge resource.
>>
>> please check if BIOS have setup option about hotplug MMIO pad size.
>
> For the first step, I'm trying to make hotplug case work in the same way as
> boot time. Do you think this patch help?
>
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c
> b/drivers/pci/hotplug/acpiphp_gl
> index 270fdba..12e3f6e 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -837,13 +837,13 @@ static int __ref enable_device(struct acpiphp_slot
> *slot)
>                                 max = pci_scan_bridge(bus, dev, max, pass);
>                                 if (pass && dev->subordinate) {
>                                         check_hotplug_bridge(slot, dev);
> - pci_bus_size_bridges(dev->subordinate);
> + pcibios_resource_survey_bus(dev->subordi
>                                 }
>                         }
>                 }
>         }
>
> -       pci_bus_assign_resources(bus);
> +       pci_assign_unassigned_bus_resources(bus);
>         acpiphp_sanitize_bus(bus);
>         acpiphp_set_hpp_values(bus);
>         acpiphp_set_acpi_region(slot);
> ---

Yes, it should help. but may need to after pcibios_add_bus move down patch.

otherwise, we could enable children slot and survery them and assign
unassigned for them at first
and then go to parent slots.
that will make children slots survey fails, that is too early and
should be done after parent slots.

Yinghai
