Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaBKDBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 22:01:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbaBKDBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 22:01:10 -0500
References: <8738jr5t3e.fsf@redhat.com> <20140210175246.GB2887@console-pimps.org>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Madper Xie <cxie@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at ffffffffff340003
In-reply-to: <20140210175246.GB2887@console-pimps.org>
Date: Tue, 11 Feb 2014 11:00:52 +0800
Message-ID: <87mwhy8iaj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


matt@console-pimps.org writes:

> On Mon, 10 Feb, at 03:23:33PM, Madper Xie wrote:
>> Howdy,
>> 
>> With old kernel (from 3.10 to 3.14-rc1), my hp box shows following
>> outputs:
>> ~~~
>> [    0.009166] Freeing SMP alternatives memory: 20K (ffffffff82234000 - ffffffff82239000)
>> [    0.010302] ioremap: invalid physical address 1376e01800000001
>> [    0.010303] ------------[ cut here ]------------
>> [    0.010308] WARNING: CPU: 0 PID: 0 at arch/x86/mm/ioremap.c:83 __ioremap_caller+0x357/0x380()
>
> OK, this looks like a bogus BGRT address, that's a 64-bit physical
> address. I suspect the BGRT address is actually 0x1376e018, but that's
> just a guess. This looks like a BIOS bug.
>
>> ~~~
>> However the box can boot up and works well.
>> After I update kernel to 3.14-rc2, it panic when booting. Here is
>> console output:
>> ~~~
>> [    0.010366] BUG: unable to handle kernel paging request at ffffffffff340003
>> [    0.017376] IP: [<ffffffff81d85ba4>] efi_bgrt_init+0x9d/0x133
>> [    0.023153] PGD 159eb067 PUD 159ed067 PMD 16240067 PTE 9376e01800000163
>> [    0.029842] Oops: 0009 [#1] SMP 
>
> Well, nuts. I think this is my bad. Does reverting commit 081cd62a010f
> ("x86/efi: Allow mapping BGRT on x86-32") make things work? Or at least,
> work as well as they did prior to -rc2?
>
Sure.
Yes, after revert 081cd62a it can boot up. (Of cause the ioremap failed
as before.)
[    0.010340] ioremap: invalid physical address 1376e01800000001
[    0.010342] ------------[ cut here ]------------
[    0.010346] WARNING: CPU: 0 PID: 0 at arch/x86/mm/ioremap.c:83
__ioremap_caller+0x357/0x380()

> I wonder if we're calling early_memremap() when the fixmap slots are no
> longer valid. Could you try building the 'urgent' branch at,
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
it doesn't help, seems the same panic output:
[    0.001341] BUG: unable to handle kernel paging request at ffffffffff340003
[    0.008339] IP: [<ffffffff81a73794>] efi_bgrt_init+0x9d/0x133
[    0.014111] PGD 28fb067 PUD 28fd067 PMD 2bef067 PTE 9376e01800000163
[    0.020530] Oops: 0009 [#1] SMP 
[    0.023792] Modules linked in:
[    0.026864] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc2+ #1
[    0.033213] Hardware name: Hewlett-Packard HP Compaq Elite 8300 SFF/3397, BIOS K01 v02.05 05/07/2012
[    0.042341] task: ffffffff818ff460 ti: ffffffff818ec000 task.ti: ffffffff818ec000
[    0.049822] RIP: 0010:[<ffffffff81a73794>]  [<ffffffff81a73794>] efi_bgrt_init+0x9d/0x133
[    0.058014] RSP: 0000:ffffffff818edee0  EFLAGS: 00010202
[    0.063325] RAX: ffffffffff340001 RBX: ffffffffff340001 RCX: ffffffff00000abf
[    0.070456] RDX: 8000000000000163 RSI: 9376e01800000163 RDI: ffffffffff340000
[    0.077588] RBP: ffffffff818edef8 R08: 8000000000000163 R09: 8000000000000163
[    0.084720] R10: 00000000d9bb5000 R11: ffffffff8118907f R12: 0000000000000001
[    0.091853] R13: 0000000000002e50 R14: 0000000000000001 R15: 0000000213d4c000
[    0.098984] FS:  0000000000000000(0000) GS:ffff88021ea00000(0000) knlGS:0000000000000000
[    0.107072] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.112817] CR2: ffffffffff340003 CR3: 00000000028f8000 CR4: 00000000000406b0
[    0.119952] Stack:
[    0.121965]  0000000000000000 ffff880213d4c000 0000000000002e50 ffffffff818edf48
[    0.129427]  ffffffff81a73311 000000f71ed85640 47ddbe4b4424ac57 a9929ff050ed979e
[    0.136890]  ffffffffffffffff ffffffff81af0900 ffff88021ed85640 ffffffff81afa2c0
[    0.144353] Call Trace:
[    0.146801]  [<ffffffff81a73311>] efi_enter_virtual_mode+0x3d9/0x42c
[    0.153162]  [<ffffffff81a56ea9>] start_kernel+0x386/0x403
[    0.158652]  [<ffffffff81a5692c>] ? repair_env_string+0x5c/0x5c
[    0.164569]  [<ffffffff81a56120>] ? early_idt_handlers+0x120/0x120
[    0.170748]  [<ffffffff81a565de>] x86_64_start_reservations+0x2a/0x2c
[    0.177188]  [<ffffffff81a5671e>] x86_64_start_kernel+0x13e/0x14d
[    0.183284] Code: 89 c3 75 24 48 8b 05 e4 09 1f 00 be 06 00 00 00 48 8b 78 28 e8 8b d0 ff ff 48 85 c0 48 89 c3 0f 84 95 00 00 00 41 b4 01 45 84 e4 <44> 8b  
[    0.203257] RIP  [<ffffffff81a73794>] efi_bgrt_init+0x9d/0x133
[    0.209105]  RSP <ffffffff818edee0>
[    0.212593] CR2: ffffffffff340003
[    0.215914] ---[ end trace fbce8f13012fb82c ]---
[    0.220533] Kernel panic - not syncing: Fatal exception
[    0.225758] Rebooting in 3 seconds..
[    0.229211] ACPI MEMORY or I/O RESET_REG.

-- 
Thanks,
Madper
