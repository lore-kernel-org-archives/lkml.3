Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaIONxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:53:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaIONxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:53:23 -0400
Message-ID: <5416EF28.8020900@redhat.com>
Date: Mon, 15 Sep 2014 15:52:40 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Z Lim <zlim.lnx@gmail.com>
CC: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH arm64-next v2] net: bpf: arm64: address randomize and
 write protect JIT code
References: <1410543308-27449-1-git-send-email-dborkman@redhat.com> <CABg9mcv6cSXZLPNH3Dvhr6XatA33VAPwgHyKgQ35f0DSmsObRQ@mail.gmail.com>
In-Reply-To: <CABg9mcv6cSXZLPNH3Dvhr6XatA33VAPwgHyKgQ35f0DSmsObRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2014 06:32 AM, Z Lim wrote:
> On Fri, Sep 12, 2014 at 10:35 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
>> This is the ARM64 variant for 314beb9bcab ("x86: bpf_jit_comp: secure bpf
>> jit against spraying attacks").
>>
>> Thanks to commit 11d91a770f1f ("arm64: Add CONFIG_DEBUG_SET_MODULE_RONX
>> support") which added necessary infrastructure, we can now implement
>> RO marking of eBPF generated JIT image pages and randomize start offset
>> for the JIT code, so that it does not reside directly on a page boundary
>> anymore. Likewise, the holes are filled with illegal instructions.
>>
>> This is basically the ARM64 variant of what we already have in ARM via
>> commit 55309dd3d4cd ("net: bpf: arm: address randomize and write protect
>> JIT code"). Moreover, this commit also presents a merge resolution due to
>> conflicts with commit 60a3b2253c41 ("net: bpf: make eBPF interpreter images
>> read-only") as we don't use kfree() in bpf_jit_free() anymore to release
>> the locked bpf_prog structure, but instead bpf_prog_unlock_free() through
>> a different allocator.
>>
>> JIT tested on aarch64 with BPF test suite.
>>
>> Reference: http://mainisusuallyafunction.blogspot.com/2012/11/attacking-hardened-linux-systems-with.html
>> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
>> Cc: Zi Shen Lim <zlim.lnx@gmail.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Alexei Starovoitov <ast@plumgrid.com>
>> ---
>>   v1 -> v2:
>>    - Use brk insn as suggested by Catalin, thanks a lot for
>>      your feedback! Rest unchanged.
>>   Note:
>>    - This patch depends on net-next being merged to mainline due
>>      to the mentioned merge conflict.
>>
>>   arch/arm64/net/bpf_jit_comp.c | 38 +++++++++++++++++++++++++++++---------
>>   1 file changed, 29 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
>> index 7ae3354..4b71779 100644
>> --- a/arch/arm64/net/bpf_jit_comp.c
>> +++ b/arch/arm64/net/bpf_jit_comp.c
>> @@ -19,7 +19,6 @@
>>   #define pr_fmt(fmt) "bpf_jit: " fmt
>>
>>   #include <linux/filter.h>
>> -#include <linux/moduleloader.h>
>>   #include <linux/printk.h>
>>   #include <linux/skbuff.h>
>>   #include <linux/slab.h>
>> @@ -119,6 +118,15 @@ static inline int bpf2a64_offset(int bpf_to, int bpf_from,
>>          return to - from;
>>   }
>>
>> +static void jit_fill_hole(void *area, unsigned int size)
>> +{
>> +       /* We use brk #0x100 to trigger a fault. */
>> +       u32 *ptr, fill_ins = 0xd4202000;
>
> Missed this on first round of review, I think we also need
> cpu_to_le32(...) here.

Just wondering ... so that would also hold true in case I build/run my
kernel in big-endian (CPU_BIG_ENDIAN)?

>> +       /* We are guaranteed to have aligned memory. */
>> +       for (ptr = area; size >= sizeof(u32); size -= sizeof(u32))
>> +               *ptr++ = fill_ins;
>> +}
>> +
> [...]
>
> Thanks Daniel.
