Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3BRSmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:42:10 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14086 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3BRSmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:42:08 -0500
X-IronPort-AV: E=Sophos;i="4.84,689,1355126400"; 
   d="scan'208";a="25685539"
Message-ID: <512275FF.9050508@codeaurora.org>
Date: Mon, 18 Feb 2013 10:42:07 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [-rc7 regression] Buggy commit: "mm: use aligned zone start for
 pfn_to_bitidx calculation"
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com> <20130213111007.GA11367@gmail.com> <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com> <alpine.LFD.2.02.1302140012460.22263@ionos> <20130214144510.GC25282@gmail.com> <20130214145424.GA26071@gmail.com> <20130214150810.GA26095@gmail.com> <CAE9FiQXc=7+TMwbfd20YiHNfOHX_kUOzYcVm8-uaP2R_C_1RRg@mail.gmail.com> <20130215114425.GD26955@gmail.com> <CA+55aFzTR5nBLXHe4MKtN6E7xrs3=xsbMd1aprr8Ax4mu96onw@mail.gmail.com> <20130218142440.GA29814@suse.de>
In-Reply-To: <20130218142440.GA29814@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/2013 6:46 AM, Mel Gorman wrote:
> On Sat, Feb 16, 2013 at 10:26:30AM -0800, Linus Torvalds wrote:
>> On Fri, Feb 15, 2013 at 3:44 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>>>
>>>> c060f943d092 may be related as you config does not have
>>>> CONFIG_SPARSEMEM defined.
>>>
>>> Right, that's the commit causing the x86 regression:
>>>
>>>   c060f943d0929f3e429c5d9522290584f6281d6e is the first bad commit
>>>   commit c060f943d0929f3e429c5d9522290584f6281d6e
>>>   Date:   Fri Jan 11 14:31:51 2013 -0800
>>>
>>>       mm: use aligned zone start for pfn_to_bitidx calculation
>>
>> Ok, looking more at this, I don't really want to revert it, and I have
>> an idea of what is wrong.
>>
>> When we allocate the zone use bitmap, we do not take the
>> zone_start_pfn into account. So I *think* that what happens is that
>> "pfn_to_bitidx()" simply overruns the allocation for unaligned zonesm
>> and the spinlock just happens to be right after (or the overrun causes
>> some other memory corruption that then indirectly causes the spinlock
>> corruption).
>>
>
> More likely the latter. I'd expect the usemap to be adjacent to the
> zone->wait_table because of when they are allocated by the bootmem
> allocator. This would break wait_on_page_[locked|writeback] at the very
> least. If page_waitqueue() returned a corrupt pointer from the wait table
> then it would lead to further corruption elsewhere each time wait_on_page_foo
> was called.
>
>> So I'm wondering if the fix is simply something like the attached
>> patch. It takes the zone_start_pfn into account when allocating the
>> zone bitmap.
>>
>> Laura? Mel?
>>
>
> Looks correct to me and should cc stable@vger.kernel.org
>
> Acked-by: Mel Gorman <mgorman@suse.de>
>

I had convinced myself when I sent the patch that everything would just 
shift down and there wouldn't need to be an array size increase. Looks 
like my math was bogus and I'll double check it next time. The updated 
version looks okay to me and I'll pull in the patch for more testing on 
the setup that originally found the problem this week.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
