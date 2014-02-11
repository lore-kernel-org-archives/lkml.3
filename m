Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaBKWgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:36:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34782 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbaBKWgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:36:41 -0500
Date: Tue, 11 Feb 2014 23:36:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Russ Anderson <rja@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
Message-ID: <20140211223636.GF2939@pd.tnic>
References: <20140128234036.GB18196@sgi.com>
 <20140129141822.GC24887@pd.tnic>
 <20140130221950.GJ3105@sgi.com>
 <52EAD0F2.7090101@zytor.com>
 <20140131100722.GA21873@pd.tnic>
 <20140131140220.GC22498@sgi.com>
 <20140131142318.GC21873@pd.tnic>
 <20140205214536.GT3034@sgi.com>
 <20140205231540.GB6364@pd.tnic>
 <20140211221903.GG27648@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140211221903.GG27648@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 04:19:03PM -0600, Alex Thorlton wrote:
> Have there been any developments on this since last week, Boris? Just
> trying to make sure that we stay in the loop on this issue.
>
> Let me know if there's anything else we can do from our end to help
> expedite the process. I'm always available to test new ideas.

No change. The last failure I have received is the one below, which
basically explodes at the same place as the first one. In order to fix
that, I'd either

1) need from you the info about how to reliably find out which region
contains that uv_systab.function call and its size so that I can map it
1:1

or, if you don't want to share that information

2) let me know so that we can quirk UV2 to use the old EFI mapping code.
This is much easier as we would only need a reliable way to detect an
UV2 system at or before efi_enter_virtual_mode().

About http://marc.info/?l=linux-kernel&m=139115794830637 - I haven't
received any feedback yet after I asked them to test with Matt's
next branch. You did that on your machine and the explosion in
efi_enter_virtual_mode was fixed. But, the problem above still remains.

HTH.

smpboot: CPU0: Genuine Intel(R) CPU  @ 2.60GHz (fam: 06, model: 2d, stepping: 06)
UV: Found UV2 hub
------------[ cut here ]------------
kernel BUG at arch/x86/mm/init_64.c:351!
invalid opcode: 0000 [#1] SMP
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1-medusa-00099-g4532934-dirty #827
Hardware name: SGI UV2000/ROMLEY, BIOS SGI UV 2000/3000 series BIOS 01/15/2013
task: ffff880ff9678010 ti: ffff880ff967a000 task.ti: ffff880ff967a000
RIP: 0010:[<ffffffff818b25a9>]  [<ffffffff818b25a9>] __init_extra_mapping+0x111/0x143
RSP: 0000:ffff880ff967bd18  EFLAGS: 00010206
RAX: 0000000000000f00 RBX: ffff880001c53018 RCX: 0000000000000002
RDX: ffff89ef7d83ef00 RSI: 0000000002000000 RDI: 00000000fc000000
RBP: ffff880ff967bd48 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000007dbfbc R11: 0000000000000000 R12: 00000000fc000000
R13: 0000000002000000 R14: ffff8800fc000000 R15: 0000000080000000
FS:  0000000000000000(0000) GS:ffff880fffc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff89ef7efff000 CR3: 00000000017df000 CR4: 00000000000406f0
Stack:
 80000000000001fb 0000000000000000 0000000000000100 000000000000b018
 000000000000b010 000000000000b008 ffff880ff967bd58 ffffffff818b25ee
 ffff880ff967be28 ffffffff818adcf6 ffff880fffc0cc40 0000000000000100
Call Trace:
 [<ffffffff818b25ee>] init_extra_mapping_uc+0x13/0x15
 [<ffffffff818adcf6>] uv_system_init+0x102/0x111d
 [<ffffffff8108c220>] ? clockevents_config_and_register+0x21/0x25
 [<ffffffff81028dc5>] ? setup_APIC_timer+0xbb/0xc7
 [<ffffffff81541910>] ? printk+0x72/0x74
 [<ffffffff818aba91>] ? setup_boot_APIC_clock+0x4a8/0x4b7
 [<ffffffff81541910>] ? printk+0x72/0x74
 [<ffffffff818a9756>] native_smp_prepare_cpus+0x389/0x3d6
 [<ffffffff8189d7bc>] kernel_init_freeable+0xb7/0x1fb
 [<ffffffff81539480>] ? rest_init+0x74/0x74
 [<ffffffff81539489>] kernel_init+0x9/0xd5
 [<ffffffff81545d7c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81539480>] ? rest_init+0x74/0x74
Code: ff ff ff 3f 00 00 48 23 13 48 b8 00 00 00 00 00 88 ff ff 48 01 c2 4c 89 e0 48 c1 e8 12 25 f8 0f 00 00 48 01 c2 48 83 3a 00 74 04
+<0f> 0b eb fe 48 8b 45 d0 49 81 ed 00 00 20 00 4c 09 e0 49 81 c4
RIP  [<ffffffff818b25a9>] __init_extra_mapping+0x111/0x143
 RSP <ffff880ff967bd18>
---[ end trace e093a3f084996fbc ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
