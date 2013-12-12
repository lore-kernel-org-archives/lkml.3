Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab3LLJQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:16:27 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:57157 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3LLJQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:16:22 -0500
MIME-Version: 1.0
In-Reply-To: <20131211143450.329edd5199fd9a4d56abb6bc@linux-foundation.org>
References: <1386758601-8520-1-git-send-email-geert@linux-m68k.org>
	<20131211143450.329edd5199fd9a4d56abb6bc@linux-foundation.org>
Date: Thu, 12 Dec 2013 10:16:21 +0100
X-Google-Sender-Auth: W80JvJsfGeYblqPrDJhTbKR_lAQ
Message-ID: <CAMuHMdUq3wQMxcic6NUy+su6bdgDLJAaODAOF5OcryJMDmj_fg@mail.gmail.com>
Subject: Re: [PATCH] futex: Switch to USER_DS for futex test
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Jonas Bonn <jonas@southpole.se>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 11:34 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 11 Dec 2013 11:43:21 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
>> Since commit e4f2dfbb5e92be4e46c0625f4f8eb101110f756f ("m68k: implement
>> futex.h to support userspace robust futexes and PI mutexes"), the kernel
>> crashes during boot up on MC68030:
>>
>> Data read fault at 0x00000000 in Super Data (pc=0x3afec)
>> BAD KERNEL BUSERR
>> Oops: 00000000
>> Modules linked in:
>> PC: [<0003afec>] cmpxchg_futex_value_locked+0x14/0x4a
>> SR: 2004  SP: 0082fed4  a2: 0082c000
>> d0: 00000000    d1: 00000001    d2: 00000018    d3: 00000000
>> d4: 00000061    d5: 00001000    a0: 00000000    a1: 0082e000
>> Process swapper (pid: 1, task=0082c000)
>> Frame format=B ssw=074d isc=4a80 isb=661c daddr=00000000 dobuf=00000001
>> baddr=0003aff2 dibuf=00000000 ver=f
>> Stack from 0082ff5c:
>>         002b8cb8 0082ff70 00000000 00000000 00000000 00000000 00000000 000020ac
>>         00000018 00000007 00000061 00001000 00000000 00000000 002cab50 00002008
>>         002b3a56 002b8ca4 0082c3f0 00000000 0082c53c 001e316a 00000000 00000000
>>         001e3172 001e316a 000025d4 00000000 00000000 00000000 00000000 00000000
>>         00000000 00000000 00000000 00000000 00000000 00000000 00000000 20000000
>>         00000000
>> Call Trace: [<002b8cb8>] futex_init+0x14/0x54
>>  [<000020ac>] do_one_initcall+0xa4/0x144
>>  [<00001000>] kernel_pg_dir+0x0/0x1000
>>  [<00002008>] do_one_initcall+0x0/0x144
>>  [<002b3a56>] kernel_init_freeable+0xca/0x152
>>  [<002b8ca4>] futex_init+0x0/0x54
>>  [<001e316a>] kernel_init+0x0/0xc8
>>  [<001e3172>] kernel_init+0x8/0xc8
>>  [<001e316a>] kernel_init+0x0/0xc8
>>  [<000025d4>] ret_from_kernel_thread+0xc/0x14
>>
>> This happens because the futex test in futex_init() lacks a switch to the
>> USER_DS address space, while cmpxchg_futex_value_locked() and
>> futex_atomic_cmpxchg_inatomic() operate on userspace pointers (albeit NULL
>> for this particular test).
>>
>> Fix this by switching to USER_DS before running the test, and restoring the
>> old address space afterwards.
>>
>> ...
>>
>>  static int __init futex_init(void)
>>  {
>> +     mm_segment_t fs;
>>       u32 curval;
>>       int i;
>>
>> @@ -2745,8 +2747,11 @@ static int __init futex_init(void)
>>        * implementation, the non-functional ones will return
>>        * -ENOSYS.
>>        */
>> +     fs = get_fs();
>> +     set_fs(USER_DS);
>>       if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
>>               futex_cmpxchg_enabled = 1;
>> +     set_fs(fs);
>
> hm.  Are we sure that a reference to NULL will continue to fault on all
> architectures when switched to USER_DS?

Good question! As you queued it in -mm, we'll see in -next.

FWIW, I've just tested it on:
  - ARM (ARMv7, cortex-a15): OK
  - MIPS (TX4927): OK
  - OpenRISC: -ENOSYS (expected, as asm-generic/futex.h doesn't implement
    futex_atomic_cmpxchg_inatomic() yet)

Speaking about asm-generic: arch/m68k/include/asm/futex.h doesn't contain
any m68k-specific code, so it's a candidate to replace
include/asm-generic/futex.h. Actually I just tried that, and the above passed
for OpenRISC.
Unfortunately I don't have networking (yet) on my de0-nano FPGA board,
so I'm not in a good position to run a full futex test suite on OpenRISC.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
