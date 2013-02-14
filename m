Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161174Ab3BNWsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:48:15 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:65114 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161134Ab3BNWsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:48:09 -0500
MIME-Version: 1.0
In-Reply-To: <20130203170213.GQ8476@sortiz-mobl>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
	<3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
	<20130203170213.GQ8476@sortiz-mobl>
Date: Thu, 14 Feb 2013 14:48:05 -0800
Message-ID: <CAOMFOmW3XdSCJrQJk57-dKNcsyh-B7xcBRKLqpniEd+ROSRvBw@mail.gmail.com>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Aaron Sierra <asierra@xes-inc.com>,
        =?UTF-8?B?QWfDs2NzIFDDoWw=?= <agocs.pal.86@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Aaron

On Sun, Feb 3, 2013 at 9:02 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Arron,
>
> On Thu, Jan 24, 2013 at 02:52:39PM -0600, Aaron Sierra wrote:
>> In ICH5 and earlier the GPIOBASE and GPIOCTRL registers are found at
>> offsets 0x58 and 0x5C, respectively. This patch allows GPIO access to
>> properly be enabled (and disabled) for these chipsets.
>>
>> Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>
>> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
>> ---
>>  drivers/mfd/lpc_ich.c |  109 ++++++++++++++++++++++++++++++++++---------------
>>  1 file changed, 76 insertions(+), 33 deletions(-)
> I applied this one to my for-next branch, but:
>
>
>> @@ -858,14 +874,35 @@ wdt_done:
>>  static int lpc_ich_probe(struct pci_dev *dev,
>>                               const struct pci_device_id *id)
>>  {
>> +     struct lpc_ich_priv *priv;
>>       int ret;
>>       bool cell_added = false;
>>
>> -     ret = lpc_ich_init_wdt(dev, id);
>> +     priv = kmalloc(GFP_KERNEL, sizeof(struct lpc_ich_priv));
>> +     if (!priv)
>> +             return -ENOMEM;
> Could you please come back to me with a follow up patch that would convert
> this to the devm_kzalloc() API ?

I compiled linux-next (sha == 019f4bc86a462), tried to boot it on my
machine and it fails at the very early stage with following oops:


    0.000000] NUMA: nodes only cover 0MB of your 98292MB e820 RAM. Not used.
[    1.008406] kvm: already loaded the other module
[    1.206776] ------------[ cut here ]------------
[    1.211395] kernel BUG at mm/slab.c:2772!
[    1.215400] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[    1.220846] Modules linked in:
[    1.223917] CPU 15
[    1.225842] Pid: 1, comm: swapper/0 Not tainted 3.8.0-next-20130214-dbg-DEV
[    1.235763] RIP: 0010:[<ffffffff8118d740>]  [<ffffffff8118d740>]
cache_grow+0x460/0x470
[    1.243784] RSP: 0000:ffff8817ed6f7b68  EFLAGS: 00010002
[    1.249093] RAX: ffff8817ed6f7fd8 RBX: ffff881811c22fc0 RCX: 0000000000000000
[    1.256224] RDX: 0000000000000000 RSI: 000000000004121c RDI: ffff881811c22fc0
[    1.263351] RBP: ffff8817ed6f7bb8 R08: 0000000000000001 R09: 0000000000000000
[    1.270483] R10: 0000000000000003 R11: 0000000000000000 R12: ffff8817ec92ce00
[    1.277610] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000000c
[    1.284738] FS:  0000000000000000(0000) GS:ffff8818733e0000(0000)
knlGS:0000000000000000
[    1.292821] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.298563] CR2: 0000000000000000 CR3: 0000000001a0b000 CR4: 00000000000007e0
[    1.305691] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.312820] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    1.319946] Process swapper/0 (pid: 1, threadinfo ffff8817ed6f6000,
task ffff8817ed6f4040)
[    1.328203] Stack:
[    1.330215]  ffff8817ec92ce00 ffff881811c27100 ffff8817ec92ce00
0000000000000000
[    1.337673]  ffff881811c27158 ffff881811c22fc0 ffff8817ec92ce00
0000000000000000
[    1.345132]  ffff881811c27158 000000000000000c ffff8817ed6f7c48
ffffffff8118db02
[    1.352589] Call Trace:
[    1.355035]  [<ffffffff8118db02>] cache_alloc_refill+0x3b2/0x430
[    1.361036]  [<ffffffff811860b5>] ? interleave_nodes+0x85/0xa0
[    1.366864]  [<ffffffff8118e737>] kmem_cache_alloc_trace+0x167/0x2e0
[    1.373214]  [<ffffffff810daa2d>] ? trace_hardirqs_on+0xd/0x10
[    1.379050]  [<ffffffff813eb9a2>] ? lpc_ich_probe+0x32/0x510
[    1.384714]  [<ffffffff813eb9a2>] lpc_ich_probe+0x32/0x510
[    1.390196]  [<ffffffff815d86fb>] ? _raw_spin_unlock+0x2b/0x50
[    1.396025]  [<ffffffff8133493c>] ? pci_match_device+0xdc/0xf0
[    1.401853]  [<ffffffff81334abf>] pci_device_probe+0x12f/0x140
[    1.407683]  [<ffffffff813e2249>] driver_probe_device+0x89/0x390
[    1.413689]  [<ffffffff813e25fb>] __driver_attach+0xab/0xb0
[    1.419260]  [<ffffffff813e2550>] ? driver_probe_device+0x390/0x390
[    1.425529]  [<ffffffff813e2550>] ? driver_probe_device+0x390/0x390
[    1.431789]  [<ffffffff813e03e4>] bus_for_each_dev+0x64/0xa0
[    1.437445]  [<ffffffff813e1cce>] driver_attach+0x1e/0x20
[    1.442840]  [<ffffffff813e17a1>] bus_add_driver+0x101/0x290
[    1.448501]  [<ffffffff81b1de59>] ? lkdtm_module_init+0x1ce/0x1ce
[    1.454588]  [<ffffffff813e291a>] driver_register+0x7a/0x160
[    1.460245]  [<ffffffff81b1de59>] ? lkdtm_module_init+0x1ce/0x1ce
[    1.466332]  [<ffffffff81334574>] __pci_register_driver+0x64/0x70
[    1.472421]  [<ffffffff81b1de72>] lpc_ich_init+0x19/0x1b
[    1.477738]  [<ffffffff8100020f>] do_one_initcall+0x3f/0x170
[    1.483400]  [<ffffffff81aeef7d>] kernel_init_freeable+0x137/0x1c6
[    1.489574]  [<ffffffff81aee837>] ? do_early_param+0x87/0x87
[    1.495229]  [<ffffffff815ca890>] ? rest_init+0xe0/0xe0
[    1.500451]  [<ffffffff815ca89e>] kernel_init+0xe/0xf0
[    1.505587]  [<ffffffff815e0f5c>] ret_from_fork+0x7c/0xb0
[    1.510987]  [<ffffffff815ca890>] ? rest_init+0xe0/0xe0
[    1.516207] Code: 74 9c fa 89 45 b0 e8 a0 81 f4 ff 8b 45 b0 eb 8e
8b 75 c8 44 89 ea 48 89 df e8 3d d8 ff ff 48 85 c0 49 89 c6 74 d1 e9
39 fc ff ff <0f> 0b b8 01 00 00 00 e9 b7 fc ff ff 0f 1f 40 00 66 66 66
66 90
[    1.536170] RIP  [<ffffffff8118d740>] cache_grow+0x460/0x470
[    1.541842]  RSP <ffff8817ed6f7b68>
[    1.545336] ---[ end trace 0ff547b29d70eb9b ]---
[    1.549953] Kernel panic - not syncing: Fatal exception
[    1.555187] Rebooting in 10 seconds..


Aaron, could it be related your change somehow?
