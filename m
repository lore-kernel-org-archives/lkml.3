Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaIYVK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:10:28 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:52861 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751577AbaIYVK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:10:27 -0400
Message-ID: <542484BF.7080908@hurleysoftware.com>
Date: Thu, 25 Sep 2014 17:10:23 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: Mel Gorman <mgorman@suse.de>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Hugh Dickens <hughd@google.com>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: page allocator bug in 3.16?
References: <54246506.50401@hurleysoftware.com> <CADnq5_OyRMNsc5L1a-BYbmKe94t+pun+nEh3UvFKLmpb2=1ukg@mail.gmail.com>
In-Reply-To: <CADnq5_OyRMNsc5L1a-BYbmKe94t+pun+nEh3UvFKLmpb2=1ukg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 04:33 PM, Alex Deucher wrote:
> On Thu, Sep 25, 2014 at 2:55 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>> After several days uptime with a 3.16 kernel (generally running
>> Thunderbird, emacs, kernel builds, several Chrome tabs on multiple
>> desktop workspaces) I've been seeing some really extreme slowdowns.
>>
>> Mostly the slowdowns are associated with gpu-related tasks, like
>> opening new emacs windows, switching workspaces, laughing at internet
>> gifs, etc. Because this x86_64 desktop is nouveau-based, I didn't pursue
>> it right away -- 3.15 is the first time suspend has worked reliably.
>>
>> This week I started looking into what the slowdown was and discovered
>> it's happening during dma allocation through swiotlb (the cpus can do
>> intel iommu but I don't use it because it's not the default for most users).
>>
>> I'm still working on a bisection but each step takes 8+ hours to
>> validate and even then I'm no longer sure I still have the 'bad'
>> commit in the bisection. [edit: yup, I started over]
>>
>> I just discovered a smattering of these in my logs and only on 3.16-rc+ kernels:
>> Sep 25 07:57:59 thor kernel: [28786.001300] alloc_contig_range test_pages_isolated(2bf560, 2bf562) failed
>>
>> This dual-Xeon box has 10GB and sysrq Show Memory isn't showing heavy
>> fragmentation [1].
>>
>> Besides Mel's page allocator changes in 3.16, another suspect commit is:
>>
>> commit b13b1d2d8692b437203de7a404c6b809d2cc4d99
>> Author: Shaohua Li <shli@kernel.org>
>> Date:   Tue Apr 8 15:58:09 2014 +0800
>>
>>     x86/mm: In the PTE swapout page reclaim case clear the accessed bit instead of flushing the TLB
>>
>> Specifically, this statement:
>>
>>     It could cause incorrect page aging and the (mistaken) reclaim of
>>     hot pages, but the chance of that should be relatively low.
>>
>> I'm wondering if this could cause worse-case behavior with TTM? I'm
>> testing a revert of this on mainline 3.16-final now, with no results yet.
>>
>> Thoughts?
> 
> You may also be seeing this:
> https://lkml.org/lkml/2014/8/8/445

Thanks Alex. That is indeed the problem.

Still reading the email thread to find out where the patches
are that fix this. Although it doesn't make much sense to me
that nouveau sets up a 1GB GART and then uses TTM which is
trying to shove all the DMA through a 16MB CMA window
(which turns out to be the base Ubuntu config).

Regards,
Peter Hurley


