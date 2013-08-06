Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3HFOKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:10:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55488 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab3HFOKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:10:38 -0400
Date: Tue, 6 Aug 2013 16:10:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Laszlo Ersek <lersek@redhat.com>
Cc: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130806141036.GD14891@pd.tnic>
References: <51FFAB13.4090603@redhat.com>
 <20130805140306.GD31845@pd.tnic>
 <51FFB660.4060400@redhat.com>
 <20130805144010.GE31845@pd.tnic>
 <51FFC19A.1020204@redhat.com>
 <20130805161247.GF31845@pd.tnic>
 <51FFD5B0.9080000@redhat.com>
 <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com>
 <20130805220808.GC14067@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130805220808.GC14067@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 12:08:08AM +0200, Borislav Petkov wrote:
> Ok, thanks again for finding it, I'll go and try to figure out the whole
> mess tomorrow.

Ok, some more observations:

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] memblock_reserve: [0x0000000009f000-0x00000000100000] reserve_ebda_region+0x56/0x58
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc4+ (boris@nazgul) (gcc version 4.7.3 (Debian 4.7.3-4) ) #4 SMP PREEMPT Tue Aug 6 15:15:07 CEST 2013
[    0.000000] memblock_reserve: [0x00000002000000-0x000000036c0000] setup_arch+0x47/0xa63
[    0.000000] Command line: root=/dev/sda1 debug ignore_loglevel log_buf_len=10M earlyprintk=ttyS0,115200 console=ttyS0,115200 console=tty0 memblock=debug
[    0.000000] efi: efi_memblock_x86_reserve_range: pmap: 0x7e0ad018
[    0.000000] memblock_reserve: [0x0000007e0ad018-0x0000007e0ad588] efi_memblock_x86_reserve_range+0x70/0x75

And this is it:

efi_memblock_x86_reserve_range() reserves the region which overlaps with
the following region:

[    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)

Now, this address 0x7e0ad018 is boot_params.efi_info.efi_memmap which,
AFAICT, we write to in exit_boot() after calling GetMemoryMap(). IOW,
this the EFI memory map descriptor which we mark as reserved.

So, hmm, I'm not sure what we want to do here.

Off the top of my head, I'm thinking this: efi_reserve_boot_services()
which truncates this region to 0 should actually check that this special
region is reserved, and *enlarge* it instead of making it of size 0, no?

Right?

Or does anyone have a better idea?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
