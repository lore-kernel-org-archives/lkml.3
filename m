Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966727Ab3DQOog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:44:36 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58336 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966624Ab3DQOoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <516E88A9.9070200@ti.com>
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
	<516E88A9.9070200@ti.com>
Date: Wed, 17 Apr 2013 07:44:33 -0700
X-Google-Sender-Auth: NRw9bEvCH2ZPdlagqd9k_A7ynFI
Message-ID: <CA+55aFwt82h7hk1YiCeoG2-GGpgLvyW8t_hZRHxyhDQw=_Luzw@mail.gmail.com>
Subject: Re: Device driver memory 'mmap()' function helper cleanup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Miller <davem@davemloft.net>, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 4:34 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>
> Should there be a similar helper that uses remap_pfn_range() instead of
> io_remap_pfn_range()?

The two are practically identical (*). I went back-and-forth over
which one to use, and ended up using io_remap_pfn_range() because that
ends up being the fancier one in a few special cases.

And it's actually about 50/50 whether people use that function on RAM
or on MMIO memory. Some people use it for DMA buffers, some people use
it for memory-mapped PCI memory, so the whole confusion about naming
ends up being double. We probably should get rid of
"io_remap_pfn_range()" entirely, since the real issue ends up being
what page protection bits to use, and drivers do that outside of this
function.

So you can use the new helper function to convert things that use
remap_pfn_range() too. The differences end up mattering only for
either highmem RAM pages (which get used for /dev/mem, but not for the
normal drivers) or for actual memory-mapped IO, in which case the
io_remap_pfn_range() function does a bit more.

                    Linus

(*) io_remap_pfn_page() is the "extended" version that takes care of
some special magical details on a couple of odd architectures, notably
sparc (but also one special case of MIPS PAE that have some magic bit
tricks). But even for MIPS and Sparc, it ends up devolving to be the
same as the "regular" remap_pfn_page() for normal memory. I'm adding
David and Ralf to the cc just to verify that I read it right, but
everybody else just defines "io_remap_pfn_range" to be
"remap_pfn_range".
