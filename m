Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab3LQGyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:54:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab3LQGym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:54:42 -0500
Date: Tue, 17 Dec 2013 14:53:46 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v6 14/14] x86: kdebugfs do not use __va for getting
 setup_data virt addr
Message-ID: <20131217065346.GG6751@dhcp-16-126.nay.redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
 <1387186235-15972-15-git-send-email-dyoung@redhat.com>
 <20131216163501.GB3873@console-pimps.org>
 <20131217062417.GE6751@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217062417.GE6751@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/13 at 02:24pm, Dave Young wrote:
> On 12/16/13 at 04:35pm, Matt Fleming wrote:
> > On Mon, 16 Dec, at 05:30:35PM, Dave Young wrote:
> > > kdump kernel will use memmap=exactmap kernel cmdline, but __va does not
> > > work in case memmap=exactmap, so let's always use ioremap_cache.
> > > 
> > > Signed-off-by: Dave Young <dyoung@redhat.com>
> > > ---
> > >  arch/x86/kernel/kdebugfs.c | 35 +++++++++++------------------------
> > >  1 file changed, 11 insertions(+), 24 deletions(-)
> > 
> > Dave, I've no idea why this change is necessary from the commit log. Is
> > it required for kexec to function on EFI? Why does __va() not work in
> > the memmap=exactmap case?
> > 
> 
> During previous kdump tests I saw panics while reading the setup_data in debugfs.
> I thought it is caused by some unmapped addresses. At that time I also reproduced
> it by booting the non-kexec kernel with memmap=exact.
> 
> Since you are asking about this I'm testing it again but I seems can not
> reproduce this problem any more, it's weird.
> 
> I should dug more about it and save the panic messages.
> 
> So let's drop this patch for now, I will keep an eye on this and address it later
> if I can find the problem again.

Reproduced it again in normal boot with memmap=exactmap, but I agree it's a corner
case, I remember I saw this in kdump kernel, but I still did not see it in today's
testing so I think move this issue out of this patch series is fine to me.

[    0.359467] BUG: unable to handle kernel paging request at ffff8800d5592020
[    0.359472] IP: [<ffffffff817dbdbc>] arch_kdebugfs_init+0x11a/0x201
[    0.359474] PGD 316b067 PUD 37031063 PMD 0 
[    0.359476] Oops: 0000 [#1] PREEMPT SMP 
[    0.359477] Modules linked in:
[    0.359480] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc3+ #65
[    0.359481] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v03.15 05/09/2013
[    0.359482] task: ffff880037022000 ti: ffff880037188000 task.ti: ffff880037188000
[    0.359484] RIP: 0010:[<ffffffff817dbdbc>]  [<ffffffff817dbdbc>] arch_kdebugfs_init+0x11a/0x201
[    0.359485] RSP: 0000:ffff880037189e30  EFLAGS: 00010286
[    0.359486] RAX: ffff8800372e30e0 RBX: ffff8800372e30e0 RCX: 0000000000000191
[    0.359486] RDX: 0000000000000000 RSI: ffffffff8168a39e RDI: ffff880037189e50
[    0.359487] RBP: ffff880037189e90 R08: ffff8800372e30e0 R09: 0000000000000000
[    0.359488] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003640aea0
[    0.359489] R13: 00000000d5592018 R14: ffff88003640b200 R15: ffff8800d5592018
[    0.359490] FS:  0000000000000000(0000) GS:ffff880037480000(0000) knlGS:0000000000000000
[    0.359491] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.359491] CR2: ffff8800d5592020 CR3: 0000000002716000 CR4: 00000000000407e0
[    0.359492] Stack:
[    0.359494]  ffffffff817da6d5 ffff88003640b0e0 ffff88003640afc0 0000000000000004
[    0.359496]  ffff880037180033 ffffffff8149d82d 00000000c9b42d58 ffffffff817dbca2
[    0.359498]  0000000000000000 00000000000000f3 0000000000000000 0000000000000000
[    0.359499] Call Trace:
[    0.359502]  [<ffffffff817da6d5>] ? boot_params_ksysfs_init+0x1ff/0x244
[    0.359507]  [<ffffffff8149d82d>] ? mutex_unlock+0x9/0xb
[    0.359508]  [<ffffffff817dbca2>] ? topology_init+0x36/0x36
[    0.359512]  [<ffffffff810002bf>] do_one_initcall+0xae/0x15b
[    0.359515]  [<ffffffff81078500>] ? parameq+0xb/0x1f
[    0.359516]  [<ffffffff81078770>] ? parse_args+0x25c/0x33a
[    0.359519]  [<ffffffff817d5ec6>] kernel_init_freeable+0x115/0x19b
[    0.359521]  [<ffffffff817d573d>] ? do_early_param+0x88/0x88
[    0.359523]  [<ffffffff81489359>] ? rest_init+0xbd/0xbd
[    0.359524]  [<ffffffff81489362>] kernel_init+0x9/0xfa
[    0.359527]  [<ffffffff8149fd0c>] ret_from_fork+0x7c/0xb0
[    0.359528]  [<ffffffff81489359>] ? rest_init+0xbd/0xbd
[    0.359548] Code: ff 48 85 c0 48 89 c3 0f 84 b9 00 00 00 49 bf 00 00 00 00 00 88 ff ff 4c 89 28 8b 55 bc 48 8d 7d c0 4d 01 ef 48 c 
[    0.359549] RIP  [<ffffffff817dbdbc>] arch_kdebugfs_init+0x11a/0x201
[    0.359550]  RSP <ffff880037189e30>
[    0.359550] CR2: ffff8800d5592020
[    0.359559] ---[ end trace d52b3fbe64a26115 ]---
[    0.621287] kworker/u8:0 (43) used greatest stack depth: 5232 bytes left
[    0.628021] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[    0.628021] 




> 
> --
> Thanks
> Dave
