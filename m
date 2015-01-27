Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbbA0ODw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:03:52 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:63870 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbbA0ODq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:03:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUd8XgEhBKqFEyDLMTySw=jngtLN=zZeQcfW6=vC_b4mA@mail.gmail.com>
References: <20150123203145.GA6691@google.com> <CA+8MBbKnT=mE3kev8BRPq0GeTgHx8WVa6o54tJuBX_XXLpHdYQ@mail.gmail.com>
 <CAErSpo7y1wWStjcEOH9xTiM-As8+QeMynZ5ENrL9v3X2PvQCcw@mail.gmail.com>
 <CA+8MBb+bWiX2eayjBQHsvCjTp3t8H9=AviF9AkV6CC--cC_fYQ@mail.gmail.com>
 <20150126235334.GA11624@google.com> <CAE9FiQUd8XgEhBKqFEyDLMTySw=jngtLN=zZeQcfW6=vC_b4mA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 27 Jan 2015 08:03:25 -0600
Message-ID: <CAErSpo64i1UhAoX5_MqVRerdpqq6gvmXg4DOqe3ndejPh5oGgg@mail.gmail.com>
Subject: Re: [GIT PULL] PCI fixes for v3.19
To: Yinghai Lu <yinghai@kernel.org>
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

On Mon, Jan 26, 2015 at 9:55 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Jan 26, 2015 at 3:53 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Mon, Jan 26, 2015 at 01:24:51PM -0800, Tony Luck wrote:
>>> On Mon, Jan 26, 2015 at 1:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> > Sorry for the inconvenience.  Can you collect a complete dmesg log and
>>> > "lspci -vv" output, too (from the kernel with the reverted commit)?
>>> > That will have more useful information than just /proc/iomem.
>>>
>>> Full dmesg, lspci -vv, and bonus .config (CONFIG_PCI_IOV is indeed
>>> not set)
>>
>> The ROM part is something we should fix:
>>
>>   pci 0000:01:00.1: can't claim BAR 6 [mem 0xfffe0000-0xffffffff pref]: no compatible bridge window
>>
>> The ROM BAR is probably disabled, and we shouldn't complain about this if
>> it's disabled.  Yinghai?
>
> original ia64 code, has extra checking to hide the warning
>
> -static int is_valid_resource(struct pci_dev *dev, int idx)
>  {
> -       unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
> -       struct resource *devr = &dev->resource[idx], *busr;
>
>         if (!dev->bus)
> -               return 0;
> -
> -       pci_bus_for_each_resource(dev->bus, busr, i) {
> -               if (!busr || ((busr->flags ^ devr->flags) & type_mask))
> -                       continue;
> -               if ((devr->start) && (devr->start >= busr->start) &&
> -                               (devr->end <= busr->end))
> -                       return 1;
> -       }
> -       return 0;
> -}
>
> also that is used to skip pci_claim_resource calling for invalid ...
>
> so the root resource is totally wrong from ACPI.

Yes, ACPI is clearly missing some information.

Just to make sure we're planning the same thing, I expect that we will
fix or workaround both issues so it works just as well as v3.18 by the
time v3.19 is released.  This is a system in the field, and we should
be able to figure out how to deal with the broken firmware.  Asking
users to upgrade their firmware is not the solution I'm looking for.

There is nothing ia64-specific about this issue, so we should be able
to do this in some generic way.

Bjorn
