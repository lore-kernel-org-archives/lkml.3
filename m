Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaETObG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:31:06 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:39087 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaETObE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:31:04 -0400
MIME-Version: 1.0
In-Reply-To: <4223392.yrWc3QAXY9@wuerfel>
References: <1400422125-2209-1-git-send-email-sthokal@xilinx.com>
	<4223392.yrWc3QAXY9@wuerfel>
Date: Tue, 20 May 2014 20:01:01 +0530
X-Google-Sender-Auth: -qZ5oDMmRpL8UHTkx854Nu0PXWE
Message-ID: <CA+mB=1KsxjJR0Yswmo2y_Gej64OPZLddXxJ+qn8YOx7=_EsqeA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Generic Configuration Access Mechanism support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Srikanth Thokala <sthokal@xilinx.com>, Bjorn Helgaas <bhelgaas@google.com>,
        will.deacon@arm.com, michals@xilinx.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, May 19, 2014 at 10:33 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 18 May 2014 19:38:45 Srikanth Thokala wrote:
>> +
>> +     if (cfg->ops->is_valid_cfg_access) {
>> +             if (!cfg->ops->is_valid_cfg_access(bus, devfn)) {
>> +                     *val = PCI_CFG_INVALID_DEVFN;
>> +                     return PCIBIOS_DEVICE_NOT_FOUND;
>> +             }
>> +     }
>
> Can you explain why this callback is needed? If the space for the
> bus is mapped, any access should just work.

As I was explaining to Will, there are some controllers which doesn't
return FF's
when a device is not found on the bus (as per the PCI specification) and
accessing such a device address from the kernel results in an external abort.
So, I added this additional logic in my driver to bypass this and
return FF's. Our IP
and even other controllers like Tegra, Renesas have similar implementation.
We cant think of a better solution and please let you us know if you
have any inputs.

Thanks
Srikanth

>
>> +
>> +/* Generic PCI CAM/ECAM Configuration Bus Operations */
>> +
>> +struct pci_cfg_bus_ops pci_cfg_cam_bus_ops = {
>> +     .bus_shift      = PCI_CFG_CAM_BUS_NUM,
>> +     .map_bus        = pci_cfg_map_bus_cam,
>> +};
>> +EXPORT_SYMBOL_GPL(pci_cfg_cam_bus_ops);
>> +
>> +struct pci_cfg_bus_ops pci_cfg_ecam_bus_ops = {
>> +     .bus_shift      = PCI_CFG_ECAM_BUS_NUM,
>> +     .map_bus        = pci_cfg_map_bus_ecam,
>> +};
>> +EXPORT_SYMBOL_GPL(pci_cfg_ecam_bus_ops);
>> +
>> +struct pci_ops pci_cfg_ops = {
>> +     .read   = pci_cfg_read,
>> +     .write  = pci_cfg_write,
>> +};
>> +EXPORT_SYMBOL_GPL(pci_cfg_ops);
>
>
> If we can find a way to remove the is_valid_cfg_access() check, we're
> probably better off removing the cfg_bus_ops as well, and exporting
> two sets of pci_ops. There will be a little more duplication here, but
> also less complexity in this module, and more importantly in the drivers
> using it.
>
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
