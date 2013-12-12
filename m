Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3LLAhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:37:04 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:22740 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3LLAhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:37:02 -0500
Message-ID: <1386808323.1791.299.camel@misato.fc.hp.com>
Subject: Re: EFI tree kernel panic in phys_efi_set_virtual_address_map()
From: Toshi Kani <toshi.kani@hp.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org
Date: Wed, 11 Dec 2013 17:32:03 -0700
In-Reply-To: <20131212002946.GF8863@pd.tnic>
References: <1386806463.1791.295.camel@misato.fc.hp.com>
	 <20131212002946.GF8863@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-12 at 01:29 +0100, Borislav Petkov wrote:
> On Wed, Dec 11, 2013 at 05:01:03PM -0700, Toshi Kani wrote:
> > Hi Boris,
> > 
> > An EFI tree kernel panic'd during boot on one of my systems.  It boots
> > fine when efi=old_map option is specified.  So, I think it is caused by
> > your EFI virtual mapping changes.
> > 
> > The panic message is as follows.  I added some printk's to log the
> > arguments of phys_efi_set_virtual_address_map().  The fault address is
> > __pa(new_memmap) + 0x20 (too high for the map?).
> > 
> > Thanks,
> > -Toshi
> > 
> > 
> > 
> > efi: >> Call phys_efi_set_virtual_address_map()
> > efi:    count 29
> > efi:    desc_size 0x30
> > efi:    new_memmap 0xffff8a03fec16800
> > efi:    __pa(new_memmap) 0x203fec16800
> > 
> > BUG: unable to handle kernel paging request at 00000203fec16820
> > IP: [<0000000072dcda76>] 0x72dcda75
> > PGD 0 
> 
> It looks like the page hierarchy which contains __pa(new_memmap) is not
> mapped in the EFI page table. Nice.
> 
> > Oops: 0000 [#1] SMP 
> > Modules linked in:
> > CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0+ #52
> > Hardware name: HP CB920s x1, BIOS Bundle: 005.028.018 SFW: 012.124.000
> > 10/28/2013
> > task: ffffffff81a10480 ti: ffffffff81a00000 task.ti: ffffffff81a00000
> > RIP: 0010:[<0000000072dcda76>]  [<0000000072dcda76>] 0x72dcda75
> > RSP: 0000:ffffffff81a01e08  EFLAGS: 00010206
> > RAX: 00000000725fee18 RBX: 00000000725feda0 RCX: 00000203fec16800
> > RDX: 0000000072dfe070 RSI: 0000000060000202 RDI: 0000000072dcdac8
> > RBP: 0000000072dd0560 R08: 0000000000000000 R09: 000000000000001d
> > R10: 0000000000000030 R11: 8000000000000000 R12: ffff8a03fec16800
> > R13: 0000000000000001 R14: 000000000000001d R15: 000000000009c000
> > FS:  0000000000000000(0000) GS:ffff88087fa00000(0000)
> > knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00000203fec16820 CR3: 000000000009c000 CR4: 00000000000406b0
> > Stack:
> >  0000000072dfb88f 0000000000000001 0000000000000d08 0000000000000000
> >  ffffffff81d79a98 0000000072dcdac8 0000000072dcdb93 0000000000000001
> >  ffffffff81a01f80 0000000000000570 0000000000000000 0000000000000000
> > Call Trace:
> >  [<ffffffff81045cec>] ? efi_call4+0x6c/0xf0
> >  [<ffffffff81b02f65>] ? efi_enter_virtual_mode+0x229/0x3f1
> >  [<ffffffff81aebdf2>] ? start_kernel+0x36c/0x407
> >  [<ffffffff81aeb88f>] ? repair_env_string+0x5c/0x5c
> >  [<ffffffff81aeb5a3>] ? x86_64_start_reservations+0x2a/0x2c
> >  [<ffffffff81aeb696>] ? x86_64_start_kernel+0xf1/0xf4
> > Code:  Bad RIP value.
> > RIP  [<0000000072dcda76>] 0x72dcda75
> >  RSP <ffffffff81a01e08>
> > CR2: 00000203fec16820
> > ---[ end trace e50b25032c120443 ]---
> 
> Ok, it is late here and I'm almost blocked but you could try the dirty
> patch below - more fiddling tomorrow.

Wow, that was quick.  Yes, I will test it and let you know how it goes.

> In the meantime, can you send me full dmesg, the exact tree you're using
> and your .config?

I will send you in a separate email.

Thanks,
-Toshi



