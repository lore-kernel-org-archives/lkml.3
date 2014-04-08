Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbaDHQsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:48:41 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57409 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890AbaDHQsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:48:38 -0400
MIME-Version: 1.0
In-Reply-To: <6228807.4v9ZRtib77@wuerfel>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <CAErSpo6S49qNuJQB-XXEfJ1Nkz=4gZ5_hE93=gb_yGZesA1H9Q@mail.gmail.com>
 <20140408094933.GS17163@e106497-lin.cambridge.arm.com> <6228807.4v9ZRtib77@wuerfel>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 8 Apr 2014 10:48:18 -0600
Message-ID: <CAErSpo4nZiEcTth5W6ZhcRSne80T8VWTWR2zm0yN7ogFR0Norw@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper function.
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 4:11 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> There is a wide range of implementations across architectures:
>
> a) no access to I/O ports at all (tile, s390, ...)
> b) access to I/O ports only through special instructions (x86, ...)
> c) all MMIO is mapped virtual contiguous to PCI_IOBASE or _IO_BASE
>    (most ppc64, arm32 with MMU, arm64, ...)
> d) only one PCI host can have an I/O space (mips, microblaze, ...)
> e) each host controller can have its own method (ppc64 with indirect pio)
> f) PIO token equals virtual address plus offset (some legacy ARM platforms,
>    probably some other architectures), or physical address (sparc)
> g) PIO token encodes address space number plus offset (ia64)
>
> a) and b) are trivially handled by any implementation that falls
> back to 'return -EINVAL'.
> I believe that c) is the most appropriate solution and we should be
> able to adopt it by most of the architectures that have an MMU and
> make it the default implementation.
> d) seems like a good fallback for noMMU architectures: While we do
> need to support I/O spaces, we need to support multiple PCI domains,
> and we need to support noMMU, the combination of all three should
> be extremely rare, and I'd leave it up to the architecture to support
> that if there is a real use case, rather than trying to put that into
> common code.
> Anything that currently requires e), f) or g) I think should keep
> doing that and not try to use the generic implementation.

Thanks for the nice summary.  That's way more than I had figured out myself.

I don't know whether it'd be worth it, especially for something that's
so close to obsolete, but it seems like it should be *possible* to
generalize and unify this somewhat.  I would argue that g) (which I
wrote, so I know it better than the others) could fairly easily
subsume c), d), and f), since it maps an ioport number to a virtual
address for an MMIO access, but it doesn't assume that all the MMIO
spaces are contiguous.

b), e), and maybe a) could be handled with an exception, e.g., inside
inb(), look up the struct io_space (e.g., similar to what ia64 does in
__ia64_mk_io_addr()), and if that struct contains a non-zero ops
pointer, use that instead of doing the MMIO access.  The ops pointer
functions could use the x86 INB instruction or do the indirect PIO
thing or whatever.

Bjorn
