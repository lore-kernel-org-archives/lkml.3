Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3HCAYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 20:24:24 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:45194 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab3HCAYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 20:24:22 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20130803000731.GS23006@n2100.arm.linux.org.uk>
References: <CAOesGMgWeP-CdmOE-S7XZmJ-+1buP9a1cqavUns2gpgKrrhaxQ@mail.gmail.com>
	<20130803000731.GS23006@n2100.arm.linux.org.uk>
Date: Fri, 2 Aug 2013 17:24:21 -0700
Message-ID: <CAOesGMi3FBz7-tQSxgQMgHiHmPTnO4k57MkhQTQTvtB0Q6WyNw@mail.gmail.com>
Subject: Re: Build breakage due to latest ARM fixes
From: Olof Johansson <olof@lixom.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 5:07 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Aug 02, 2013 at 04:41:11PM -0700, Olof Johansson wrote:
>> Russell,
>>
>> Looks like you sent up some fixes to Linus that broke one of the atmel
>> configs (CONFIG_MMU=n):
>>
>> commit 48be69a026b2c1 ARM: move signal handlers into a vdso-like page
>>
>> seems to have caused it:
>>
>> arch/arm/kernel/signal.c: In function 'setup_return':
>> arch/arm/kernel/signal.c:413:25: error: 'mm_context_t' has no member
>> named 'sigpage'
>>
>> I see it with at91x40_defconfig.
>
> I'll look into that.  Obviously, I never build nommu because it isn't
> part of the build system and the nommu platform I do have - OKI67001 -
> doesn't have mainline kernel support.  (And if it did, it would not be
> DT, so I doubt it's submittable.)

I just noticed a whole bunch of boot/runtime failures too across the board too.

tegra2 seaboard, exynos arndale, ux500 snowball all panicked. Panda,
cubox and sama5 were the only systems that stayed up. Note that I
don't do much with them per boot though, so with more runtime they
might have hit something too.

Some of the oopses below, they're probably not very useful though. Let
me know if I can help collect data in any way.

Maybe it's better to move this feature work to -next and iron out the
kinks there? :(


[   13.193059] ------------[ cut here ]------------
[   13.197669] kernel BUG at /home/olof/work/batch/include/linux/mm.h:414!
[   13.204265] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
[   13.210080] Modules linked in:
[   13.213129] CPU: 0 PID: 490 Comm: killall5 Not tainted
3.11.0-rc3-00288-gabe0308 #53
[   13.220852] task: e90acac0 ti: e9be8000 task.ti: e9be8000
[   13.226246] PC is at special_mapping_fault+0xa4/0xc4
[   13.231196] LR is at __do_fault+0x68/0x48c
[   13.235279] pc : [<c00b8d50>]    lr : [<c00b3280>]    psr: 60000013
[   13.235279] sp : e9be9e00  ip : 000b6f90  fp : 00000000
[   13.246729] r10: 00000000  r9 : e9232db8  r8 : 00000000
[   13.251937] r7 : b6f90000  r6 : e904e540  r5 : 00000008  r4 : c0769b80
[   13.258444] r3 : 00000000  r2 : 000b6f90  r1 : e9be9e28  r0 : e9be9e84
[   13.264954] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   13.272069] Control: 10c5387d  Table: 2923004a  DAC: 00000015
[   13.277798] Process killall5 (pid: 490, stack limit = 0xe9be8238)
[   13.283872] Stack: (0xe9be9e00 to 0xe9bea000)
[   13.288216] 9e00: c0fb1540 00000000 e93d0a50 c00b3280 c07a9780
00000188 e916e000 00000000
[   13.296374] 9e20: e904e540 e916e620 00000008 000b6f90 b6f90000
00000000 000003c0 e93d0a50
[   13.304532] 9e40: 000b6f90 e904e540 e916e640 e93d0a50 00000008
00000000 c0728f54 c00b64f8
[   13.312689] 9e60: 000b6f90 00000008 00000000 c00a1bfc c00a12f8
00000171 e9be9f4c 00000052
[   13.320847] 9e80: c0fafe80 c0769b80 c0fafe80 00000000 c0fafe80
e9230000 000005b7 b6f90000
[   13.329005] 9ea0: e904e540 e93d0a50 00000008 e9232db8 c0728f54
c00b6c8c e9232db8 00000008
[   13.337162] 9ec0: 00000052 e93d0a50 e90acac0 b6f90000 e904e540
e9be9f6c 00000052 c00b6dec
[   13.345320] 9ee0: e9be8000 00000000 c07a9780 c072b984 c0733920
00000000 00000000 00000010
[   13.353477] 9f00: e9be8000 00000001 00000016 00000000 c0723da8
b6f90000 e93d0a50 e904e540
[   13.361634] 9f20: e9be9f6c 00000001 00000001 e904e570 00000001
c00b7d7c 00000052 00000000
[   13.369791] 9f40: 00000000 e9be9f6c e93d0a50 b6f91000 bf000000
b6f90000 e904e540 c00b8248
[   13.377949] 9f60: e9be8000 e9be8000 e904e574 00000001 e9be8000
00000000 e9be8000 e9be8000
[   13.386106] 9f80: 00000098 c000e644 e9be8000 00000000 00000006
c00b853c 00000000 00000001
[   13.394263] 9fa0: 000001d8 c000e4c0 00000000 00000001 00000003
00000016 b6e914c0 00000010
[   13.402420] 9fc0: 00000000 00000001 000001d8 00000098 00013134
00000006 be8eae24 00000006
[   13.410577] 9fe0: b6f1dcf0 be8eac9c 000090d3 b6f1dcfc 80000010
00000003 00003142 00003143
[   13.418736] Code: e8bd8010 e3a00002 e28dd008 e8bd8010 (e7f001f2)
[   13.424812] ---[ end trace d069f2c36c63aa68 ]---


[    2.856972] Unable to handle kernel paging request at virtual
address 000959a0
[    2.862641] pgd = ee944000
[    2.865271] [000959a0] *pgd=6e9c1831, *pte=00000000, *ppte=00000000
[    2.871423] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[    2.876715] Modules linked in:
[    2.879709] CPU: 0 PID: 1206 Comm: startpar Not tainted
3.11.0-rc3-00288-gabe0308 #52
[    2.887393] task: ef223740 ti: ef2a4000 task.ti: ef2a4000
[    2.892698] PC is at mark_page_accessed+0x8/0xfc
[    2.897217] LR is at follow_page_mask+0x188/0x2b0
[    2.901828] pc : [<c0082204>]    lr : [<c0095290>]    psr: 60000013
[    2.901828] sp : ef2a5eb8  ip : 0006f7f5  fp : 04acd59f
[    2.913101] r10: 00000694  r9 : 00000000  r8 : eea48fec
[    2.918226] r7 : 00000000  r6 : 000959a0  r5 : ee925210  r4 : 000959a0
[    2.924632] r3 : ef223740  r2 : 00000000  r1 : b6fa5000  r0 : 000959a0
[    2.931039] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[    2.938041] Control: 10c5387d  Table: 6e94406a  DAC: 00000015
[    2.943679] Process startpar (pid: 1206, stack limit = 0xef2a4238)
[    2.949742] Stack: (0xef2a5eb8 to 0xef2a6000)
[    2.954014] 5ea0:
    00000052 c0095290
[    2.962043] 5ec0: c04bc72c ee946db8 ee946db8 00000052 ee925210
ef223740 b6fa5000 eea48fc0
[    2.970072] 5ee0: ef2a5f6c c04c5378 c04bc72c c0096208 ef223740
c004447c 00100100 c0515580
[    2.978101] 5f00: 00000000 00000010 ef2a4000 00000001 60000013
00000000 eea49000 00040075
[    2.986129] 5f20: ef2a5f6c bf000000 b6fa5000 eea48fc0 00000001
eea48ffc 00000001 c009711c
[    2.994158] 5f40: 00000052 00000000 00000000 ef2a5f6c ee925a50
ee925210 b6fa6000 c0097584
[    3.002186] 5f60: eea48ffc c01af3ac eea49000 00000001 ef2a4000
00000000 ef2a4000 ef2a4000
[    3.010215] 5f80: 00000098 c000e408 ef2a4000 00000000 bea7bf45
c0097870 000161f4 0000ce14
[    3.018244] 5fa0: 0000ce08 c000e260 000161f4 0000ce14 00000003
bea79848 00000000 00000000
[    3.026272] 5fc0: 000161f4 0000ce14 0000ce08 00000098 000161f4
00000000 bea7bf40 bea7bf45
[    3.034301] 5fe0: 00000001 bea79978 0000adfd b6f3441c 80000010
00000003 2004e6a8 f44fe6a6
[    3.042332] Code: eaffffdd c04b1b14 e92d4010 e1a04000 (e5903000)
[    3.048333] ---[ end trace a090a6786a576447 ]---



Unable to handle kernel NULL pointer dereference at virtual address 00000010
pgd = ee868000
[00000010] *pgd=2f25f831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 1 PID: 905 Comm: startpar Not tainted 3.11.0-rc3-00288-gabe0308 #51
task: ef0e0300 ti: ef26c000 task.ti: ef26c000
PC is at __get_page_tail+0x24/0xb4
LR is at special_mapping_fault+0xa4/0xb4
pc : [<c007ce1c>]    lr : [<c0092474>]    psr: a0000013
sp : ef26de28  ip : 000b6fab  fp : ee86adb8
r10: ef229478  r9 : 00000008  r8 : b6fab000
r7 : 00000000  r6 : 00000008  r5 : 00000000  r4 : ee86adb8
r3 : 2e86d831  r2 : 000b6fab  r1 : ef26de58  r0 : ee86adb8
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c5787d  Table: 2e86804a  DAC: 00000015
Process startpar (pid: 905, stack limit = 0xef26c238)
Stack: (0xef26de28 to 0xef26e000)
de20:                   2e86d831 ee86adb8 ef22f380 c0092474 c0d662a0 ef26de58
de40: 00000000 c008d2b4 c0d662a0 ef22f3ac 00000000 ee86d670 00000008 000b6fab
de60: b6fab000 00000000 00000300 00000000 ee86d6ac ef229478 000b6fab ef22f380
de80: 00000008 ee86adb8 c05126b4 c00900c0 000b6fab 00000008 00000000 c053d180
dea0: c0d69d00 ee868000 000005b7 b6fab000 ef22f380 ef229478 00000008 ee86adb8
dec0: c05126b4 c00904c4 ee86adb8 00000008 00000052 ef229478 ef0e0300 b6fab000
dee0: ef22f380 ef26df6c c0567780 c0090604 c053d861 00000000 c0514b44 c051d278
df00: 00000000 00000010 ef26c000 00000001 c007d904 00000000 c0d7e580 00040075
df20: ef26df6c bf000000 b6fab000 ef22f380 00000001 ef22f3b0 00000001 c0091510
df40: 00000052 00000000 00000000 ef26df6c ef229528 ef229478 b6fac000 c0091978
df60: ef26c000 ef26c000 ef22f3b4 00000001 ef26c000 00000000 ef26c000 ef26c000
df80: 00000098 c000e488 ef26c000 00000000 be89df45 c0091c64 000161f4 0000ce14
dfa0: 0000ce08 c000e2e0 000161f4 0000ce14 00000003 be89b848 00000000 00000000
dfc0: 000161f4 0000ce14 0000ce08 00000098 000161f4 00000000 be89df40 be89df45
dfe0: 00000001 be89b978 0000adfd b6f3a41c 80000010 00000003 00000000 00000000
Code: e8bd8038 e590501c e1500005 0afffffa (e5952010)
---[ end trace d3081553bdf3d87f ]---



-Olof
