Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbbAPQ4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:56:21 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:33951 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbbAPQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:56:19 -0500
Message-ID: <54B942B0.3030003@hurleysoftware.com>
Date: Fri, 16 Jan 2015 11:56:16 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>, Peter Zijlstra <peterz@infradead.org>
CC: Sedat Dilek <sedat.dilek@gmail.com>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com> <20150106094039.GI29390@twins.programming.kicks-ass.net> <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com> <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com> <20150106100621.GL29390@twins.programming.kicks-ass.net> <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com> <20150106110112.GQ29390@twins.programming.kicks-ass.net> <20150106110730.GA25846@kmo-pixel>
In-Reply-To: <20150106110730.GA25846@kmo-pixel>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 06:07 AM, Kent Overstreet wrote:
> On Tue, Jan 06, 2015 at 12:01:12PM +0100, Peter Zijlstra wrote:
>> On Tue, Jan 06, 2015 at 11:18:04AM +0100, Sedat Dilek wrote:
>>> On Tue, Jan 6, 2015 at 11:06 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>> On Tue, Jan 06, 2015 at 10:57:19AM +0100, Sedat Dilek wrote:
>>>>> [   88.028739]  [<ffffffff8124433f>] aio_read_events+0x4f/0x2d0
>>>>>
>>>>
>>>> Ah, that one. Chris Mason and Kent Overstreet were looking at that one.
>>>> I'm not touching the AIO code either ;-)
>>>
>>> I know, I was so excited when I see nearly the same output.
>>>
>>> Can you tell me why people see "similiar" problems in different areas?
>>
>> Because the debug check is new :-) It's a pattern that should not be
>> used but mostly works most of the times.
>>
>>> [  181.397024] WARNING: CPU: 0 PID: 2872 at kernel/sched/core.c:7303
>>> __might_sleep+0xbd/0xd0()
>>> [  181.397028] do not call blocking ops when !TASK_RUNNING; state=1
>>> set at [<ffffffff810b83bd>] prepare_to_wait_event+0x5d/0x110
>>>
>>> With similiar buzzwords... namely...
>>>
>>> mutex_lock_nested
>>> prepare_to_wait(_event)
>>> __might_sleep
>>>
>>> I am asking myself... Where is the real root cause - in sched/core?
>>> Fix one single place VS. fix the impact at several other places?
>>
>> No, the root cause is nesting sleep primitives, this is not fixable in
>> the one place, both prepare_to_wait and mutex_lock are using
>> task_struct::state, they have to, no way around it.
> 
> No, it's completely possible to construct a prepare_to_wait() that doesn't
> require messing with the task state. Had it for years.
> 
> http://evilpiepirate.org/git/linux-bcache.git/log/?h=aio_ring_fix

Peter & Kent,

What's the plan here?

I ask because this triggers a max cpu utilization in mysql (mysqld is
795% on 8 cores). The machine is still usable so the threads are at
least sleeping :)

I grabbed cpu backtraces [1] in case anyone cares.

Regards,
Peter Hurley

PS - I didn't bother bisecting because bisection near the new checks
for nested sleeps results in inop machine (my fault: when I reviewed
that series, I should have realized that the patches needed to
go in backwards).

[1] cpu backtraces
[   90.667392] sending NMI to all CPUs:
[   90.667552] NMI backtrace for cpu 0
[   90.667555] CPU: 0 PID: 2032 Comm: mysqld Tainted: G        W      3.19.0-rc4+wip-xeon+debug #rc4+wip
[   90.667557] Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
[   90.667558] task: ffff8800bb768000 ti: ffff8800ba770000 task.ti: ffff8800ba770000
[   90.667560] RIP: 0010:[<ffffffff817b4a8a>]  [<ffffffff817b4a8a>] mutex_lock_nested+0xda/0x530
[   90.667562] RSP: 0018:ffff8800ba773d48  EFLAGS: 00000046
[   90.667563] RAX: 000000000000d8d8 RBX: ffff8800bad7b000 RCX: 0000000000000000
[   90.667565] RDX: 00000000000000d8 RSI: 0000000000000001 RDI: ffffffff810bf71d
[   90.667566] RBP: ffff8800ba773db8 R08: 0000000000000000 R09: 0000000000000000
[   90.667568] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800bad7b200
[   90.667570] R13: ffff8800bad7b208 R14: 0000000000000246 R15: ffff8800bb768000
[   90.667572] FS:  00007fd92d07e700(0000) GS:ffff8802b4600000(0000) knlGS:0000000000000000
[   90.667573] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   90.667575] CR2: 00007f265ffff9c8 CR3: 00000002af011000 CR4: 00000000000007f0
[   90.667576] Stack:
[   90.667578]  ffffffff8124bbca ffffffff810bfaae ffffffff8124bbca ffff8800bad7b278
[   90.667580]  00000000457705c0 ffffffff817b97a5 ffffffff817b97a5 ffff8800bb768000
[   90.667582]  ffff8800ba773da8 ffff8800bad7b000 0000000000000001 ffff8800bad7b000
[   90.667583] Call Trace:
[   90.667585]  [<ffffffff8124bbca>] ? aio_read_events+0x4a/0x350
[   90.667586]  [<ffffffff810bfaae>] ? put_lock_stats.isra.26+0xe/0x30
[   90.667588]  [<ffffffff8124bbca>] ? aio_read_events+0x4a/0x350
[   90.667590]  [<ffffffff817b97a5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[   90.667591]  [<ffffffff817b97a5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[   90.667593]  [<ffffffff8124bbca>] aio_read_events+0x4a/0x350
[   90.667594]  [<ffffffff810b7a05>] ? prepare_to_wait_event+0x95/0x110
[   90.667596]  [<ffffffff8124c0cc>] read_events+0x1fc/0x230
[   90.667598]  [<ffffffff810b7a80>] ? prepare_to_wait_event+0x110/0x110
[   90.667599]  [<ffffffff810eae00>] ? hrtimer_get_res+0x50/0x50
[   90.667601]  [<ffffffff810eb384>] ? hrtimer_start_range_ns+0x14/0x20
[   90.667602]  [<ffffffff8124c1c0>] ? lookup_ioctx+0xc0/0x150
[   90.667604]  [<ffffffff8124e0d9>] SyS_io_getevents+0x59/0x110
[   90.667606]  [<ffffffff817ba46d>] system_call_fastpath+0x16/0x1b
[   90.667608] Code: 00 f0 66 41 0f c1 44 24 08 0f b6 d4 38 c2 0f 85 82 03 00 00 44 8b 05 1e 7e 62 01 45 85 c0 75 0b 4d 3b 64 24 70 0f 85 e3 03 00 00 <41> 8b 04 24 83 f8 01 0f 84 39 02 00 00 48 8d 75 b0 4c 89 e7 e8 
[   90.667610] NMI backtrace for cpu 1
[   90.667612] CPU: 1 PID: 2024 Comm: mysqld Tainted: G        W      3.19.0-rc4+wip-xeon+debug #rc4+wip
[   90.667613] Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
[   90.667615] task: ffff8802b1ea4b20 ti: ffff8800bf124000 task.ti: ffff8800bf124000
[   90.667617] RIP: 0010:[<ffffffff810a53c9>]  [<ffffffff810a53c9>] local_clock+0x9/0x30
[   90.667618] RSP: 0018:ffff8800bf127c58  EFLAGS: 00000002
[   90.667620] RAX: 0000000000000004 RBX: ffff8802b1ea4b20 RCX: 0000000000000000
[   90.667622] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800bad78e78
[   90.667623] RBP: ffff8800bf127c58 R08: 0000000000000001 R09: 0000000000000000
[   90.667625] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000549
[   90.667626] R13: ffff8802b1ea53f8 R14: 0000000000000000 R15: ffff8800bad78e78
[   90.667628] FS:  00007fd931086700(0000) GS:ffff8802b4800000(0000) knlGS:0000000000000000
[   90.667630] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   90.667631] CR2: 00007f17540010b8 CR3: 00000002af011000 CR4: 00000000000007e0
[   90.667633] Stack:
[   90.667635]  ffff8800bf127cc8 ffffffff810c3bc0 ffff8800bf127c98 ffffffff810a50f5
[   90.667636]  ffff8800bf127c98 ffff8802b49d5b80 00000000001d5b80 ffff880200000001
[   90.667638]  ffff8800bf127cb8 0000000000000246 0000000000000000 0000000000000000
[   90.667640] Call Trace:
[   90.667641]  [<ffffffff810c3bc0>] __lock_acquire+0x250/0x10b0
[   90.667643]  [<ffffffff810a50f5>] ? sched_clock_local+0x25/0x90
[   90.667644]  [<ffffffff810c51cd>] lock_acquire+0xbd/0x170
[   90.667646]  [<ffffffff8124bbca>] ? aio_read_events+0x4a/0x350
[   90.667647]  [<ffffffff8124bbca>] ? aio_read_events+0x4a/0x350
[   90.667649]  [<ffffffff817b4a22>] mutex_lock_nested+0x72/0x530
[   90.667651]  [<ffffffff8124bbca>] ? aio_read_events+0x4a/0x350
[   90.667652]  [<ffffffff810bfaae>] ? put_lock_stats.isra.26+0xe/0x30
[   90.667654]  [<ffffffff8124bbca>] ? aio_read_events+0x4a/0x350
[   90.667656]  [<ffffffff817b97a5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[   90.667657]  [<ffffffff817b97a5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[   90.667659]  [<ffffffff8124bbca>] aio_read_events+0x4a/0x350
[   90.667660]  [<ffffffff810b7a05>] ? prepare_to_wait_event+0x95/0x110
[   90.667662]  [<ffffffff8124c0cc>] read_events+0x1fc/0x230
[   90.667664]  [<ffffffff810b7a80>] ? prepare_to_wait_event+0x110/0x110
[   90.667665]  [<ffffffff810eae00>] ? hrtimer_get_res+0x50/0x50
[   90.667667]  [<ffffffff810eb384>] ? hrtimer_start_range_ns+0x14/0x20
[   90.667669]  [<ffffffff8124c1c0>] ? lookup_ioctx+0xc0/0x150
[   90.667670]  [<ffffffff8124e0d9>] SyS_io_getevents+0x59/0x110
[   90.667672]  [<ffffffff817ba46d>] system_call_fastpath+0x16/0x1b
[   90.667674] Code: 00 00 55 48 89 e5 66 66 66 66 90 e8 f2 fe ff ff 5d c3 e8 6b c7 f7 ff 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 <65> 8b 3d 38 4d f6 7e e8 cb fe ff ff 5d c3 66 0f 1f 84 00 00 00 
[   90.667676] NMI backtrace for cpu 2
[   90.667678] CPU: 2 PID: 2023 Comm: mysqld Tainted:  3.19.0-rc4+wip-xeon+debug #rc4+wip
[   90.667679] Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
[   90.667681] task: ffff8802adf64b20 ti: ffff8800bb4fc000 task.ti: ffff8800bb4fc000
[   90.667683] RIP: 0010:[<ffffffff810c3ac4>]  [<ffffffff810c3ac4>] __lock_acquire+0x154/0x10b0
[   90.667684] RSP: 0018:ffff8800bb4ffc68  EFLAGS: 00000006
[   90.667686] RAX: 0000000000000000 RBX: ffff8802adf64b20 RCX: 0000000000000000
[   90.667688] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800bad78278
[   90.667689] RBP: ffff8800bb4ffcc8 R08: 0000000000000001 R09: 0000000000000000
[   90.667691] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff828a03d0
[   90.667692] R13: 0000000000000000 R14: 0000000000000001 R15: ffff8800bad78278
[   90.667694] FS:  00007fd940cdb700(0000) GS:ffff8802b4a00000(0000) knlGS:0000000000000000
[   90.667696] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   90.667697] CR2: 00007f5cae47f000 CR3: 00000002af011000 CR4: 00000000000007e0
[   90.667699] Stack:
[   90.667701]  ffff8800bb4ffc98 ffffffff810a50f5 ffff8800bb4ffc98 ffff8802b4bd5b80
[   90.667702]  00000000001d5b80 ffff8802adf653f8 ffff8800bb4ffcb8 0000000000000246
[   90.667704]  0000000000000000 0000000000000000 0000000000000001 0000000000000000
[   90.667705] Call Trace:
[   90.667707]  [<ffffffff810a50f5>] ? sched_clock_local+0x25/0x90
[   90.667709]  [<ffffffff810c51cd>] lock_acquire+0xbd/0x170
[   90.667710]  [<ffffffff8124bbca>] ? aio_read_events+0x4a/0x350
[   90.667712]  [<ffffffff8124bbca>] ? aio_read_events+0x4a/0x350
[   90.667713]  [<ffffffff817b4a22>] mutex_lock_nested+0x72/0x530
[   90.667715]  [<ffffffff8124bbca>] ? aio_read_events+0x4a/0x350
[   90.667717]  [<ffffffff810bfaae>] ? put_lock_stats.isra.26+0xe/0x30
[   90.667718]  [<ffffffff8124bbca>] ? aio_read_events+0x4a/0x350
[   90.667720]  [<ffffffff817b97a5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[   90.667722]  [<ffffffff817b97a5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[   90.667723]  [<ffffffff8124bbca>] aio_read_events+0x4a/0x350
[   90.667725]  [<ffffffff810b7a05>] ? prepare_to_wait_event+0x95/0x110
[   90.667727]  [<ffffffff8124bb92>] ? aio_read_events+0x12/0x350
[   90.667728]  [<ffffffff8124c0cc>] read_events+0x1fc/0x230
[   90.667730]  [<ffffffff810b7a80>] ? prepare_to_wait_event+0x110/0x110
[   90.667731]  [<ffffffff810eae00>] ? hrtimer_get_res+0x50/0x50
[   90.667733]  [<ffffffff810eb384>] ? hrtimer_start_range_ns+0x14/0x20
[   90.667735]  [<ffffffff8124c1c0>] ? lookup_ioctx+0xc0/0x150
[   90.667736]  [<ffffffff8124e0d9>] SyS_io_getevents+0x59/0x110
[   90.667738]  [<ffffffff817ba46d>] system_call_fastpath+0x16/0x1b
[   90.667740] Code: 00 00 00 44 0f 44 c0 41 83 fd 01 44 89 e8 0f 87 2c ff ff ff 4d 8b 64 c7 08 4d 85 e4 0f 84 28 ff ff ff f0 41 ff 84 24 98 01 00 00 <8b> 05 ce 8d d1 01 44 8b b3 d0 08 00 00 85 c0 75 0a 41 83 fe 2f 
[   90.667742] NMI backtrace for cpu 3
[   90.667743] CPU: 3 PID: 2026 Comm: mysqld Tainted: G        W      3.19.0-rc4+wip-xeon+debug #rc4+wip
[   90.667745] Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
[   90.667747] task: ffff8800bf7d8000 ti: ffff8800ba61c000 task.ti: ffff8800ba61c000
[   90.667748] RIP: 0010:[<ffffffff810c56b1>]  [<ffffffff810c56b1>] lock_release+0xe1/0x2a0
[   90.667750] RSP: 0018:ffff8800ba61fd98  EFLAGS: 00000092
[   90.667752] RAX: ffff8800bf7d8000 RBX: ffff8800bf7d8000 RCX: 000000000000a9c0
[   90.667753] RDX: ffff8802b4c58960 RSI: 000000151c32a5b1 RDI: 0000000000000092
[   90.667755] RBP: ffff8800ba61fdc8 R08: 0000000000000000 R09: 0000000000000001
[   90.667757] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8800bad7b6c0
[   90.667758] R13: ffffffff810b7a05 R14: 0000000000000092 R15: 0000000000000001
[   90.667760] FS:  00007fd930084700(0000) GS:ffff8802b4c00000(0000) knlGS:0000000000000000
[   90.667762] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   90.667763] CR2: 00007fc97c006028 CR3: 00000002af011000 CR4: 00000000000007e0
[   90.667765] Stack:
[   90.667766]  00007fd945764340 0000000000000296 ffff8800bad7b6a8 0000000000000001
[   90.667768]  00007fd945764340 0000000000000000 ffff8800ba61fde8 ffffffff817b9764
[   90.667770]  ffff8800ba61fe68 ffff8800bad7b6a8 ffff8800ba61fe38 ffffffff810b7a05
[   90.667771] Call Trace:
[   90.667773]  [<ffffffff817b9764>] _raw_spin_unlock_irqrestore+0x24/0x80
[   90.667774]  [<ffffffff810b7a05>] prepare_to_wait_event+0x95/0x110
[   90.667776]  [<ffffffff8124c0b1>] read_events+0x1e1/0x230
[   90.667778]  [<ffffffff810b7a80>] ? prepare_to_wait_event+0x110/0x110
[   90.667779]  [<ffffffff810eae00>] ? hrtimer_get_res+0x50/0x50
[   90.667781]  [<ffffffff810eb384>] ? hrtimer_start_range_ns+0x14/0x20
[   90.667782]  [<ffffffff8124c1c0>] ? lookup_ioctx+0xc0/0x150
[   90.667784]  [<ffffffff8124e0d9>] SyS_io_getevents+0x59/0x110
[   90.667786]  [<ffffffff817ba46d>] system_call_fastpath+0x16/0x1b
[   90.667788] Code: 85 b5 00 00 00 4c 89 ea 4c 89 e6 48 89 df e8 e7 fb ff ff 65 48 8b 04 25 80 ba 00 00 c7 80 d4 08 00 00 00 00 00 00 4c 89 f7 57 9d <66> 66 90 66 90 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d f3 c3 
[   90.667790] NMI backtrace for cpu 4
[   90.667791] CPU: 4 PID: 2028 Comm: mysqld Tainted: G        W      3.19.0-rc4+wip-xeon+debug #rc4+wip
[   90.667793] Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
[   90.667795] task: ffff8800bf15cb20 ti: ffff8800bb534000 task.ti: ffff8800bb518000
[   90.667796] RIP: 0010:[<ffffffff810166bf>]  [<ffffffff810166bf>] __switch_to+0x1ff/0x5a0
[   90.667798] RSP: 0018:ffff8800bb51bd60  EFLAGS: 00000046
[   90.667800] RAX: ffff8800bb518000 RBX: ffff8800bf15cb20 RCX: 00000000c0000100
[   90.667801] RDX: 0000000080000002 RSI: 000000002f082700 RDI: 00000000c0000100
[   90.667803] RBP: ffff8800bb51bdb0 R08: 0000000000000000 R09: 0000000000000000
[   90.667805] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8802b03aa590
[   90.667806] R13: ffff8802b4fd21c0 R14: 0000000000000000 R15: ffff8802b03aabf8
[   90.667808] FS:  00007fd92f082700(0000) GS:ffff8802b4e00000(0000) knlGS:0000000000000000
[   90.667810] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   90.667811] CR2: 00007fc9841ab350 CR3: 00000002af011000 CR4: 00000000000007e0
[   90.667813] Stack:
[   90.667815]  ffff8800bf15cb20 00000000b4fd5058 0000000000000004 ffff8800bf15d188
[   90.667816]  0000000000000096 ffff8802b4fd5040 ffff8802ad83b200 ffff8802ad83b200
[   90.667818]  ffff8802b03aa590 0000000000000000 ffff8800bf15cb20 ffffffff817b2a33
[   90.667819] Call Trace:
[   90.667821]  [<ffffffff817b2a33>] __schedule+0x393/0x8d0
[   90.667823]  [<ffffffff817b2f99>] ? schedule+0x29/0x70
[   90.667824]  [<ffffffff8124c099>] ? read_events+0x1c9/0x230
[   90.667826]  [<ffffffff810b7a80>] ? prepare_to_wait_event+0x110/0x110
[   90.667827]  [<ffffffff810eae00>] ? hrtimer_get_res+0x50/0x50
[   90.667829]  [<ffffffff810eb384>] ? hrtimer_start_range_ns+0x14/0x20
[   90.667831]  [<ffffffff8124c1c0>] ? lookup_ioctx+0xc0/0x150
[   90.667832]  [<ffffffff8124e0d9>] ? SyS_io_getevents+0x59/0x110
[   90.667834]  [<ffffffff817ba46d>] ? system_call_fastpath+0x16/0x1b
[   90.667836] Code: 89 05 e6 49 ff 7e 49 8b 44 24 08 65 8b 15 ba 53 ff 7e 65 48 89 1d d2 53 ff 7e 89 50 1c 48 8b 43 08 8b 50 1c 65 89 15 a1 53 ff 7e <48> 8d 90 d8 3f 00 00 65 48 89 15 ba 53 ff 7e f7 40 10 00 00 41 
[   90.667838] NMI backtrace for cpu 5
[   90.667839] CPU: 5 PID: 2030 Comm: mysqld Tainted: G        W      3.19.0-rc4+wip-xeon+debug #rc4+wip
[   90.667841] Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
[   90.667843] task: ffff8802b03a8000 ti: ffff8800bfb7c000 task.ti: ffff8800bfb7c000
[   90.667845] RIP: 0010:[<ffffffff810c3ac4>]  [<ffffffff810c3ac4>] __lock_acquire+0x154/0x10b0
[   90.667846] RSP: 0018:ffff8800bfb7fcd8  EFLAGS: 00000002
[   90.667848] RAX: 0000000000000000 RBX: ffff8802b03a8000 RCX: 0000000000000000
[   90.667850] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800bad78ac0
[   90.667851] RBP: ffff8800bfb7fd38 R08: 0000000000000001 R09: 0000000000000001
[   90.667853] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff828a0d80
[   90.667855] R13: 0000000000000000 R14: 0000000000000001 R15: ffff8800bad78ac0
[   90.667856] FS:  00007fd92e080700(0000) GS:ffff8802b5000000(0000) knlGS:0000000000000000
[   90.667858] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   90.667860] CR2: 00007f9b65f089c8 CR3: 00000002af011000 CR4: 00000000000007e0
[   90.667861] Stack:
[   90.667863]  0000000000000b56 ffff8802b51d5b80 00000000001d5b80 ffffffff817b2f2c
[   90.667864]  ffff8800bfb7fd18 ffffffff810a5358 ffff8802b03a8000 0000000000000046
[   90.667866]  0000000000000000 0000000000000000 0000000000000001 0000000000000000
[   90.667868] Call Trace:
[   90.667869]  [<ffffffff817b2f2c>] ? __schedule+0x88c/0x8d0
[   90.667871]  [<ffffffff810a5358>] ? sched_clock_cpu+0xb8/0xe0
[   90.667872]  [<ffffffff810c51cd>] lock_acquire+0xbd/0x170
[   90.667874]  [<ffffffff810b79c9>] ? prepare_to_wait_event+0x59/0x110
[   90.667876]  [<ffffffff817b95c8>] _raw_spin_lock_irqsave+0x58/0xa0
[   90.667877]  [<ffffffff810b79c9>] ? prepare_to_wait_event+0x59/0x110
[   90.667879]  [<ffffffff817b2a77>] ? __schedule+0x3d7/0x8d0
[   90.667881]  [<ffffffff810b79c9>] prepare_to_wait_event+0x59/0x110
[   90.667882]  [<ffffffff8124c0b1>] read_events+0x1e1/0x230
[   90.667884]  [<ffffffff810b7a80>] ? prepare_to_wait_event+0x110/0x110
[   90.667886]  [<ffffffff810eae00>] ? hrtimer_get_res+0x50/0x50
[   90.667887]  [<ffffffff810eb384>] ? hrtimer_start_range_ns+0x14/0x20
[   90.667889]  [<ffffffff8124c1c0>] ? lookup_ioctx+0xc0/0x150
[   90.667891]  [<ffffffff8124e0d9>] SyS_io_getevents+0x59/0x110
[   90.667892]  [<ffffffff817ba46d>] system_call_fastpath+0x16/0x1b
[   90.667894] Code: 00 00 00 44 0f 44 c0 41 83 fd 01 44 89 e8 0f 87 2c ff ff ff 4d 8b 64 c7 08 4d 85 e4 0f 84 28 ff ff ff f0 41 ff 84 24 98 01 00 00 <8b> 05 ce 8d d1 01 44 8b b3 d0 08 00 00 85 c0 75 0a 41 83 fe 2f 
[   90.667896] NMI backtrace for cpu 6
[   90.667898] CPU: 6 PID: 2025 Comm: mysqld Tainted: G        W      3.19.0-rc4+wip-xeon+debug #rc4+wip
[   90.667900] Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
[   90.667901] task: ffff8802accb8000 ti: ffff8800ba518000 task.ti: ffff8800ba518000
[   90.667903] RIP: 0010:[<ffffffff810bf71d>]  [<ffffffff810bf71d>] trace_hardirqs_off+0xd/0x10
[   90.667904] RSP: 0018:ffff8802b5203908  EFLAGS: 00000046
[   90.667906] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
[   90.667908] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff810bf71d
[   90.667909] RBP: ffff8802b5203908 R08: 0000000000000001 R09: 0000000000000001
[   90.667911] R10: 000000000000048b R11: ffff8802b520361e R12: 0000000000000096
[   90.667913] R13: 0000000000000c00 R14: 00000000000000ff R15: ffff8802adb36ba0
[   90.667914] FS:  00007fd930885700(0000) GS:ffff8802b5200000(0000) knlGS:0000000000000000
[   90.667916] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   90.667917] CR2: 00007fcc1e73b000 CR3: 00000002af011000 CR4: 00000000000007e0
[   90.667919] Stack:
[   90.667921]  ffff8802b5203938 ffffffff810555cf 000000000000d100 0000000000000001
[   90.667922]  0000000000000001 0000000000000004 ffff8802b5203988 ffffffff81051313
[   90.667924]  0000000000000000 0000000000000010 ffff8802b52039a8 ffffffff81cc65a0
[   90.667926] Call Trace:
[   90.667927]  <IRQ> d [<ffffffff810555cf>] flat_send_IPI_mask+0xbf/0xd0
[   90.667929]  [<ffffffff81051313>] arch_trigger_all_cpu_backtrace+0x273/0x280
[   90.667930]  [<ffffffff814ada43>] sysrq_handle_showallcpus+0x13/0x20
[   90.667932]  [<ffffffff814ae187>] __handle_sysrq+0x137/0x1b0
[   90.667934]  [<ffffffff814ae055>] ? __handle_sysrq+0x5/0x1b0
[   90.667935]  [<ffffffff814ae5d9>] sysrq_filter+0x3a9/0x3f0
[   90.667937]  [<ffffffff81606979>] input_to_handler+0x59/0xf0
[   90.667938]  [<ffffffff81609589>] input_pass_values.part.4+0x1a9/0x1b0
[   90.667940]  [<ffffffff816093e5>] ? input_pass_values.part.4+0x5/0x1b0
[   90.667942]  [<ffffffff81609e29>] input_handle_event+0x129/0x550
[   90.667943]  [<ffffffff8160a295>] ? input_event+0x45/0x70
[   90.667945]  [<ffffffff8160a2a9>] input_event+0x59/0x70
[   90.667946]  [<ffffffffa02f409f>] hidinput_report_event+0x3f/0x50 [hid]
[   90.667948]  [<ffffffffa02f2208>] hid_report_raw_event+0x148/0x1c0 [hid]
[   90.667950]  [<ffffffffa02f2399>] hid_input_report+0x119/0x1a0 [hid]
[   90.667951]  [<ffffffffa0120878>] ? logi_dj_raw_event+0x168/0x2d0 [hid_logitech_dj]
[   90.667953]  [<ffffffffa0120973>] logi_dj_raw_event+0x263/0x2d0 [hid_logitech_dj]
[   90.667955]  [<ffffffff817b978a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   90.667956]  [<ffffffffa02f23e7>] hid_input_report+0x167/0x1a0 [hid]
[   90.667958]  [<ffffffffa0327d02>] hid_irq_in+0xc2/0x260 [usbhid]
[   90.667960]  [<ffffffff815bc8e3>] __usb_hcd_giveback_urb+0x83/0x130
[   90.667961]  [<ffffffff815bcab3>] usb_hcd_giveback_urb+0x43/0x120
[   90.667963]  [<ffffffff815e751a>] uhci_giveback_urb+0xaa/0x290
[   90.667965]  [<ffffffff811cb2f7>] ? dma_pool_free+0xa7/0xd0
[   90.667966]  [<ffffffff815e9533>] uhci_scan_schedule+0x493/0xb30
[   90.667968]  [<ffffffff815ea20e>] uhci_irq+0xae/0x1a0
[   90.667969]  [<ffffffff815bbb66>] usb_hcd_irq+0x26/0x40
[   90.667971]  [<ffffffff810d7be9>] handle_irq_event_percpu+0x59/0x260
[   90.667973]  [<ffffffff810d7e31>] handle_irq_event+0x41/0x70
[   90.667974]  [<ffffffff810da928>] ? handle_fasteoi_irq+0x28/0x140
[   90.667976]  [<ffffffff810da982>] handle_fasteoi_irq+0x82/0x140
[   90.667977]  [<ffffffff8101a832>] handle_irq+0x22/0x40
[   90.667979]  [<ffffffff817bd5e1>] do_IRQ+0x51/0xf0
[   90.667981]  [<ffffffff817bb272>] common_interrupt+0x72/0x72
[   90.667982]  <EOI> d [<ffffffff810bfaae>] ? put_lock_stats.isra.26+0xe/0x30
[   90.667984]  [<ffffffff817b97f4>] ? _raw_spin_unlock_irq+0x34/0x60
[   90.667986]  [<ffffffff817b97f0>] ? _raw_spin_unlock_irq+0x30/0x60
[   90.667987]  [<ffffffff810992a1>] finish_task_switch+0x91/0x170
[   90.667989]  [<ffffffff81099262>] ? finish_task_switch+0x52/0x170
[   90.667991]  [<ffffffff817b2a5c>] __schedule+0x3bc/0x8d0
[   90.667992]  [<ffffffff817b2f99>] schedule+0x29/0x70
[   90.667994]  [<ffffffff8124c099>] read_events+0x1c9/0x230
[   90.667996]  [<ffffffff810b7a80>] ? prepare_to_wait_event+0x110/0x110
[   90.667997]  [<ffffffff810eae00>] ? hrtimer_get_res+0x50/0x50
[   90.667999]  [<ffffffff810eb384>] ? hrtimer_start_range_ns+0x14/0x20
[   90.668000]  [<ffffffff8124c1c0>] ? lookup_ioctx+0xc0/0x150
[   90.668002]  [<ffffffff8124e0d9>] SyS_io_getevents+0x59/0x110
[   90.668003]  [<ffffffff817ba46d>] system_call_fastpath+0x16/0x1b
[   90.668003] Code: aa 81 31 c0 be 44 0a 00 00 48 c7 c7 10 92 a9 81 e8 79 3c fb ff eb b4 0f 1f 80 00 00 00 00 55 48 89 e5 48 8b 7d 08 e8 33 ff ff ff <5d> c3 90 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 81 ff 00 30 f3 
[   90.668003] NMI backtrace for cpu 7
[   90.668003] CPU: 7 PID: 2029 Comm: mysqld Tainted: G        W      3.19.0-rc4+wip-xeon+debug #rc4+wip
[   90.668003] Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
[   90.668003] task: ffff8802b04b0000 ti: ffff8800bf924000 task.ti: ffff8800bf924000
[   90.668003] RIP: 0010:[<ffffffff81021486>]  [<ffffffff81021486>] native_read_tsc+0x6/0x20
[   90.668003] RSP: 0018:ffff8800bf927cd8  EFLAGS: 00000092
[   90.668003] RAX: 00000000fe931f38 RBX: ffff8802b55d5b80 RCX: 0000000000000000
[   90.668003] RDX: 000000000000004a RSI: 0000000000000000 RDI: ffff8802b55d5b80
[   90.668003] RBP: ffff8800bf927cd8 R08: 0000000000000000 R09: 0000000000000001
[   90.668003] R10: 0000000000000000 R11: 0000000000000304 R12: 0000000000000000
[   90.668003] R13: ffff8802b55d5b90 R14: 0000000000000092 R15: 0000000000000001
[   90.668003] FS:  00007fd92e881700(0000) GS:ffff8802b5400000(0000) knlGS:0000000000000000
[   90.668003] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   90.668003] CR2: 00007f3289fc6000 CR3: 00000002af011000 CR4: 00000000000007e0
[   90.668003] Stack:
[   90.668003]  ffff8800bf927ce8 ffffffff81021ab5 ffff8800bf927cf8 ffffffff81021b29
[   90.668003]  ffff8800bf927d28 ffffffff810a50f5 ffff8802b04b0000 ffff8802b55d5b80
[   90.668003]  00000000001d5b80 ffffffff810b7a05 ffff8800bf927d48 ffffffff810a5358
[   90.668003] Call Trace:
[   90.668003]  [<ffffffff81021ab5>] native_sched_clock+0x35/0xa0
[   90.668003]  [<ffffffff81021b29>] sched_clock+0x9/0x10
[   90.668003]  [<ffffffff810a50f5>] sched_clock_local+0x25/0x90
[   90.668003]  [<ffffffff810b7a05>] ? prepare_to_wait_event+0x95/0x110
[   90.668003]  [<ffffffff810a5358>] sched_clock_cpu+0xb8/0xe0
[   90.668003]  [<ffffffff810a53d5>] local_clock+0x15/0x30
[   90.668003]  [<ffffffff810c0155>] lock_release_holdtime.part.27+0x15/0x1b0
[   90.668003]  [<ffffffff810b7a05>] ? prepare_to_wait_event+0x95/0x110
[   90.668003]  [<ffffffff810c57fe>] lock_release+0x22e/0x2a0
[   90.668003]  [<ffffffff817b9764>] _raw_spin_unlock_irqrestore+0x24/0x80
[   90.668003]  [<ffffffff810b7a05>] prepare_to_wait_event+0x95/0x110
[   90.668003]  [<ffffffff8124c0b1>] read_events+0x1e1/0x230
[   90.668003]  [<ffffffff810b7a80>] ? prepare_to_wait_event+0x110/0x110
[   90.668003]  [<ffffffff810eae00>] ? hrtimer_get_res+0x50/0x50
[   90.668003]  [<ffffffff810eb384>] ? hrtimer_start_range_ns+0x14/0x20
[   90.668003]  [<ffffffff8124c1c0>] ? lookup_ioctx+0xc0/0x150
[   90.668003]  [<ffffffff8124e0d9>] SyS_io_getevents+0x59/0x110
[   90.668003]  [<ffffffff817ba46d>] system_call_fastpath+0x16/0x1b
[   90.668003] Code: 00 e8 5f d7 0b 00 e9 b7 fe ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 5d c3 0f 1f 44 00 00 55 48 89 e5 0f 31 <89> c0 48 c1 e2 20 5d 48 09 c2 48 89 d0 c3 66 66 66 2e 0f 1f 84 
