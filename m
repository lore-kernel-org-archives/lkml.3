Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbbA0Dzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:55:33 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:45072 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbbA0Dzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:55:31 -0500
MIME-Version: 1.0
In-Reply-To: <20150126235334.GA11624@google.com>
References: <20150123203145.GA6691@google.com>
	<CA+8MBbKnT=mE3kev8BRPq0GeTgHx8WVa6o54tJuBX_XXLpHdYQ@mail.gmail.com>
	<CAErSpo7y1wWStjcEOH9xTiM-As8+QeMynZ5ENrL9v3X2PvQCcw@mail.gmail.com>
	<CA+8MBb+bWiX2eayjBQHsvCjTp3t8H9=AviF9AkV6CC--cC_fYQ@mail.gmail.com>
	<20150126235334.GA11624@google.com>
Date: Mon, 26 Jan 2015 19:55:30 -0800
X-Google-Sender-Auth: XHLslCh8yVB29wYZvaHgOXKOGd8
Message-ID: <CAE9FiQUd8XgEhBKqFEyDLMTySw=jngtLN=zZeQcfW6=vC_b4mA@mail.gmail.com>
Subject: Re: [GIT PULL] PCI fixes for v3.19
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Richard Zhu <Richard.Zhu@freescale.com>,
        Marek Kordik <kordikmarek@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andreas Hartmann <andihartmann@freenet.de>,
        Alexey Voronkov <zermond@gmail.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 3:53 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Jan 26, 2015 at 01:24:51PM -0800, Tony Luck wrote:
>> On Mon, Jan 26, 2015 at 1:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> > Sorry for the inconvenience.  Can you collect a complete dmesg log and
>> > "lspci -vv" output, too (from the kernel with the reverted commit)?
>> > That will have more useful information than just /proc/iomem.
>>
>> Full dmesg, lspci -vv, and bonus .config (CONFIG_PCI_IOV is indeed
>> not set)
>
> The ROM part is something we should fix:
>
>   pci 0000:01:00.1: can't claim BAR 6 [mem 0xfffe0000-0xffffffff pref]: no compatible bridge window
>
> The ROM BAR is probably disabled, and we shouldn't complain about this if
> it's disabled.  Yinghai?

original ia64 code, has extra checking to hide the warning

-static int is_valid_resource(struct pci_dev *dev, int idx)
 {
-       unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
-       struct resource *devr = &dev->resource[idx], *busr;

        if (!dev->bus)
-               return 0;
-
-       pci_bus_for_each_resource(dev->bus, busr, i) {
-               if (!busr || ((busr->flags ^ devr->flags) & type_mask))
-                       continue;
-               if ((devr->start) && (devr->start >= busr->start) &&
-                               (devr->end <= busr->end))
-                       return 1;
-       }
-       return 0;
-}

also that is used to skip pci_claim_resource calling for invalid ...

so the root resource is totally wrong from ACPI.

Thanks

Yinghai
