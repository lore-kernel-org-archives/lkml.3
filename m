Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3GORid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:38:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab3GORia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:38:30 -0400
Message-ID: <1373909907.8441.259.camel@ul30vt.home>
Subject: Re: ahci_host_activate NULL pointer (was Re: Linux 3.11-rc1)
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: tj <tj@kernel.org>, linux-ide@vger.kernel.org,
        Alexander Gordeev <agordeev@redhat.com>
Date: Mon, 15 Jul 2013 11:38:27 -0600
In-Reply-To: <1373906960.8441.258.camel@ul30vt.home>
References: <CA+55aFyfTJKRnsFHGxQ+-2+GVstMUj6t4f0q5-8wJMbN-Y93+g@mail.gmail.com>
	 <1373906960.8441.258.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 10:49 -0600, Alex Williamson wrote:
> On Sun, 2013-07-14 at 16:57 -0700, Linus Torvalds wrote:
> > It's been two weeks, and the merge window has closed. If I missed
> > anything, holler, but I don't have anything pending that I am aware
> > of.
> > 
> > This merge window was smaller in terms of number of commits than the
> > 3.10 merge window, but we actually have more new lines. Most of that
> > seems to be in staging - a full third of all changes by line-count is
> > staging, and merging in Lustre is the bulk of that. Let's see how that
> > all turns out, I have to say that we don't have a great track record
> > on merging filesystems through staging.
> > 
> > Ignoring the lustre merge, I think this really was a somewhat calmer
> > merge window. We had a few trees with problems, and we have an
> > on-going debate about stable patches that was triggered largely thanks
> > to this merge window, so now we'll have something to discuss for the
> > kernel summit. But on the whole, I suspect we might be starting to see
> > the traditional summer slump (Australia notwithstanding).
> > 
> > Despite being a bit smaller than the last merge window, it's not like
> > this was a _tiny_ one, and so as usual I'm only summarizing with the
> > normal -rc1 mergelog: and as usual the people credited here are *not*
> > the people who actually wrote the code (although in some cases that is
> > true), they are the people who I merged the code from.
> > 
> > Hey, let's all start testing,
> 
> Anyone else seeing this:
> 
> [    2.212548] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x29 impl SATA mode
> [    2.220732] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp pio slum part ccc sxs 
> [    2.228997] BUG: unable to handle kernel NULL pointer dereference at 0000000000000508
> [    2.236850] IP: [<ffffffff814084f7>] ahci_host_activate+0x87/0x140
> [    2.243047] PGD 0 
> [    2.245077] Oops: 0000 [#1] SMP 
> [    2.248335] Modules linked in:
> [    2.251405] CPU: 7 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc1+ #574
> [    2.257929] Hardware name: LENOVO 4157CTO/LENOVO, BIOS 60KT41AUS 01/04/2011
> [    2.264880] task: ffff880371508000 ti: ffff880371510000 task.ti: ffff880371510000
> [    2.272353] RIP: 0010:[<ffffffff814084f7>]  [<ffffffff814084f7>] ahci_host_activate+0x87/0x140
> [    2.280969] RSP: 0018:ffff880371511b38  EFLAGS: 00010293
> [    2.286273] RAX: ffff88036e724000 RBX: ffff88036e71c028 RCX: ffffffff8140bce0
> [    2.293397] RDX: 0000000000000000 RSI: 000000000000002f RDI: ffff88037122f098
> [    2.300521] RBP: ffff880371511b68 R08: 0000000000000080 R09: 0000000000000001
> [    2.307645] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> [    2.314772] R13: 000000000000002e R14: 0000000000000000 R15: ffff88037122f000
> [    2.321896] FS:  0000000000000000(0000) GS:ffff88037fdc0000(0000) knlGS:0000000000000000
> [    2.329973] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    2.335711] CR2: 0000000000000508 CR3: 0000000001c0b000 CR4: 00000000000007e0
> [    2.342835] Stack:
> [    2.344848]  ffff88036e720000 ffff88037122f000 0000000000000005 ffff88037122f098
> [    2.352301]  ffff88036e734000 ffff88036e71c028 ffff880371511c38 ffffffff81408eae
> [    2.359756]  ffff880300000000 ffff88037122f098 ffff8803710be7a8 ffff880300000010
> [    2.367210] Call Trace:
> [    2.369655]  [<ffffffff81408eae>] ahci_init_one+0x8fe/0xaa0
> [    2.375221]  [<ffffffff816141cf>] ? _raw_spin_unlock_irqrestore+0x3f/0x70
> [    2.382006]  [<ffffffff8132529b>] local_pci_probe+0x4b/0x80
> [    2.387571]  [<ffffffff81325501>] pci_device_probe+0x111/0x120
> [    2.393405]  [<ffffffff813bf43b>] driver_probe_device+0x8b/0x390
> [    2.399411]  [<ffffffff813bf7eb>] __driver_attach+0xab/0xb0
> [    2.404984]  [<ffffffff813bf740>] ? driver_probe_device+0x390/0x390
> [    2.411241]  [<ffffffff813bd2cd>] bus_for_each_dev+0x5d/0xa0
> [    2.416893]  [<ffffffff813bed7e>] driver_attach+0x1e/0x20
> [    2.422284]  [<ffffffff813be917>] bus_add_driver+0x117/0x290
> [    2.427937]  [<ffffffff81d54755>] ? libata_transport_init+0x5e/0x5e
> [    2.434201]  [<ffffffff813bfc8a>] driver_register+0x7a/0x170
> [    2.439853]  [<ffffffff81d54755>] ? libata_transport_init+0x5e/0x5e
> [    2.446110]  [<ffffffff81324ce4>] __pci_register_driver+0x64/0x70
> [    2.452196]  [<ffffffff81d5476e>] ahci_pci_driver_init+0x19/0x1b
> [    2.458196]  [<ffffffff810002fa>] do_one_initcall+0xfa/0x1b0
> [    2.463853]  [<ffffffff8107b100>] ? parse_args+0x1f0/0x450
> [    2.469332]  [<ffffffff81d13ff8>] kernel_init_freeable+0x154/0x1e3
> [    2.475510]  [<ffffffff81d1383f>] ? do_early_param+0x8c/0x8c
> [    2.481163]  [<ffffffff81602140>] ? rest_init+0xe0/0xe0
> [    2.486390]  [<ffffffff8160214e>] kernel_init+0xe/0xf0
> [    2.491530]  [<ffffffff8161cf5c>] ret_from_fork+0x7c/0xb0
> [    2.496928]  [<ffffffff81602140>] ? rest_init+0xe0/0xe0
> [    2.502144] Code: 88 00 00 00 49 63 c4 48 8b 7b 38 43 8d 34 2c 48 8b 84 c3 00 01 00 00 41 b8 80 00 00 00 48 c7 c1 e0 bc 40 81 48 8b 90 78 37 00 00 <4c> 8b 8a 08 05 00 00 48 89 04 24 48 c7 c2 90 be 40 81 e8 f2 b7 
> [    2.522097] RIP  [<ffffffff814084f7>] ahci_host_activate+0x87/0x140
> [    2.528372]  RSP <ffff880371511b38>
> [    2.531858] CR2: 0000000000000508
> [    2.535184] ---[ end trace 66267c9b7b73f56b ]---
> [    2.539808] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
> 

Bisected to:

commit b29900e62598cecd519c9ab2b8e4d03f8ebf702d
Author: Alexander Gordeev <agordeev@redhat.com>
Date:   Wed May 22 08:53:48 2013 +0900

    AHCI: Make distinct names for ports in /proc/interrupts
    
    Currently all interrupts assigned to AHCI ports show up in
    '/proc/interrupts' as 'ahci'. This fix adds port numbers as
    suffixes and hence makes the descriptions distinct.
    
    Reported-by: Jan Beulich <JBeulich@suse.com>
    Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>


