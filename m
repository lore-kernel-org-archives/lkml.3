Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbaLKArA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:47:00 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:60480 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621AbaLKAq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:46:58 -0500
MIME-Version: 1.0
X-Originating-IP: [50.161.55.123]
In-Reply-To: <CALCETrXZpQyKbVkBMwqFq2wH908-V+WCuvtaTc1O9VNZFHrBUQ@mail.gmail.com>
References: <CAMVG2su302Nvtp+fnaOjtLadJFtpPmVXiN5YfQ0JpT920YohuA@mail.gmail.com>
	<CALCETrXZpQyKbVkBMwqFq2wH908-V+WCuvtaTc1O9VNZFHrBUQ@mail.gmail.com>
Date: Wed, 10 Dec 2014 16:46:58 -0800
Message-ID: <CAMVG2svoTbm3k3W5POpLsJnpXBPpZRYVr+wmAQrWVGVtiQ=LRA@mail.gmail.com>
Subject: Re: [PATCH, 3.18] sleeping function called from invalid context
From: Daniel J Blueman <daniel@quora.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Rik van Riel <riel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gah. I had some non-temporal copy changes in the wrong tree. I'll
check with a definitely clean tree and follow up if it still occurs.

On 10 December 2014 at 16:37, Andy Lutomirski <luto@amacapital.net> wrote:
> Adding Rik, who is probably the most recent person to have looked at
> the disaster fondly known as "FPU".
>
> On Wed, Dec 10, 2014 at 4:25 PM, Daniel J Blueman <daniel@quora.org> wrote:
>> With 3.18, I was seeing a significant number of allocation warnings
>> from load_elf_binary call paths [1].
>>
>> Allocating FPU state atomically [2] does prevent potentially sleeping
>> while atomic, but probably isn't the correct fix. Anyone familiar with
>> this area?
>>
>> -- [1]
>>
>> BUG: sleeping function called from invalid context at mm/slub.c:1240
>> in_atomic(): 1, irqs_disabled(): 0, pid: 29016, name: dmesg
>> INFO: lockdep is turned off.
>> Preemption disabled at:[<ffffffff8114625f>] handle_mm_fault+0x5ff/0x8a0
>>
>> CPU: 122 PID: 29016 Comm: dmesg Tainted: G        W      3.18.0-test #6
>> Hardware name: Supermicro AS -1042G-LTF/H8QGL, BIOS DS3.5a     11/13/2014
>>  ffffffff8203b81b ffff886fdf62f888 ffffffff81b942e8 0000000000000007
>>  0000000000000000 ffff886fdf62f8b8 ffffffff8109ac4c 0000000000000000
>>  0000000000000010 ffff8807df84bc00 00000000000000d0 ffff886fdf62f908
>> Call Trace:
>>  [<ffffffff81b942e8>] dump_stack+0x4f/0x7c
>>  [<ffffffff8109ac4c>] __might_sleep+0x164/0x250
>>  [<ffffffff8116372b>] kmem_cache_alloc+0xeb/0x138
>>  [<ffffffff8100e0e1>] init_fpu+0x71/0xb0
>>  [<ffffffff81003966>] math_state_restore+0xce/0x208
>>  [<ffffffff8100437b>] do_device_not_available+0x2b/0x60
>>  [<ffffffff81ba70f5>] device_not_available+0x15/0x20
>>  [<ffffffff81487102>] ? copy_page+0x12/0x33
>
> wtf?  I don't see any fpu state being accessed in copy_page.
>
> Can you disassemble "[<ffffffff81487102>] ? copy_page+0x12/0x33"?
>
> --Andy
>
>>  [<ffffffff8109edb9>] ? get_parent_ip+0x11/0x58
>>  [<ffffffff8109ee55>] ? preempt_count_add+0x55/0xb0
>>  [<ffffffff811437a1>] ? do_cow_fault+0xe9/0x258
>>  [<ffffffff8114625f>] handle_mm_fault+0x5ff/0x8a0
>>  [<ffffffff81032218>] ? __do_page_fault+0xc8/0x498
>>  [<ffffffff811481b9>] ? vma_gap_callbacks_rotate+0x19/0x20
>>  [<ffffffff8103227d>] __do_page_fault+0x12d/0x498
>>  [<ffffffff810b682e>] ? up_write+0x1e/0x48
>>  [<ffffffff81148d18>] ? vma_link+0x80/0xc0
>>  [<ffffffff81149cb2>] ? vma_set_page_prot+0x3a/0x60
>>  [<ffffffff8114ae6e>] ? mmap_region+0x1be/0x5e0
>>  [<ffffffff8103262e>] do_page_fault+0x1e/0x70
>>  [<ffffffff81ba737f>] page_fault+0x1f/0x30
>>  [<ffffffff81487f3e>] ? __clear_user+0x2e/0x50
>>  [<ffffffff81487f22>] ? __clear_user+0x12/0x50
>>  [<ffffffff81487f8a>] clear_user+0x2a/0x30
>>  [<ffffffff811ca1e1>] padzero+0x21/0x30
>>  [<ffffffff811cc41f>] load_elf_binary+0x8cf/0xdd0
>>  [<ffffffff8117d18f>] search_binary_handler+0x7f/0x1f8
>>  [<ffffffff8117ec06>] do_execve_common.isra.34+0x616/0x790
>>  [<ffffffff8117eb62>] ? do_execve_common.isra.34+0x572/0x790
>>  [<ffffffff8117ed93>] do_execve+0x13/0x18
>>  [<ffffffff8117f070>] SyS_execve+0x20/0x30
>>  [<ffffffff81ba6159>] stub_execve+0x69/0xa0
>>
>> -- [2]
>>
>> diff --git a/arch/x86/include/asm/fpu-internal.h
>> b/arch/x86/include/asm/fpu-internal.h
>> index e97622f..57029ad 100644
>> --- a/arch/x86/include/asm/fpu-internal.h
>> +++ b/arch/x86/include/asm/fpu-internal.h
>> @@ -574,7 +574,7 @@ static inline int fpu_alloc(struct fpu *fpu)
>>  {
>>         if (fpu_allocated(fpu))
>>                 return 0;
>> -       fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
>> +       fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_ATOMIC);
>>         if (!fpu->state)
>>                 return -ENOMEM;
>>         WARN_ON((unsigned long)fpu->state & 15);
>> --
>> Daniel J Blueman
>
>
>
> --
> Andy Lutomirski
> AMA Capital Management, LLC



-- 
Daniel J Blueman
