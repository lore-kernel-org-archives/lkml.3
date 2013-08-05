Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3HEWIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:08:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50991 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106Ab3HEWIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:08:11 -0400
Date: Tue, 6 Aug 2013 00:08:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Laszlo Ersek <lersek@redhat.com>
Cc: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130805220808.GC14067@pd.tnic>
References: <20130805130258.GB31845@pd.tnic>
 <51FFAB13.4090603@redhat.com>
 <20130805140306.GD31845@pd.tnic>
 <51FFB660.4060400@redhat.com>
 <20130805144010.GE31845@pd.tnic>
 <51FFC19A.1020204@redhat.com>
 <20130805161247.GF31845@pd.tnic>
 <51FFD5B0.9080000@redhat.com>
 <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52001896.1030509@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 11:26:46PM +0200, Laszlo Ersek wrote:
> What happens if you pass "memblock=debug" on the kernel command line
> (see early_memblock() in "mm/memblock.c")?
> 
> (I just tried it in my Fedora 19 guest, and it in fact produced the message
> 
> [    0.000000] efi: Could not reserve boot range [0x0000800000-0x0000ffffff]

Note to self: Always look for bugs in Linux' UEFI code first, before
going anywhere else!

Yes, very good analysis and good job Laszlo!

I'll write what I see now but will doublecheck it tomorrow because I'm
almost half asleep.

[    0.000000] efi: efi_reserve_boot_services:  -> start: 0x7e0ad000, size: 0x1f000
[    0.000000] efi: Could not reserve boot range [0x007e0ad000-0x007e0cbfff]

And yes, this fails because memblock_is_region_reserved(start, size)
returns true.

And why is that:

[    0.000000] memblock_reserve: [0x000000036be000-0x000000036c3000] setup_arch+0x60e/0xa63
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x7fef1000 reserved size = 0x1724570
[    0.000000]  memory.cnt  = 0x4
[    0.000000]  memory[0x0]     [0x00000000001000-0x0000000009ffff], 0x9f000 bytes
[    0.000000]  memory[0x1]     [0x00000000100000-0x0000007e667fff], 0x7e568000 bytes
[    0.000000]  memory[0x2]     [0x0000007e692000-0x0000007fb11fff], 0x1480000 bytes
[    0.000000]  memory[0x3]     [0x0000007fb76000-0x0000007ffdffff], 0x46a000 bytes
[    0.000000]  reserved.cnt  = 0x3
[    0.000000]  reserved[0x0]   [0x0000000009f000-0x000000000fffff], 0x61000 bytes
[    0.000000]  reserved[0x1]   [0x00000002000000-0x000000036c2fff], 0x16c3000 bytes
[    0.000000]  reserved[0x2]   [0x0000007e0ad018-0x0000007e0ad587], 0x570 bytes
					^^^^^^^^^

There are 0x570 bytes right in this region which are memblock-reserved
and so we truncate it in efi_reserve_boot_services().

This makes me say words which will offend this list so I'll instead go
out on the balcony and wake up the neighbors. :-)

Ok, thanks again for finding it, I'll go and try to figure out the whole
mess tomorrow.

Good night!

> BTW, regarding Michael's answer, I think this is just one of several
> ways in which Linux manipulates the EFI memmap between (b) and (c).
> For example it seems to merge ranges in the map.

Yes, it does so in efi_enter_virtual_mode(). That was my initial
suspicion, that's why I dumped the regions before the merging.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
