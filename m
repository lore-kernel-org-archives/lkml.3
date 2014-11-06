Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaKFHMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:12:00 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58705 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaKFHL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:11:58 -0500
MIME-Version: 1.0
In-Reply-To: <20141105215713.GC6168@google.com>
References: <1414621570-20777-1-git-send-email-yinghai@kernel.org>
	<20141030170913.GA6982@google.com>
	<20141105202252.GB6168@google.com>
	<1808324.GlBOqbYcPz@vostro.rjw.lan>
	<20141105215713.GC6168@google.com>
Date: Wed, 5 Nov 2014 23:11:57 -0800
X-Google-Sender-Auth: 0c2Q1lEJ9W9XSyYo1CXyEEYUQAU
Message-ID: <CAE9FiQVdd5dfAebJVD=CR+s=HeHXKVJ2sN0WD6RbE-WpS7+sZg@mail.gmail.com>
Subject: Re: [PATCH] PCI: fix sriov enabling with virtual bus
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Chao Zhou <chao.zhou@intel.com>, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 1:57 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> It's relatively common to start with a pci_dev and look for an ACPI handle
> that corresponds to that device or the closest enclosing scope, so maybe
> there should be a way to do that directly.
>
> For pci_get_hp_params(), I think the current code is actually slightly
> buggy because we don't look for _HPP/_HPX on the device itself; we only
> look at the bridges upstream from it.
>
> What I had in mind was something like the following (untested and not for
> application).



> + * Search for an ACPI handle.  The PCI device itself may have one, or an
> + * upstream device (either a PCI-to-PCI bridge or a PCI host bridge) may
> + * have one.
> + */
> +acpi_handle pci_find_acpi_handle(struct pci_dev *pdev)
> +{
> +       struct device *dev;
> +       acpi_handle handle;
> +       struct pci_bus *bus;
> +
> +       dev = &pdev->dev;
> +       handle = ACPI_HANDLE(dev);
> +       while (!handle) {
> +               pdev = pci_physfn(pdev);

I'm a little worried about to apply hpx value for PFs to VFs.

> +               bus = pdev->bus;
> +               if (pci_is_root_bus(bus))
> +                       dev = bus->bridge;
> +               else {
> +                       pdev = bus->self;
> +                       dev = &pdev->dev;
> +               }
> +               handle = ACPI_HANDLE(dev);
> +       }
> +       return handle;
> +}


Also found another problem,
pci_device_add==>pci_configure_device==>program_hpp_type2() path.
and program_hpp_type2() will check dev->subordinate().

but at the time child bridge is not scanned yet.

Maybe we should move pci_configure_device later ?

Yinghai Lu
