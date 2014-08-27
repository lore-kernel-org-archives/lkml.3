Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaH0DRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 23:17:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42377 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbaH0DRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 23:17:52 -0400
Message-ID: <53FD4D9F.6050500@oracle.com>
Date: Tue, 26 Aug 2014 23:16:47 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
References: <53DD5F20.8010507@oracle.com> <alpine.LSU.2.11.1408040418500.3406@eggly.anvils> <20140805144439.GW10819@suse.de> <alpine.LSU.2.11.1408051649330.6591@eggly.anvils> <53E17F06.30401@oracle.com> <53E989FB.5000904@oracle.com>
In-Reply-To: <53E989FB.5000904@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 11:28 PM, Sasha Levin wrote:
> On 08/05/2014 09:04 PM, Sasha Levin wrote:
>> > Thanks Hugh, Mel. I've added both patches to my local tree and will update tomorrow
>> > with the weather.
>> > 
>> > Also:
>> > 
>> > On 08/05/2014 08:42 PM, Hugh Dickins wrote:
>>> >> One thing I did wonder, though: at first I was reassured by the
>>> >> VM_BUG_ON(!pte_present(pte)) you add to pte_mknuma(); but then thought
>>> >> it would be better as VM_BUG_ON(!(val & _PAGE_PRESENT)), being stronger
>>> >> - asserting that indeed we do not put NUMA hints on PROT_NONE areas.
>>> >> (But I have not tested, perhaps such a VM_BUG_ON would actually fire.)
>> > 
>> > I've added VM_BUG_ON(!(val & _PAGE_PRESENT)) in just as a curiosity, I'll
>> > update how that one looks as well.
> Sorry for the rather long delay.
> 
> The patch looks fine, the issue didn't reproduce.
> 
> The added VM_BUG_ON didn't trigger either, so maybe we should consider adding
> it in.

It took a while, but I've managed to hit that VM_BUG_ON:

[  707.975456] kernel BUG at include/asm-generic/pgtable.h:724!
[  707.977147] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  707.978974] Dumping ftrace buffer:
[  707.980110]    (ftrace buffer empty)
[  707.981221] Modules linked in:
[  707.982312] CPU: 18 PID: 9488 Comm: trinity-c538 Not tainted 3.17.0-rc2-next-20140826-sasha-00031-gc48c9ac-dirty #1079
[  707.982801] task: ffff880165e28000 ti: ffff880165e30000 task.ti: ffff880165e30000
[  707.982801] RIP: 0010:[<ffffffffb42e3dda>]  [<ffffffffb42e3dda>] change_protection_range+0x94a/0x970
[  707.982801] RSP: 0018:ffff880165e33d98  EFLAGS: 00010246
[  707.982801] RAX: 000000009d340902 RBX: ffff880511204a08 RCX: 0000000000000100
[  707.982801] RDX: 000000009d340902 RSI: 0000000041741000 RDI: 000000009d340902
[  707.982801] RBP: ffff880165e33e88 R08: ffff880708a23c00 R09: 0000000000b52000
[  707.982801] R10: 0000000000001e01 R11: 0000000000000008 R12: 0000000041751000
[  707.982801] R13: 00000000000000f7 R14: 000000009d340902 R15: 0000000041741000
[  707.982801] FS:  00007f358a9aa700(0000) GS:ffff88071c600000(0000) knlGS:0000000000000000
[  707.982801] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  707.982801] CR2: 00007f3586b69490 CR3: 0000000165d88000 CR4: 00000000000006a0
[  707.982801] Stack:
[  707.982801]  ffff8804db88d058 0000000000000000 ffff88070fb17cf0 0000000000000000
[  707.982801]  ffff880165d88000 0000000000000000 ffff8801686a5000 000000004163e000
[  707.982801]  ffff8801686a5000 0000000000000001 0000000000000025 0000000041750fff
[  707.982801] Call Trace:
[  707.982801]  [<ffffffffb42e3e14>] change_protection+0x14/0x30
[  707.982801]  [<ffffffffb42fda3b>] change_prot_numa+0x1b/0x40
[  707.982801]  [<ffffffffb41ad766>] task_numa_work+0x1f6/0x330
[  707.982801]  [<ffffffffb41937c4>] task_work_run+0xc4/0xf0
[  707.982801]  [<ffffffffb40712e7>] do_notify_resume+0x97/0xb0
[  707.982801]  [<ffffffffb74fd6ea>] int_signal+0x12/0x17
[  707.982801] Code: e8 2c 84 21 03 e9 72 ff ff ff 0f 1f 80 00 00 00 00 0f 0b 48 8b 7d a8 4c 89 f2 4c 89 fe e8 9f 7b 03 00 e9 47 f9 ff ff 0f 0b 0f 0b <0f> 0b 0f 0b 48 8b b5 70 ff ff ff 4c 89 ea 48 89 c7 e8 10 d5 01
[  707.982801] RIP  [<ffffffffb42e3dda>] change_protection_range+0x94a/0x970
[  707.982801]  RSP <ffff880165e33d98>


Thanks,
Sasha
