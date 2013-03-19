Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab3CSR6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:58:14 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:43213 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316Ab3CSR6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
References: <kg69ef$vdb$1@ger.gmane.org>
	<CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com>
	<5126C3E1.80801@gmail.com>
	<513BACAC.9050800@gmail.com>
	<CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
Date: Tue, 19 Mar 2013 10:58:11 -0700
X-Google-Sender-Auth: BiqGV5Sp52y0u6cIrtksLkwKhzs
Message-ID: <CA+55aFyE3qCSnEfnCN6MkkKOj1kt_OCroJzTHEKkhUh+8Y7nXA@mail.gmail.com>
Subject: Re: Regression: Screen turns off when booting in EFI mode
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Seth Forshee <seth.forshee@canonical.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:09 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Doing things like blindly trusting the firmware data without even
> validating it is a really really bad idea. The commit actually looks
> seriously broken in other ways too, like blindly doing phys_to_virt()
> on that, and then trusting the result

Ok, looks like the only thing filling it in is eboot.c, and I guess it
relies on the EFI memory allocations having been mapped. Which they
hopefully have been.

Still, even that seems somewhat debatable. eboot.c does a plain
memcpy() on the pci->romimage returned by
EfiPciIoAttributeOperationGet. And I can *guarantee* that that doesn't
work on some PCI chips that end up sharing the decoder for the ROM and
the graphics aperture or other device oddities. Afaik, some Radeons do
that, for example.

So whoever wrote that eboot thing seems to assume that the world is a
lot simpler and saner than it actually is, and that everybody
magically got things right. Which they never do. The code was
presumably tested on just a couple of machines.

The problem (well, at least *one* problem) is that pci_map_rom()
actually knows about some of these issues, but if dev->rom and
dev->romlen have been set, it trusts them unconditionally. So we'd
either need to fix that, or we need to be really *really* sure that we
only set dev->rom to guaranteed-correct buffers.

At least the radeon code seems to verify that the ROM image starts
with 0x55/0xaa, but I'm guessing we can't do that in general, even if
it is the traditional PC rom pattern.

We only have a few users of "pci_map_rom()", I'm wondering if we can
move the "dev->rom/romsize" cases into the callers. Then the callers
could decide if they want to trust that "pseudo-shadowed" ROM image
(which would test that 55/aa pattern for example), or whether they
want to try to map the actual physical ROM.

                      Linus
