Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308Ab3EDAQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 20:16:05 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55488 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762322Ab3EDAQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 20:16:03 -0400
X-Nat-Received: from [202.181.97.72]:60084 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1367626552.20444
To: cl@linux.com
Cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com><201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp><0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com><201305040348.CIF81716.OStQOHFJMFLOVF@I-love.SAKURA.ne.jp><0000013e6bd7a766-8473586c-7937-4129-bad1-a4198acdddcf-000000@email.amazonses.com>
In-Reply-To: <0000013e6bd7a766-8473586c-7937-4129-bad1-a4198acdddcf-000000@email.amazonses.com>
Message-Id: <201305040915.AID02071.FHVQJtOFOMOLSF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 4 May 2013 09:15:46 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 03052013 #9880688, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Ok could I see the kernel logs with the warnings?
Sure.

---------- testcase ----------
volatile unsigned int size;
for (size = 4 * 1024 * 1024; size <= 32 * 1024 * 1024; size <<= 1) {
	void *ptr = kmalloc(size, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", size, ptr);
	kfree(ptr);
}
---------- testcase ----------

---------- before applying this patch ----------
kmalloc(4194304)=d9c00000
kmalloc(8388608)=  (null)
kmalloc(16777216)=  (null)
------------[ cut here ]------------
Kernel BUG at c10b9c5b [verbose debug info unavailable]
invalid opcode: 0000 [#1] SMP
Modules linked in: test(OF+) binfmt_misc
CPU: 0 PID: 3881 Comm: insmod Tainted: GF          O 3.9.0-rc8-next-20130426 #1
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 08/15/2008
task: df2a3b30 ti: de0a0000 task.ti: de0a0000
EIP: 0060:[<c10b9c5b>] EFLAGS: 00010202 CPU: 0
EIP is at cache_alloc_refill+0x56b/0x590
EAX: 00000040 EBX: df002680 ECX: 00000000 EDX: 00000010
ESI: df000ac0 EDI: 00000000 EBP: 00000001 ESP: de0a1e08
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: b769f3e0 CR3: 1f0fc000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Stack:
 00000000 00000000 00000000 000000d0 00000000 00000010 00000040 00000246
 000000d0 00000000 00000000 df000ac0 00000202 000000d0 c10b9d0e ffffffff
 00000000 e0838040 00000001 00000000 e083a01c e0838024 01000000 00000000
Call Trace:
 [<c10b9d0e>] ? __kmalloc+0x8e/0xd0
 [<e083a01c>] ? test_init+0x1c/0x5c [test]
 [<c1000102>] ? do_one_initcall+0x32/0x170
 [<c10b3098>] ? __vunmap+0xa8/0xe0
 [<e083a000>] ? 0xe0839fff
 [<c106e066>] ? load_module+0x1196/0x1560
 [<c106e7e0>] ? SyS_init_module+0xb0/0xd0
 [<c143273a>] ? sysenter_do_call+0x12/0x22
Code: 85 c0 0f 84 05 ff ff ff 31 c9 89 ea 89 f0 e8 8d f9 ff ff e9 f5 fe ff ff 0f 0b eb fe 8b 6e 20 f7 c5 01 00 00 00 0f 84 95 fd ff ff <0f> 0b eb fe 0f 0b eb fe 0f b6 44 24 1f 89 da 8b 4c 24 20 89 04
EIP: [<c10b9c5b>] cache_alloc_refill+0x56b/0x590 SS:ESP 0068:de0a1e08
---[ end trace f0be5ebb0e2c1371 ]---
---------- before applying this patch ----------

---------- after applying this patch ----------
kmalloc(4194304)=d7000000
------------[ cut here ]------------
WARNING: at mm/slab_common.c:377 kmalloc_slab+0x57/0x70()
Modules linked in: test(OF+) binfmt_misc
CPU: 1 PID: 4337 Comm: insmod Tainted: GF       W  O 3.9.0-rc8-next-20130426-dirty #2
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 08/15/2008
 c142f6a1 c102fbcb c1538e8c c153f938 00000179 c10a5197 c10a5197 d7000000
 e1584040 00000001 000000d0 c102fc1b 00000009 00000000 c10a5197 d7000000
 c10ba3da 00000286 d7000000 e1584040 00000001 00000000 e158601c e1584024
Call Trace:
 [<c142f6a1>] ? dump_stack+0xa/0x19
 [<c102fbcb>] ? warn_slowpath_common+0x6b/0xa0
 [<c10a5197>] ? kmalloc_slab+0x57/0x70
 [<c10a5197>] ? kmalloc_slab+0x57/0x70
 [<c102fc1b>] ? warn_slowpath_null+0x1b/0x20
 [<c10a5197>] ? kmalloc_slab+0x57/0x70
 [<c10ba3da>] ? __kmalloc+0x1a/0xd0
 [<e158601c>] ? test_init+0x1c/0x5c [test]
 [<c1000102>] ? do_one_initcall+0x32/0x170
 [<c10b30b8>] ? __vunmap+0xa8/0xe0
 [<e1586000>] ? 0xe1585fff
 [<c106e066>] ? load_module+0x1196/0x1560
 [<c106e7e0>] ? SyS_init_module+0xb0/0xd0
 [<c143273a>] ? sysenter_do_call+0x12/0x22
---[ end trace b6ab930b322ad480 ]---
kmalloc(8388608)=  (null)
------------[ cut here ]------------
WARNING: at mm/slab_common.c:377 kmalloc_slab+0x57/0x70()
Modules linked in: test(OF+) binfmt_misc
CPU: 1 PID: 4337 Comm: insmod Tainted: GF       W  O 3.9.0-rc8-next-20130426-dirty #2
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 08/15/2008
 c142f6a1 c102fbcb c1538e8c c153f938 00000179 c10a5197 c10a5197 00000000
 e1584040 00000001 000000d0 c102fc1b 00000009 00000000 c10a5197 00000000
 c10ba3da ffffffff 00000000 e1584040 00000001 00000000 e158601c e1584024
Call Trace:
 [<c142f6a1>] ? dump_stack+0xa/0x19
 [<c102fbcb>] ? warn_slowpath_common+0x6b/0xa0
 [<c10a5197>] ? kmalloc_slab+0x57/0x70
 [<c10a5197>] ? kmalloc_slab+0x57/0x70
 [<c102fc1b>] ? warn_slowpath_null+0x1b/0x20
 [<c10a5197>] ? kmalloc_slab+0x57/0x70
 [<c10ba3da>] ? __kmalloc+0x1a/0xd0
 [<e158601c>] ? test_init+0x1c/0x5c [test]
 [<c1000102>] ? do_one_initcall+0x32/0x170
 [<c10b30b8>] ? __vunmap+0xa8/0xe0
 [<e1586000>] ? 0xe1585fff
 [<c106e066>] ? load_module+0x1196/0x1560
 [<c106e7e0>] ? SyS_init_module+0xb0/0xd0
 [<c143273a>] ? sysenter_do_call+0x12/0x22
---[ end trace b6ab930b322ad481 ]---
kmalloc(16777216)=  (null)
------------[ cut here ]------------
WARNING: at mm/slab_common.c:377 kmalloc_slab+0x57/0x70()
Modules linked in: test(OF+) binfmt_misc
CPU: 1 PID: 4337 Comm: insmod Tainted: GF       W  O 3.9.0-rc8-next-20130426-dirty #2
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 08/15/2008
 c142f6a1 c102fbcb c1538e8c c153f938 00000179 c10a5197 c10a5197 00000000
 e1584040 00000001 000000d0 c102fc1b 00000009 00000000 c10a5197 00000000
 c10ba3da ffffffff 00000000 e1584040 00000001 00000000 e158601c e1584024
Call Trace:
 [<c142f6a1>] ? dump_stack+0xa/0x19
 [<c102fbcb>] ? warn_slowpath_common+0x6b/0xa0
 [<c10a5197>] ? kmalloc_slab+0x57/0x70
 [<c10a5197>] ? kmalloc_slab+0x57/0x70
 [<c102fc1b>] ? warn_slowpath_null+0x1b/0x20
 [<c10a5197>] ? kmalloc_slab+0x57/0x70
 [<c10ba3da>] ? __kmalloc+0x1a/0xd0
 [<e158601c>] ? test_init+0x1c/0x5c [test]
 [<c1000102>] ? do_one_initcall+0x32/0x170
 [<c10b30b8>] ? __vunmap+0xa8/0xe0
 [<e1586000>] ? 0xe1585fff
 [<c106e066>] ? load_module+0x1196/0x1560
 [<c106e7e0>] ? SyS_init_module+0xb0/0xd0
 [<c143273a>] ? sysenter_do_call+0x12/0x22
---[ end trace b6ab930b322ad482 ]---
kmalloc(33554432)=  (null)
---------- after applying this patch ----------
