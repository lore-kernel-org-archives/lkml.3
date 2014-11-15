Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965784AbaKODGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 22:06:17 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:38708 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965580AbaKODGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 22:06:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
References: <20141114204517.GA24402@www.outflux.net>
	<CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
Date: Fri, 14 Nov 2014 19:06:15 -0800
X-Google-Sender-Auth: kj8cwYQNTJGFk91poIfv42jtW_M
Message-ID: <CAGXu5jKVbEDCyu7p0_9CHKm81j+DCqr-tToYq_KAPBieNkkwmw@mail.gmail.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
From: Kees Cook <keescook@chromium.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wang Nan <wangnan0@huawei.com>, David Vrabel <david.vrabel@citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 5:29 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Nov 14, 2014 at 12:45 PM, Kees Cook <keescook@chromium.org> wrote:
>> When setting up permissions on kernel memory at boot, the end of the
>> PMD that was split from bss remained executable. It should be NX like
>> the rest. This performs a PMD alignment instead of a PAGE alignment to
>> get the correct span of memory, and should be freed.
>>
>> Before:
>> ---[ High Kernel Mapping ]---
>> ...
>> 0xffffffff8202d000-0xffffffff82200000  1868K     RW       GLB NX pte
>> 0xffffffff82200000-0xffffffff82c00000    10M     RW   PSE GLB NX pmd
>> 0xffffffff82c00000-0xffffffff82df5000  2004K     RW       GLB NX pte
>> 0xffffffff82df5000-0xffffffff82e00000    44K     RW       GLB x  pte
>> 0xffffffff82e00000-0xffffffffc0000000   978M                     pmd
>>
>> After:
>> ---[ High Kernel Mapping ]---
>> ...
>> 0xffffffff8202d000-0xffffffff82200000  1868K     RW       GLB NX pte
>> 0xffffffff82200000-0xffffffff82c00000    10M     RW   PSE GLB NX pmd
>> 0xffffffff82c00000-0xffffffff82df5000  2004K     RW       GLB NX pte
>> 0xffffffff82df5000-0xffffffff82e00000    44K     RW           NX pte
>> 0xffffffff82e00000-0xffffffffc0000000   978M                     pmd
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> v2:
>>  - added call to free_init_pages(), as suggested by tglx
>> ---
>>  arch/x86/mm/init_64.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index 4cb8763868fc..0d498c922668 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -1124,6 +1124,7 @@ void mark_rodata_ro(void)
>>         unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
>>         unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
>>         unsigned long all_end = PFN_ALIGN(&_end);
>> +       unsigned long pmd_end = roundup(all_end, PMD_SIZE);
>>
>>         printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
>>                (end - start) >> 10);
>> @@ -1135,7 +1136,7 @@ void mark_rodata_ro(void)
>>          * The rodata/data/bss/brk section (but not the kernel text!)
>>          * should also be not-executable.
>>          */
>> -       set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
>> +       set_memory_nx(rodata_start, (pmd_end - rodata_start) >> PAGE_SHIFT);
>>
>>         rodata_test();
>>
>> @@ -1147,6 +1148,7 @@ void mark_rodata_ro(void)
>>         set_memory_ro(start, (end-start) >> PAGE_SHIFT);
>>  #endif
>>
>> +       free_init_pages("unused kernel", all_end, pmd_end);
>>         free_init_pages("unused kernel",
>>                         (unsigned long) __va(__pa_symbol(text_end)),
>>                         (unsigned long) __va(__pa_symbol(rodata_start)));
>
> something is wrong:
>
> [    7.842479] Freeing unused kernel memory: 3844K (ffffffff82e52000 -
> ffffffff83213000)
> [    7.843305] Write protecting the kernel read-only data: 28672k
> [    7.844433] BUG: Bad page state in process swapper/0  pfn:043c0
> [    7.845093] page:ffffea000010f000 count:0 mapcount:-127 mapping:
>       (null) index:0x2
> [    7.846388] flags: 0x10000000000000()
> [    7.846871] page dumped because: nonzero mapcount
> [    7.847343] Modules linked in:
> [    7.847719] CPU: 2 PID: 1 Comm: swapper/0 Not tainted
> 3.18.0-rc4-yh-01896-g40204c8-dirty #23
> [    7.848809] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
> 04/01/2014
> [    7.850014]  ffffffff828300ca ffff880078babd68 ffffffff81ff47d0
> 0000000000000001
> [    7.850857]  ffffea000010f000 ffff880078babd98 ffffffff8118c2bd
> 00000000001d4cc0
> [    7.851791]  ffffea000010f000 ffffea000010f000 0000000000000000
> ffff880078babdf8
> [    7.852700] Call Trace:
> [    7.852991]  [<ffffffff81ff47d0>] dump_stack+0x45/0x57
> [    7.853494]  [<ffffffff8118c2bd>] bad_page+0xfd/0x130
> [    7.854130]  [<ffffffff8118c42c>] free_pages_prepare+0x13c/0x1c0
> [    7.854808]  [<ffffffff8118c64d>] ? adjust_managed_page_count+0x5d/0x70
> [    7.855575]  [<ffffffff8118f285>] free_hot_cold_page+0x35/0x180
> [    7.856326]  [<ffffffff8118f3e3>] __free_pages+0x13/0x40
> [    7.856854]  [<ffffffff8118f4dd>] free_reserved_area+0xcd/0x140
> [    7.857442]  [<ffffffff81091778>] free_init_pages+0x98/0xb0
> [    7.858001]  [<ffffffff81092085>] mark_rodata_ro+0xb5/0x120
> [    7.858622]  [<ffffffff81fe3240>] ? rest_init+0xc0/0xc0
> [    7.859174]  [<ffffffff81fe325d>] kernel_init+0x1d/0x100
> [    7.859724]  [<ffffffff820066ec>] ret_from_fork+0x7c/0xb0
> [    7.860279]  [<ffffffff81fe3240>] ? rest_init+0xc0/0xc0
> [    7.860836] Disabling lock debugging due to kernel taint
> [    7.861432] Freeing unused kernel memory: 376K (ffffffff843a2000 -
> ffffffff84400000)
> [    7.866118] Freeing unused kernel memory: 1980K (ffff880002011000 -
> ffff880002200000)
> [    7.870525] Freeing unused kernel memory: 1932K (ffff880002a1d000 -
> ffff880002c00000)

Also, what tree is this? "Freeing %s" went away in
c88442ec45f30d587b38b935a14acde4e217a926 (and should probably be
re-added, which is what I assume has happened.)

>
> [    0.000000]   .text: [0x01000000-0x0200d548]
> [    0.000000] .rodata: [0x02200000-0x02a1cfff]
> [    0.000000]   .data: [0x02c00000-0x02e50e7f]
> [    0.000000]   .init: [0x02e52000-0x03212fff]
> [    0.000000]    .bss: [0x03221000-0x0437bfff]
> [    0.000000]    .brk: [0x0437c000-0x043a1fff]

And which CONFIG turns on this reporting?

-Kees

-- 
Kees Cook
Chrome OS Security
