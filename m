Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935224Ab3DPAnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 20:43:16 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:32911 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934813Ab3DPAnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 20:43:11 -0400
MIME-Version: 1.0
In-Reply-To: <516C9454.4060009@gmail.com>
References: <1365563297-12480-1-git-send-email-robherring2@gmail.com>
	<CAMbhsRSvQPbzJ7Nt=OSSYE_A1e+eaUjO7XY+qRppJ5_gfWmW4A@mail.gmail.com>
	<51656992.60203@gmail.com>
	<CAMbhsRS1hnBRoomoiNijrXZB-938d2RSs1cu9EdSfmXD3xpSQg@mail.gmail.com>
	<516C9454.4060009@gmail.com>
Date: Mon, 15 Apr 2013 17:43:09 -0700
X-Google-Sender-Auth: bMDEI8wzUQrnbkqw9XYEA7Y6fPk
Message-ID: <CAMbhsRRT7tOBHppvjJEW5wRtVaUhwxr8=YQY=Sy0VAFeBg1JmQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] pstore-ram: use write-combine mappings
From: Colin Cross <ccross@android.com>
To: Rob Herring <robherring2@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 4:59 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 04/15/2013 05:21 PM, Colin Cross wrote:
>> On Wed, Apr 10, 2013 at 6:30 AM, Rob Herring <robherring2@gmail.com> wrote:
>>> On 04/09/2013 10:53 PM, Colin Cross wrote:
>>>> On Tue, Apr 9, 2013 at 8:08 PM, Rob Herring <robherring2@gmail.com> wrote:
>>>>> From: Rob Herring <rob.herring@calxeda.com>
>>>>>
>>>>> Atomic operations are undefined behavior on ARM for device or strongly
>>>>> ordered memory types. So use write-combine variants for mappings. This
>>>>> corresponds to normal, non-cacheable memory on ARM. For many other
>>>>> architectures, this change should not change the mapping type.
>>>>
>>>> This is going to make ramconsole less reliable.  A debugging printk
>>>> followed by a __raw_writel that causes an immediate hard crash is
>>>> likely to lose the last updates, including the most useful message, in
>>>> the write buffers.
>>>
>>> It would have to be a write that hangs the bus. In my experience with
>>> AXI, the bus doesn't actually hang until you hit max outstanding
>>> transactions.
>>
>> I've seen many cases where a single write to device memory in an
>> unclocked slave will completely and instantly hang all cpus, and the
>> next write will never happen.
>>
>>> I think exclusive stores will limit the buffering, but that is probably
>>> not architecturally guaranteed.
>>>
>>> I could put a wb() in at the end of persistent_ram_write.
>>>
>>>> Also, isn't this patch unnecessary after patch 3 in this set?
>>>
>>> It is still needed in the main memory case to be architecturally correct
>>> to avoid multiple mappings of different memory types and exclusive
>>> accesses to device memory. At least on an A9, it doesn't really seem to
>>> matter. I could remove this for the ioremap case.
>>
>> According to my reading of the latest ARM ARM (Issue C, section
>> A3.5.7), and Catalin's excellent explanation
>> (http://lists.linaro.org/pipermail/linaro-dev/2012-February/010239.html),
>> it is no longer considered unpredictable to have both cached and
>> non-cached mappings to the same memory, as long as you use proper
>> cache maintenance between accessing the two mappings.
>>
>> In pstore_ram the cached mapping will never be accessed (and we don't
>> care about speculative accesses), so no cache maintenance is
>> necessary.  I don't see any need for this patch, and I see plenty of
>> possible problems.
>
> Exclusive accesses still have further restrictions. From section 3.4.5:
>
> • It is IMPLEMENTATION DEFINED whether LDREX and STREX operations can be
> performed to a memory region
>    with the Device or Strongly-ordered memory attribute. Unless the
> implementation documentation explicitly
>   states that LDREX and STREX operations to a memory region with the
> Device or Strongly-ordered attribute are
>  permitted, the effect of such operations is UNPREDICTABLE.
>
>
> Given that it is implementation defined, I don't see how Linux can rely
> on that behavior.

I see, the problem is that while noncached and writecombined appear to
be similar mappings, noncached is mapped in PRRR to strongly-ordered,
while writecombined is mapped to unbufferable normal memory.

I think adding a wmb() to persistent_ram_write is going to be
expensive on cpus with outer caches like the L2X0, where wmb() will
result in a spinlock.  Is there a real SoC where this doesn't work?
