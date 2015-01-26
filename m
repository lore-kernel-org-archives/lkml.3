Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbbAZXxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:53:42 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:43302 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbbAZXxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:53:38 -0500
Date: Mon, 26 Jan 2015 17:53:34 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Richard Zhu <Richard.Zhu@freescale.com>,
        Yinghai Lu <yinghai@kernel.org>, Marek Kordik <kordikmarek@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andreas Hartmann <andihartmann@freenet.de>,
        Alexey Voronkov <zermond@gmail.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [GIT PULL] PCI fixes for v3.19
Message-ID: <20150126235334.GA11624@google.com>
References: <20150123203145.GA6691@google.com>
 <CA+8MBbKnT=mE3kev8BRPq0GeTgHx8WVa6o54tJuBX_XXLpHdYQ@mail.gmail.com>
 <CAErSpo7y1wWStjcEOH9xTiM-As8+QeMynZ5ENrL9v3X2PvQCcw@mail.gmail.com>
 <CA+8MBb+bWiX2eayjBQHsvCjTp3t8H9=AviF9AkV6CC--cC_fYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBb+bWiX2eayjBQHsvCjTp3t8H9=AviF9AkV6CC--cC_fYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 01:24:51PM -0800, Tony Luck wrote:
> On Mon, Jan 26, 2015 at 1:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > Sorry for the inconvenience.  Can you collect a complete dmesg log and
> > "lspci -vv" output, too (from the kernel with the reverted commit)?
> > That will have more useful information than just /proc/iomem.
> 
> Full dmesg, lspci -vv, and bonus .config (CONFIG_PCI_IOV is indeed
> not set)

The ROM part is something we should fix:

  pci 0000:01:00.1: can't claim BAR 6 [mem 0xfffe0000-0xffffffff pref]: no compatible bridge window

The ROM BAR is probably disabled, and we shouldn't complain about this if
it's disabled.  Yinghai?

The stuff on bus 0000:80 looks like at least partly a firmware problem:

  ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-ff])
  acpi PNP0A08:01: host bridge window [io  0x9000-0xfffe]
  pci 0000:80:01.0: PCI bridge to [bus 81]
  pci 0000:80:01.0:   bridge window [io  0xa000-0xafff]
  pci 0000:80:01.0:   bridge window [mem 0xa0100000-0xa01fffff]
  pci 0000:80:13.0: reg 0x10: [mem 0xa0220000-0xa0220fff]

ACPI told us about an I/O port aperture, but didn't mention any MMIO
apertures through the host bridge.  Therefore, we have no MMIO space to
assign to the devices on [bus 80-ff].

But presumably these devices, e.g., the igb devices at 81:00.0 and 81:00.1
and the mpt device at 83:00.0, actually DO work, so the PCI1 host bridge
must actually forward some MMIO space that ACPI didn't tell us about.  I
think on x86, we would fall back to whatever the firmware left in those
BARs.  We should probably do the same on x86.

Bjorn
