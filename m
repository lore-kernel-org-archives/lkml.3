Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbbAZVCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:02:53 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50849 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbbAZVCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:02:50 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8MBbKnT=mE3kev8BRPq0GeTgHx8WVa6o54tJuBX_XXLpHdYQ@mail.gmail.com>
References: <20150123203145.GA6691@google.com> <CA+8MBbKnT=mE3kev8BRPq0GeTgHx8WVa6o54tJuBX_XXLpHdYQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 26 Jan 2015 15:02:29 -0600
Message-ID: <CAErSpo7y1wWStjcEOH9xTiM-As8+QeMynZ5ENrL9v3X2PvQCcw@mail.gmail.com>
Subject: Re: [GIT PULL] PCI fixes for v3.19
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 1:58 PM, Tony Luck <tony.luck@gmail.com> wrote:
> I'm seeing these new messages in v3.19-rc6 on ia64:

Hi Tony,

Sorry for the inconvenience.  Can you collect a complete dmesg log and
"lspci -vv" output, too (from the kernel with the reverted commit)?
That will have more useful information than just /proc/iomem.

> pci 0000:01:00.0: can't claim BAR 6 [mem 0xfffe0000-0xffffffff pref]:
> no compatible bridge window

These are option ROMs, probably just not assigned.  We should be able
to assign space for them, so this might not even be a problem, but we
certainly need a better message if that's all it is.

> pci 0000:01:00.1: can't claim BAR 6 [mem 0xfffe0000-0xffffffff pref]:
> no compatible bridge window
> pci 0000:03:00.0: can't claim BAR 6 [mem 0xffe00000-0xffffffff pref]:
> no compatible bridge window
> pci 0000:0b:04.0: can't claim BAR 6 [mem 0xfffe0000-0xffffffff pref]:
> no compatible bridge window
> pci 0000:80:13.0: can't claim BAR 0 [mem 0xa0220000-0xa0220fff]: no
> compatible bridge window

Interesting.  There's no mention of bus 80 at all in /proc/iomem;
maybe this is found by blind probing?  Do we even do that on ia64?
Dmesg should have a clue.

> pci 0000:80:16.0: can't claim BAR 0 [mem 0xa0200000-0xa0203fff 64bit]:
> no compatible bridge window
> pci 0000:80:16.1: can't claim BAR 0 [mem 0xa0204000-0xa0207fff 64bit]:
> no compatible bridge window
> pci 0000:80:16.2: can't claim BAR 0 [mem 0xa0208000-0xa020bfff 64bit]:
> no compatible bridge window
> pci 0000:80:16.3: can't claim BAR 0 [mem 0xa020c000-0xa020ffff 64bit]:
> no compatible bridge window
> pci 0000:80:16.4: can't claim BAR 0 [mem 0xa0210000-0xa0213fff 64bit]:
> no compatible bridge window
> pci 0000:80:16.5: can't claim BAR 0 [mem 0xa0214000-0xa0217fff 64bit]:
> no compatible bridge window
> pci 0000:80:16.6: can't claim BAR 0 [mem 0xa0218000-0xa021bfff 64bit]:
> no compatible bridge window
> pci 0000:80:16.7: can't claim BAR 0 [mem 0xa021c000-0xa021ffff 64bit]:
> no compatible bridge window
> pci 0000:80:01.0: can't claim BAR 8 [mem 0xa0100000-0xa01fffff]: no
> compatible bridge window

Looks like a bridge window (assuming you have CONFIG_PCI_IOV unset).
There's definitely something wrong -- all those mpt and igb devices at
the top level *should* be under some PCI hierarchy, but the hierarchy
is missing from iomem.

Bjorn
