Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbaEOUS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:18:26 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:38676 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaEOUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:18:23 -0400
MIME-Version: 1.0
In-Reply-To: <15599140.PsD4j7x3tZ@wuerfel>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org>
	<1400113986-339-7-git-send-email-abrestic@chromium.org>
	<15599140.PsD4j7x3tZ@wuerfel>
Date: Thu, 15 May 2014 13:18:22 -0700
X-Google-Sender-Auth: 1TQ0FIfC8DaS1loxlntNyyVOX5o
Message-ID: <CAL1qeaHm7U2NVDeVZS-Tiz5ntkk4c13RR_1ws9MTYGGoGCOB5A@mail.gmail.com>
Subject: Re: [RFC PATCH 06/10] usb: xhci: Add Tegra XHCI host-controller driver
From: Andrew Bresticker <abrestic@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-usb@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Thu, May 15, 2014 at 1:17 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 14 May 2014 17:33:02 Andrew Bresticker wrote:
>> +
>> +int tegra_xhci_register_mbox_notifier(struct notifier_block *nb)
>> +{
>> +     int ret;
>> +
>> +     mutex_lock(&tegra_xhci_mbox_lock);
>> +     ret = raw_notifier_chain_register(&tegra_xhci_mbox_notifiers, nb);
>> +     mutex_unlock(&tegra_xhci_mbox_lock);
>> +
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL(tegra_xhci_register_mbox_notifier);
>> +
>> +void tegra_xhci_unregister_mbox_notifier(struct notifier_block *nb)
>> +{
>> +     mutex_lock(&tegra_xhci_mbox_lock);
>> +     raw_notifier_chain_unregister(&tegra_xhci_mbox_notifiers, nb);
>> +     mutex_unlock(&tegra_xhci_mbox_lock);
>> +}
>> +EXPORT_SYMBOL(tegra_xhci_unregister_mbox_notifier);
>
> What driver would use these?

It's used by just this driver (the host) and the PHY driver (next
patch in series).

> My feeling is that if you have a mailbox that is used by multiple
> drivers, you should use a proper mailbox driver to operate them,
> and have the drivers register with that API instead of a custom one.

Ok, will do.

>> +     /* Create child xhci-plat device */
>> +     memset(xhci_resources, 0, sizeof(xhci_resources));
>> +     res = platform_get_resource(to_platform_device(dev), IORESOURCE_IRQ, 0);
>> +     if (!res) {
>> +             dev_err(dev, "Missing XHCI IRQ\n");
>> +             ret = -ENODEV;
>> +             goto out;
>> +     }
>> +     xhci_resources[0].start = res->start;
>> +     xhci_resources[0].end = res->end;
>> +     xhci_resources[0].flags = res->flags;
>> +     xhci_resources[0].name = res->name;
>> +     res = platform_get_resource(to_platform_device(dev), IORESOURCE_MEM, 0);
>> +     if (!res) {
>> +             dev_err(dev, "Missing XHCI registers\n");
>> +             ret = -ENODEV;
>> +             goto out;
>> +     }
>> +     xhci_resources[1].start = res->start;
>> +     xhci_resources[1].end = res->end;
>> +     xhci_resources[1].flags = res->flags;
>> +     xhci_resources[1].name = res->name;
>> +
>> +     xhci = platform_device_alloc("xhci-hcd", PLATFORM_DEVID_AUTO);
>> +     if (!xhci) {
>> +             dev_err(dev, "Failed to allocate XHCI host\n");
>> +             ret = -ENOMEM;
>> +             goto out;
>> +     }
>
> This does not feel appropriate at all: Rather than creating a child device,
> you should have a specific driver that hooks into functions exported
> by the xhci core. See Documentation/driver-model/design-patterns.txt

This is how DWC3, currently the only in-tree non-PCI XHCI host driver,
is structured - see drivers/usb/dwc3/host.c.  The recently proposed
Armada XHCI driver [1] just adds clock support and a hook in
xhci-plat's probe() to do the platform-specific initialization.
Tegra's XHCI driver initialization is quite a bit more complicated,
mainly due to the need for external firmware and specific ordering
(e.g. firmware messages should only be enabled after the HCD is
created).  I could do away with the xhci-plat sub-device and just
create a Tegra hc_driver, but it seems silly to have three XHCI
platform drivers structured in three different ways.  USB folks, do
you have an opinion on how this should be done?

[1] https://lkml.org/lkml/2014/5/15/208

Thanks,
Andrew
