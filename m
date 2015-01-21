Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbbAUKtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:49:45 -0500
Received: from smtp.ispras.ru ([83.149.199.79]:36191 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbbAUKtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:49:35 -0500
Message-ID: <54BF8439.2000905@ispras.ru>
Date: Wed, 21 Jan 2015 13:49:29 +0300
From: Andrey Tsyvarev <tsyvarev@ispras.ru>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kernel/module.c: Free lock-classes if parse_args failed
References: <1421216708-1975-1-git-send-email-tsyvarev@ispras.ru> <87iog2arfk.fsf@rustcorp.com.au> <54BE082A.20207@ispras.ru> <87d268c3mi.fsf@rustcorp.com.au>
In-Reply-To: <87d268c3mi.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


21.01.2015 4:40, Rusty Russell пишет:
> Andrey Tsyvarev <tsyvarev@ispras.ru> writes:
>> 20.01.2015 9:37, Rusty Russell пишет:
>>> Andrey Tsyvarev <tsyvarev@ispras.ru> writes:
>>>> parse_args call module parameters' .set handlers, which may use locks defined in the module.
>>>> So, these classes should be freed in case parse_args returns error(e.g. due to incorrect parameter passed).
>>> Thanks, this seems right.  Applied.
>>>
>>> But this makes me ask: where is lockdep_free_key_range() called on the
>>> module init code?  It doesn't seem to be at all...
>> As I understand, locks are not allowed to be defined in the module init
>> section. So, no needs to call lockdep_free_key_range() for it.
>> This has a sense: objects from that section are allowed to be used only
>> by module->init() function. But a single function call doesn't require
>> any synchronization wrt itself.
> I don't know that we have any __initdata locks; it would be really
> weird.
>
> But change 'static DEFINE_MUTEX(mutex_param);' to 'static __initdata
> DEFINE_MUTEX(mutex_param);' to test.
Compiler warns about sections mismatch, but the test works.

According to lockdep_free_key_range() code, lock class is cleared not 
only according to
its key(which is equal to lock address in the case of static lock) but 
also according to its name.
Lock class name are assigned from the name of lock itself, which is 
initialized using
.name = #lockname
construction inside a macro.
While "__initdata" force mutex structure to be placed inside .init.data 
section, string for the .name
field is placed in its normal section. That's why lock class for the 
"__initdata" mutex is cleared when
lockdep_free_key_range() is called for "core" module section.

I remember that message about lockdep crash(on unmodified kernel and 
with original test)
was also be concerned with the lock class name:

[  184.903688] BUG: unable to handle kernel paging request at 
ffffffffa00110be
[  184.903697] IP: [<ffffffff81321b48>] strcmp+0x18/0x40
[  184.903705] PGD 1e15067 PUD 1e16063 PMD 3793e067 PTE 0
[  184.903711] Oops: 0000 [#1] SMP
[  184.903715] Modules linked in: test(O+) iptable_nat nf_nat_ipv4 nf_nat
[  184.903724] CPU: 0 PID: 5072 Comm: insmod Tainted: G O   
3.19.0-rc4-newest+ #3
[  184.903727] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
VirtualBox 12/01/2006
[  184.903730] task: ffff8800130222c0 ti: ffff880013fc8000 task.ti: 
ffff880013fc8000
[  184.903732] RIP: 0010:[<ffffffff81321b48>] [<ffffffff81321b48>] 
strcmp+0x18/0x40
[  184.903737] RSP: 0018:ffff880013fcbbc8  EFLAGS: 00010082
[  184.903739] RAX: 0000000000000000 RBX: ffffffff82566530 RCX: 
0000000000000000
[  184.903741] RDX: ffffffffa0015168 RSI: ffffffffa001509d RDI: 
ffffffffa00110bf
[  184.903743] RBP: ffff880013fcbbc8 R08: 0000000000000000 R09: 
0000000000000000
[  184.903745] R10: fec17ffa5a615168 R11: ffffffff825666f0 R12: 
0000000000000000
[  184.903747] R13: ffffffffa001509d R14: ffffffff825666e0 R15: 
000000000000fec0
[  184.903750] FS:  00007f250e13e740(0000) GS:ffff88003fc00000(0000) 
knlGS:0000000000000000
[  184.903753] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  184.903755] CR2: ffffffffa00110be CR3: 0000000024188000 CR4: 
00000000000006f0
[  184.903763] Stack:
[  184.903765]  ffff880013fcbbf8 ffffffff81893958 ffff8800130222c0 
ffffffff825666e0
[  184.903769]  0000000000000000 ffffffffa0015168 ffff880013fcbc78 
ffffffff8108e539
[  184.903773]  0000000000000000 0000000000000000 0000000013d3629d 
ffff880000000000
[  184.903778] Call Trace:
[  184.903786]  [<ffffffff81893958>] count_matching_names+0x61/0x8e
[  184.903793]  [<ffffffff8108e539>] __lock_acquire.isra.30+0x8f9/0xa10
[  184.903799]  [<ffffffff8132ffff>] ? ioread32+0x2f/0x50
[  184.903803]  [<ffffffff8108edba>] lock_acquire+0xaa/0x130
[  184.903808]  [<ffffffffa0015049>] ? minit+0x15/0x28 [test]
[  184.903813]  [<ffffffff8189f236>] mutex_lock_nested+0x46/0x340
[  184.903816]  [<ffffffffa0015049>] ? minit+0x15/0x28 [test]
[  184.903822]  [<ffffffff810002b8>] ? do_one_initcall+0x78/0x1c0
[  184.903826]  [<ffffffffa0015034>] ? param_set+0x34/0x34 [test]
[  184.903830]  [<ffffffffa0015049>] minit+0x15/0x28 [test]
[  184.903835]  [<ffffffff810002c4>] do_one_initcall+0x84/0x1c0
[  184.903840]  [<ffffffff81156fc2>] ? __vunmap+0xc2/0x110
[  184.903845]  [<ffffffff810c76de>] load_module+0x1cfe/0x2280
[  184.903849]  [<ffffffff810c41c0>] ? m_show+0x1a0/0x1a0
[  184.903855]  [<ffffffff810e2f3c>] ? __audit_syscall_entry+0xac/0x100
[  184.903859]  [<ffffffff810c7d96>] SyS_finit_module+0x76/0x80
[  184.903864]  [<ffffffff818a2b69>] system_call_fastpath+0x12/0x17
[  184.903866] Code: c9 88 4a ff 75 ed 5d c3 66 66 2e 0f 1f 84 00 00 00 
00 00 55 48 89 e5 eb 0e 66 2e 0f 1f 84 00 00 00 00 00 84 c0 74 1c 48 83 
c7 01 <0f> b6 47 ff 48 83 c6 01 3a 46 ff 74 eb 19 c0 83 c8 01 5d c3 0f
[  184.903912] RIP  [<ffffffff81321b48>] strcmp+0x18/0x40
[  184.903916]  RSP <ffff880013fcbbc8>
[  184.903918] CR2: ffffffffa00110be



>
> Cheers,
> Rusty.
>

-- 
Best regards,

Andrey Tsyvarev
Linux Verification Center, ISPRAS
web:http://linuxtesting.org

