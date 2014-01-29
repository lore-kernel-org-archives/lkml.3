Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaA2XHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 18:07:15 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:51361 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaA2XHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 18:07:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140129015048.GA14629@konrad-lan.dumpdata.com>
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
	<52E82A40.3040104@intel.com>
	<CAE9FiQVGuN0f5xo9fbfsurmO3E=45A3m0oS75HYPV7BSEwrvsg@mail.gmail.com>
	<20140129015048.GA14629@konrad-lan.dumpdata.com>
Date: Wed, 29 Jan 2014 15:07:11 -0800
Message-ID: <CA+8MBbJjEUJKo2ip8bDzDRVbBT+yhzqZXV0BYP3X52OJ3zA6Pg@mail.gmail.com>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
From: Tony Luck <tony.luck@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Yinghai Lu <yinghai@kernel.org>, xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, david.vrabel@citrix.com,
        Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmph.  ia64 is broken too.  git bisect says:

commit ad6492b80f60a2139fa9bf8fd79b182fe5e3647c
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Mon Jan 27 17:06:49 2014 -0800

    memblock, nobootmem: add memblock_virt_alloc_low()

is to blame.  But this patch doesn't fix it.  Still dies with:

PID hash table entries: 4096 (order: -1, 32768 bytes)
Sorting __ex_table...
kernel BUG at mm/bootmem.c:504!
swapper[0]: bugcheck! 0 [1]
Modules linked in:

CPU: 0 PID: 0 Comm: swapper Not tainted 3.13.0-bisect-09219-g5e345db #10
task: a000000101040000 ti: a000000101040f10 task.ti: a000000101040f10
psr : 00001010084a2018 ifs : 8000000000000797 ip  :
[<a000000100eea530>]    Not tainted (3.13.0-bisect-09219-g5e345db)
ip is at alloc_bootmem_bdata+0x230/0x790
unat: 0000000000000000 pfs : 0000000000000797 rsc : 0000000000000003
rnat: a000000100dff0ee bsps: 0000000000000000 pr  : 96669601598a95a9
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0930ffff00063000 ssd : 0930ffff00063000
b0  : a000000100eea530 b6  : a0000001005f4040 b7  : a0000001005f3e00
f6  : 000000000000000000000 f7  : 1003e0000000000000000
f8  : 1003e0044b82fa09b5a53 f9  : 1003e0000000000001680
f10 : 1003e0000000000000008 f11 : 1003e00000000000002d0
r1  : a0000001017ce170 r2  : a00000010158e0a0 r3  : a0000001015ced80
r8  : 000000000000001f r9  : 0000000000000664 r10 : 0000000000000000
r11 : 0000000000000000 r12 : a00000010104fe20 r13 : a000000101040000
r14 : a00000010158e0a8 r15 : a00000010158e0a8 r16 : 0000000006640332
r17 : 0000000000000000 r18 : 0000000000007fff r19 : 0000000000000000
r20 : a000000101727e98 r21 : 0000000000000058 r22 : a000000101616c98
r23 : a000000101616c00 r24 : a000000101616c00 r25 : 00000000000003f8
r26 : a000000100e901a8 r27 : a000000100f59480 r28 : 0000000000000058
r29 : 0000000000000057 r30 : 00000000000016d0 r31 : 0000000000000030
Unable to handle kernel NULL pointer dereference (address 0000000000000000)
swapper[0]: Oops 11012296146944 [2]

-Tony

On Tue, Jan 28, 2014 at 5:50 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Tue, Jan 28, 2014 at 02:47:57PM -0800, Yinghai Lu wrote:
>> On Tue, Jan 28, 2014 at 2:08 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>> > On 01/28/2014 02:04 PM, Yinghai Lu wrote:
>> >> In original bootmem wrapper for memblock, we have limit checking.
>> >>
>> >> Add it to memblock_virt_alloc, to address arm and x86 booting crash.
>> >>
>> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> >
>> > Do you have a git tree or cumulative set of patches that you'd like us
>> > to all test?  I'm happy to boot it on my system, I just want to make
>> > sure I've got the same set that you're testing.
>>
>> This one should only affect on arm and x86 the 32 bit kernel with more
>> then 4G RAM.
>
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>
> It fixes the issue I saw with Xen and 32-bit dom0 blowing up.
>
>>
>> thanks
>>
>> Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
