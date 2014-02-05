Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbaBEBcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 20:32:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35483 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbaBEBcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 20:32:11 -0500
Date: Wed, 5 Feb 2014 02:32:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
Cc: Matt Fleming <matt@console-pimps.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: 3.13.0: crash on boot
Message-ID: <20140205013206.GA5711@pd.tnic>
References: <20140131083707.GA9968@oktetlabs.ru>
 <CAErSpo6PaX2BcTqF4GD5ez3wDaPizUCNZJEjy_5EozAd3epoaA@mail.gmail.com>
 <20140203144120.GA15384@console-pimps.org>
 <20140204133046.GA24536@oktetlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140204133046.GA24536@oktetlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 05:30:50PM +0400, Alexandra N. Kossovsky wrote:
> On Feb 03 14:41, Matt Fleming wrote:
> > Alexandra, any chance you could try out a v3.14-rc1 kernel? Basically
> > all of the EFI memory mapping code was rewritten for v3.14.
> 
> v3.14-rc1: kmemleak complains about acpi code plus the same crash in
> efi.  Log and config attached.
> 
> I'll ask my system administrator for BIOS update.

Btw, did this box boot any kernels successfully in EFI mode at all?

...

And this looks like a nasty corruption of RIP state because we're
not getting any Code: section even. And we're choked somewhere in
SetVirtualAddressMap...

> [    0.035953] BUG: unable to handle kernel paging request at 0000000129101020
> [    0.044426] IP: [<00000000cf038cc6>] 0xcf038cc6
> [    0.050276] PGD 2967067 PUD 296a067 PMD 12fe99067 PTE 8000000129101962

and we've switched to the EFI page table (see CR3 below) but we're still
walking some pagetable which cannot be right because show_fault_oops()
doesn't know about the EFI page table (Matt's patch is not in yet). Hmm.

> [    0.058361] Oops: 0000 [#1] SMP 
> [    0.062863] Modules linked in:
> [    0.067143] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc1-debug-amd64 #1
> [    0.076889] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.0b 09/17/2012
> [    0.087007] task: ffffffff81a134c0 ti: ffffffff81a00000 task.ti: ffffffff81a00000
> [    0.096936] RIP: 0010:[<00000000cf038cc6>]  [<00000000cf038cc6>] 0xcf038cc6

Now this could be the 1:1 mapping of say, region

[    0.000000] efi: mem53: type=5, attr=0x800000000000000f, range=[0x00000000cefdc000-0x00000000cf04d000) (0MB)

who knows...

Now, we #PF at 0x0000000129101020. Is that because we're trying to
access memory somewhere in here:

[    0.000000] efi: mem63: type=7, attr=0xf, range=[0x0000000100000000-0x0000000130000000) (768MB)

which looks very strange because this is of type EFI_CONVENTIONAL_MEMORY
so is the efi thing trying to access normal memory and it is not mapped
in the efi pagetable???! And WTF is EFI trying to access conventional
memory?? No wonder we stuck it in its own pagetable.

Oh, and look, this region doesn't have the EFI_MEMORY_RUNTIME bit set so
we don't map it.

And this should explain the explosion with 3.13 too because we didn't
map EFI_CONVENTIONAL_MEMORY then either.

Or, wait a minute, isn't this the same __pa(new_memmap) crap we've been
debugging recently?? But if it were, this wouldn't explain the failure
with 3.13.

Fun.

> [    0.105369] RSP: 0000:ffffffff81a01de0  EFLAGS: 00010287
> [    0.112005] RAX: 8000000000000000 RBX: 0000000129101000 RCX: 0000000000000660
> [    0.120574] RDX: 0000000129101000 RSI: 00000000cefbff18 RDI: 00000000cf037af4
> [    0.129147] RBP: 0000000000000660 R08: 0000000000000001 R09: 0000000129101000
> [    0.137726] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000cefbfe18
> [    0.146295] R13: 0000000000000660 R14: 0000000000000001 R15: 000000000009a000
> [    0.154869] FS:  0000000000000000(0000) GS:ffff88012a800000(0000) knlGS:0000000000000000
> [    0.165444] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.172536] CR2: ffff88012a4d9c60 CR3: 000000000009a000 CR4: 00000000000406b0
> [    0.181111] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.189682] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
> [    0.198255] Stack:
> [    0.201389]  ffffffff81a01f48 ffffffff813172aa 0000000000000000 0000000000000001
> [    0.211392]  00000000cf046a50 00000000cf038f36 00000000cefbfca0 ffffffff81a01f48
> [    0.221401]  ffffffff813172aa 0000000000000000 0000000000000001 0000000000000000
> [    0.231392] Call Trace:
> [    0.234994]  [<ffffffff813172aa>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [    0.242927]  [<ffffffff813172aa>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [    0.250859]  [<ffffffff8106868c>] ? efi_call4+0x6c/0xf0
> [    0.257408]  [<ffffffff81cc7fa5>] ? efi_enter_virtual_mode+0x2b2/0x45b
> [    0.265344]  [<ffffffff81cabe73>] ? start_kernel+0x3d3/0x45e
> [    0.272354]  [<ffffffff81cab8a9>] ? repair_env_string+0x5c/0x5c
> [    0.279640]  [<ffffffff81cab120>] ? early_idt_handlers+0x120/0x120
> [    0.287201]  [<ffffffff81cab556>] ? x86_64_start_reservations+0x2a/0x2c
> [    0.295228]  [<ffffffff81cab69b>] ? x86_64_start_kernel+0x143/0x152
> [    0.302882] Code:  Bad RIP value.
			^^^^

> [    0.307472] RIP  [<00000000cf038cc6>] 0xcf038cc6
> [    0.313415]  RSP <ffffffff81a01de0>
> [    0.318118] CR2: 0000000129101020
> [    0.322638] ---[ end trace a93146f09f726796 ]---

Alexandra, can you please do

make arch/x86/platform/efi/efi.o
make arch/x86/platform/efi/efi.s

on that exact same kernel .config and zip and send me those two files?
Privately is fine too.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
