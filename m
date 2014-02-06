Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaBFVJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:09:14 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39751 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaBFVJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:09:11 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: Bastien Traverse <bastien.traverse@gmail.com>
Cc: linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Thu, 06 Feb 2014 22:08:25 +0100
Message-ID: <5898085.IKVHQGKOYn@al>
User-Agent: KMail/4.12.2 (Linux/3.13.1-2.1-ARCH; KDE/4.12.2; x86_64; ; )
In-Reply-To: <52F2CC7B.80406@gmail.com>
References: <52F2CC7B.80406@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 February 2014 00:42:51 Bastien Traverse wrote:
> I just used my Ethernet NIC for the first time on an up-to-date
> Archlinux; it was working fine until I suspended to RAM: on resume the
> Realtek/Ethernet device had completely disappeared.
> 
> The two entries absent from lspci output after resume are:
> $ sudo lspci -v
[..]
> 03:00.2 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0a)
>         Subsystem: CLEVO/KAPOK Computer Device 0540
>         Flags: bus master, fast devsel, latency 0, IRQ 45
>         I/O ports at e000 [size=256]
>         Memory at f0a04000 (64-bit, prefetchable) [size=4K]
>         Memory at f0a00000 (64-bit, prefetchable) [size=16K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [70] Express Endpoint, MSI 01
>         Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
>         Capabilities: [d0] Vital Product Data
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [160] Device Serial Number 02-00-00-00-68-4c-e0-00
>         Kernel driver in use: r8169
>         Kernel modules: r8169

I also have an affected laptop where the network and MMC controller
vanishes on resume. The laptop is also from Clevo, but a different
model: Clevo B7130. I had no issues with my custom kernel
configuration (latest version that I tested was 3.13.1), but at least
the stock Arch kernels from 3.12.2 up to 3.12.6 and 3.13.1 are
affected by this issue.

Reproduce with:

 1. Boot system.
 2. lspci -nnvt > lspci-nnvt.txt
 3. Suspend system (lid close)
 4. lspci -nnvt > lspci-nnvt2.txt
 5. Observe missing network controller (see diff below).

--- boot-3.13.1/lspci-nnvt.txt	2014-02-06 17:11:07.070625446 +0100
+++ boot-3.13.1/lspci-nnvt2.txt	2014-02-06 17:11:19.843386871 +0100
@@ -11,10 +11,7 @@
              +-1a.0  Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b3c]
              +-1b.0  Intel Corporation 5 Series/3400 Series Chipset High Definition Audio [8086:3b56]
              +-1c.0-[02-03]----00.0  NEC Corporation uPD720200 USB 3.0 Host Controller [1033:0194]
-             +-1c.1-[04]--+-00.0  JMicron Technology Corp. SD/MMC Host Controller [197b:2382]
-             |            +-00.2  JMicron Technology Corp. Standard SD Host Controller [197b:2381]
-             |            +-00.3  JMicron Technology Corp. MS Host Controller [197b:2383]
-             |            \-00.5  JMicron Technology Corp. JMC250 PCI Express Gigabit Ethernet Controller [197b:0250]
+             +-1c.1-[04]--
              +-1c.2-[05]----00.0  Intel Corporation Centrino Advanced-N 6200 [8086:422c]
              +-1d.0  Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b34]
              +-1e.0-[06]--

The only difference now is the kernel config. I guess that it comes
from CONFIG_HOTPLUG_PCI. In my non-broken config, it's unset. The
Arch kernel sets CONFIG_HOTPLUG_PCI=y (and also
CONFIG_HOTPLUG_PCI_ACPI=y).

That guess is based on the additional messages I see with the broken config:

    [    1.033628] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
    [    1.033642] pciehp: PCI Express Hot Plug Controller Driver version: 0.4                                                                                                                                                       
    ...
    [  102.704377] iwlwifi 0000:05:00.0: no hotplug settings from platform
    [  103.170193] xhci_hcd 0000:02:00.0: no hotplug settings from platform
    [  103.229008] iwlwifi 0000:05:00.0: no hotplug settings from platform

Before I start bisecting, do you have any ideas to debug this?

The stock config of Arch Linux kernel 3.13.1-2-ARCH can be found on:
https://projects.archlinux.org/svntogit/packages.git/tree/trunk/config.x86_64?h=packages/linux&id=0ea780ba731bd214db3007f57f54a3fad709a078

Regards,
Peter
