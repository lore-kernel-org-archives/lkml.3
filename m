Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaBTLaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:30:21 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:51753 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaBTLaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:30:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHwwmZkFMRvxsxjBAfUbVXU3V+iPFDZO=DwQsFvJ3NQyKA@mail.gmail.com>
References: <1392819290-1044-1-git-send-email-grant.likely@linaro.org> <CAK9yfHwwmZkFMRvxsxjBAfUbVXU3V+iPFDZO=DwQsFvJ3NQyKA@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 20 Feb 2014 11:29:57 +0000
X-Google-Sender-Auth: 8SyFfx344y-TWKwRnajXsLFpNSU
Message-ID: <CACxGe6sg7FpJqAUjkU5DkUpiV_mDbtSV3RETtiQdACUXhRtRrg@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Bugfix for of_match_node ordering
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kevin Hao <haokexin@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 8:39 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Grant,
>
> I observe the following boot failure with today's (next-20140220) linux-next
> tree on Exynos based boards with the default exynos_defconfig.

Ugh, nested locking. that is not good. Kevin's patch looks correct and
I'll merge it in. I'm a little disturbed though that you're the only
one who has reported problems. Looking at what it does I would expect
pretty much every SMP platform for freak out about this, but I've
heard nothing from the powerpc guys.

I'll merge in the fix of course, but I'd like to know what I'm missing.

g.

>
> Uncompressing Linux... done, booting the kernel.
> [    0.000000] Booting Linux on physical CPU 0x900
> [    0.000000] Linux version 3.14.0-rc3-next-20140220 (sachin@linaro)
> (gcc version 4.8.2 20130805 (prerelease) (crosstool-NG linaro-1.
> 13.1-4.8-2013.08 - Linaro GCC 2013.08) ) #1132 SMP PREEMPT Thu Feb 20
> 13:49:27 IST 2014
> [    0.000000] CPU: ARMv7 Processor [412fc091] revision 1 (ARMv7), cr=10c5387d
> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
> instruction cache
> [    0.000000] Machine model: Insignal Origen evaluation board based
> on Exynos4210
> [    0.000000] bootconsole [earlycon0] enabled
> [    0.000000] Memory policy: Data cache writealloc
> [    0.000000] CPU EXYNOS4210 (id 0x43210011)
> [    0.000000] On node 0 totalpages: 258048
> [    0.000000]   Normal zone: 1520 pages used for memmap
> [    0.000000]   Normal zone: 0 pages reserved
> [    0.000000]   Normal zone: 190464 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 528 pages used for memmap
> [    0.000000]   HighMem zone: 67584 pages, LIFO batch:15
> [    0.000000] BUG: spinlock recursion on CPU#0, swapper/0
> [    0.000000]  lock: devtree_lock+0x0/0x10, .magic: dead4ead, .owner:
> swapper/0, .owner_cpu: 0
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted
> 3.14.0-rc3-next-20140220 #1132
> [    0.000000] [<c0013e9c>] (unwind_backtrace) from [<c0011250>]
> (show_stack+0x10/0x14)
> [    0.000000] [<c0011250>] (show_stack) from [<c0386740>]
> (dump_stack+0x7c/0xbc)
> [    0.000000] [<c0386740>] (dump_stack) from [<c005501c>]
> (do_raw_spin_lock+0x188/0x18c)
> [    0.000000] [<c005501c>] (do_raw_spin_lock) from [<c038b614>]
> (_raw_spin_lock_irqsave+0x20/0x28)
> [    0.000000] [<c038b614>] (_raw_spin_lock_irqsave) from [<c02de37c>]
> (of_find_property+0x20/0x4c)
> [    0.000000] [<c02de37c>] (of_find_property) from [<c02df110>]
> (__of_device_is_compatible+0xb4/0x110)
> [    0.000000] [<c02df110>] (__of_device_is_compatible) from
> [<c02df22c>] (of_find_compatible_node+0x4c/0x7c)
> [    0.000000] [<c02df22c>] (of_find_compatible_node) from
> [<c04cedf4>] (exynos_firmware_init+0x18/0x7c)
> [    0.000000] [<c04cedf4>] (exynos_firmware_init) from [<c04caef0>]
> (setup_arch+0x860/0x898)
> [    0.000000] [<c04caef0>] (setup_arch) from [<c04c7820>]
> (start_kernel+0x80/0x3dc)
> [    0.000000] [<c04c7820>] (start_kernel) from [<40008074>] (0x40008074)
> [    0.000000] BUG: spinlock lockup suspected on CPU#0, swapper/0
> [    0.000000]  lock: devtree_lock+0x0/0x10, .magic: dead4ead, .owner:
> swapper/0, .owner_cpu: 0
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted
> 3.14.0-rc3-next-20140220 #1132
> [    0.000000] [<c0013e9c>] (unwind_backtrace) from [<c0011250>]
> (show_stack+0x10/0x14)
> [    0.000000] [<c0011250>] (show_stack) from [<c0386740>]
> (dump_stack+0x7c/0xbc)
> [    0.000000] [<c0386740>] (dump_stack) from [<c0054fac>]
> (do_raw_spin_lock+0x118/0x18c)
> [    0.000000] [<c0054fac>] (do_raw_spin_lock) from [<c038b614>]
> (_raw_spin_lock_irqsave+0x20/0x28)
> [    0.000000] [<c038b614>] (_raw_spin_lock_irqsave) from [<c02de37c>]
> (of_find_property+0x20/0x4c)
> [    0.000000] [<c02de37c>] (of_find_property) from [<c02df110>]
> (__of_device_is_compatible+0xb4/0x110)
> [    0.000000] [<c02df110>] (__of_device_is_compatible) from
> [<c02df22c>] (of_find_compatible_node+0x4c/0x7c)
> [    0.000000] [<c02df22c>] (of_find_compatible_node) from
> [<c04cedf4>] (exynos_firmware_init+0x18/0x7c)
> [    0.000000] [<c04cedf4>] (exynos_firmware_init) from [<c04caef0>]
> (setup_arch+0x860/0x898)
> [    0.000000] [<c04caef0>] (setup_arch) from [<c04c7820>]
> (start_kernel+0x80/0x3dc)
> [    0.000000] [<c04c7820>] (start_kernel) from [<40008074>] (0x40008074)
>
> Regards,
> Sachin
>
>
>
> On 19 February 2014 19:44, Grant Likely <grant.likely@linaro.org> wrote:
>> Hi all,
>>
>> I've taken Kevin's latest rework and done even more rework on it. :-) I
>> didn't quite like how it was looking so I rolled his scoring code
>> directly into __of_device_is_compatible() so that the function always
>> returns a score in a way that is still compatible with the existing
>> users (ie. non-zero == successful match). This eliminates the need for a
>> separate pscore argument and it also let me roll the type and name
>> checks into the same function. I'm a lot happier with it overall and it
>> makes for a slightly smaller number of lines of code changed. Please
>> take a look and give it a spin. This is basically a bug fix so I'll need
>> to push it out to Linus in the near future.
>>
>> Acks and Tested-bys would be particularly appreciated.
>>
>> Thanks,
>> g.
>>
>> Kevin Hao (2):
>>         Revert "of: search the best compatible match first in __of_match_node()"
>>         of: reimplement the matching method for __of_match_node()
>>
>> Grant Likely (2):
>>         of: Move testcase FDT data into drivers/of
>>         of: Add self test for of_match_node()
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
