Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaGHVwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:52:15 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:37538 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaGHVwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:52:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAODwPW-HSY3RoBi9VEhHSJ98drTsdche-2=mKfAViXWaUa3X1g@mail.gmail.com>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
	<1403072180-4944-7-git-send-email-abrestic@chromium.org>
	<CAODwPW-HSY3RoBi9VEhHSJ98drTsdche-2=mKfAViXWaUa3X1g@mail.gmail.com>
Date: Tue, 8 Jul 2014 14:52:10 -0700
X-Google-Sender-Auth: v1_WFlZd_EyoXYEQ-M97QwKf9MA
Message-ID: <CAL1qeaHT8Yz7kRY3Qm5i+bYCF4D5BT=BVZ6BMfQufyaQFkt0mw@mail.gmail.com>
Subject: Re: [PATCH v1 6/9] usb: xhci: Add NVIDIA Tegra XHCI host-controller driver
From: Andrew Bresticker <abrestic@chromium.org>
To: Julius Werner <jwerner@chromium.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 9:58 AM, Julius Werner <jwerner@chromium.org> wrote:
>> +static const struct hc_driver tegra_xhci_hc_driver = {
>> +       .description =          "tegra-xhci-hcd",
>> +       .product_desc =         "Tegra xHCI Host Controller",
>> +       .hcd_priv_size =        sizeof(struct xhci_hcd *),
>> +
>> +       /*
>> +        * generic hardware linkage
>> +        */
>> +       .irq =                  xhci_irq,
>> +       .flags =                HCD_MEMORY | HCD_USB3 | HCD_SHARED,
>> +
>> +       /*
>> +        * basic lifecycle operations
>> +        */
>> +       .reset =                tegra_xhci_setup,
>> +       .start =                xhci_run,
>> +       .stop =                 xhci_stop,
>> +       .shutdown =             xhci_shutdown,
>> +
>> +       /*
>> +        * managing i/o requests and associated device resources
>> +        */
>> +       .urb_enqueue =          xhci_urb_enqueue,
>> +       .urb_dequeue =          xhci_urb_dequeue,
>> +       .alloc_dev =            xhci_alloc_dev,
>> +       .free_dev =             xhci_free_dev,
>> +       .alloc_streams =        xhci_alloc_streams,
>> +       .free_streams =         xhci_free_streams,
>> +       .add_endpoint =         xhci_add_endpoint,
>> +       .drop_endpoint =        xhci_drop_endpoint,
>> +       .endpoint_reset =       xhci_endpoint_reset,
>> +       .check_bandwidth =      xhci_check_bandwidth,
>> +       .reset_bandwidth =      xhci_reset_bandwidth,
>> +       .address_device =       xhci_address_device,
>> +       .enable_device =        xhci_enable_device,
>> +       .update_hub_device =    xhci_update_hub_device,
>> +       .reset_device =         xhci_discover_or_reset_device,
>> +
>> +       /*
>> +        * scheduling support
>> +        */
>> +       .get_frame_number =     xhci_get_frame,
>> +
>> +       /* Root hub support */
>> +       .hub_control =          xhci_hub_control,
>> +       .hub_status_data =      xhci_hub_status_data,
>> +       .bus_suspend =          xhci_bus_suspend,
>> +       .bus_resume =           xhci_bus_resume,
>> +};
>
> I know I missed the first round of discussion where this was
> suggested, but I don't think it's a good idea to pull the whole
> hc_driver structure out into every platform implementation. It will
> lead to duplication, then to future additions only being applied to
> some of the implementations and everything getting out of sync. This
> is already a problem with the PCI/plat split (e.g. the LPM functions
> were only added to xhci-pci even though they should apply to both).
> Also, if I'm not mistaken this code would fail to compile as a module
> (you are referencing lots of symbols that are internal to the xhci-hcd
> module).

You're right Julius, this won't build as a module without a few EXPORT_SYMBOLs.

> I think at the very least you should add a function
> "xhci_default_driver(struct hc_driver *driver)" to xhci-plat.c (or
> even better to xhci.c and use it for PCI as well) that initializes all
> function pointers to the default (internal) symbols, and can then be
> overridden afterwards.

Currently all XHCI host drivers (PCI, platform, MVEBU) will be built
into the xhci-hcd module.  I could append the Tegra driver to that
module or introduce a xhci_init_driver() like EHCI does as Julius
suggests.  USB folks, do you have a preference?
