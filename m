Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031625Ab3HIXXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:23:03 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:36600 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031560Ab3HIXXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <520578D0.7020607@intel.com>
References: <520578D0.7020607@intel.com>
Date: Fri, 9 Aug 2013 16:23:00 -0700
X-Google-Sender-Auth: zQdiQ1ktuzfXjk4YjIYrKe5L_30
Message-ID: <CAE9FiQUuPmZfhsHvmsS+_O_VOWMA_OBAexGyRF3eZR1_D3EehA@mail.gmail.com>
Subject: Re: x86: early boot crash: "alloc_low_page: ran out of memory" (bisected)
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 9, 2013 at 4:18 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> I'm getting a 100% reproducible panic early in boot:
>
>> [    0.000000] Kernel panic - not syncing: alloc_low_page: ran out of memory
>
> I'm not sure why I didn't run in to this until now.  I think there are a
> couple of config options that need to get set just right to trigger it,
> but CONFIG_DEBUG_PAGEALLOC seems to be the main one.  Full config is here:
>
>         http://sr71.net/~dave/intel/foo/config-bigbox-crash-20130809.txt
>
> I bisected it back to this commit (which I seem to remember causing some
> other probems):
>
>> commit 8170e6bed465b4b0c7687f93e9948aca4358a33b
>> Author: H. Peter Anvin <hpa@zytor.com>
>> Date:   Thu Jan 24 12:19:52 2013 -0800
>>
>>     x86, 64bit: Use a #PF handler to materialize early mappings on demand
>
> I need somewhere between 500G and 600G of memory to trigger it, but it
> can be triggered using qemu with much less _actual_ RAM than that.  From
> looking at the dmesg diffs, I suspect that the delta in memory use
> between using 1G and 4k ptes for the identity mapping (DEBUG_PAGEALLOC
> forces 4k pages) is the proximate trigger.
>
> I also suspect that alloc_low_pages() is buggy in the way it manipulates
> min/max_pfn_mapped.  I'm quite baffled how 'max_pfn_mapped' is supposed
> to get set up correctly.  Current code says:
>
>         max_pfn_mapped = 0; /* will get exact value next */
>
> but I certainly don't see it getting set later on in that function, or
> _ever_ as adding some printk()'s shows:
>
>> +[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
>> +[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
>> +[    0.000000] alloc_low_pages(1) min_pfn_mapped: 0 max_pfn_mapped: 0
>> +[    0.000000] BRK [0x02086000, 0x02086fff] PGTABLE
>> +[    0.000000] alloc_low_pages(1) min_pfn_mapped: 0 max_pfn_mapped: 0
>> +[    0.000000] BRK [0x02087000, 0x02087fff] PGTABLE
>> +[    0.000000] alloc_low_pages(1) min_pfn_mapped: 0 max_pfn_mapped: 0
>> +[    0.000000] BRK [0x02088000, 0x02088fff] PGTABLE
>> +[    0.000000] init_memory_mapping: [mem 0xf07fe00000-0xf07fffffff]
>> +[    0.000000]  [mem 0xf07fe00000-0xf07fffffff] page 4k
>> +[    0.000000] alloc_low_pages(1) min_pfn_mapped: 252182528 max_pfn_mapped: 0
>> +[    0.000000] BRK [0x02089000, 0x02089fff] PGTABLE
>> +[    0.000000] alloc_low_pages(1) min_pfn_mapped: 252182528 max_pfn_mapped: 0
>> +[    0.000000] BRK [0x0208a000, 0x0208afff] PGTABLE
>> +[    0.000000] alloc_low_pages(1) min_pfn_mapped: 252182528 max_pfn_mapped: 0
>> +[    0.000000] Kernel panic - not syncing: alloc_low_page: ran out of memory
>
> I'll take a closer look at it next week, but figured I'd report it first.
>
> Full dmesg:
>
>> early console in setup code
>> [    0.000000] Initializing cgroup subsys cpuset
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Linux version 3.8.0-rc5-00059-g8170e6b

so how about v3.10?

We should have some fixes in 3.10 already.

Thanks

Yinghai
