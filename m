Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbaIZMkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:40:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbaIZMkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:40:35 -0400
Message-ID: <54255EA5.3030207@redhat.com>
Date: Fri, 26 Sep 2014 08:40:05 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Rob Clark <robdclark@gmail.com>, Thomas Hellstrom <thellstrom@vmware.com>
CC: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickens <hughd@google.com>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shli@kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: page allocator bug in 3.16?
References: <54246506.50401@hurleysoftware.com>	<20140925143555.1f276007@as>	<5424AAD0.9010708@hurleysoftware.com>	<542512AD.9070304@vmware.com>	<20140926054005.5c7985c0@as>	<542543D8.8020604@vmware.com> <CAF6AEGvOkPq5LQR76-VbspYyCvUxL1=W-dLc4g_aWX2wkUmRpg@mail.gmail.com>
In-Reply-To: <CAF6AEGvOkPq5LQR76-VbspYyCvUxL1=W-dLc4g_aWX2wkUmRpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/26/2014 08:28 AM, Rob Clark wrote:
> On Fri, Sep 26, 2014 at 6:45 AM, Thomas Hellstrom
> <thellstrom@vmware.com> wrote:
>> On 09/26/2014 12:40 PM, Chuck Ebbert wrote:
>>> On Fri, 26 Sep 2014 09:15:57 +0200 Thomas Hellstrom
>>> <thellstrom@vmware.com> wrote:
>>> 
>>>> On 09/26/2014 01:52 AM, Peter Hurley wrote:
>>>>> On 09/25/2014 03:35 PM, Chuck Ebbert wrote:
>>>>>> There are six ttm patches queued for 3.16.4:
>>>>>> 
>>>>>> drm-ttm-choose-a-pool-to-shrink-correctly-in-ttm_dma_pool_shrink_scan.patch
>>>>>>
>>>>>> 
drm-ttm-fix-handling-of-ttm_pl_flag_topdown-v2.patch
>>>>>> drm-ttm-fix-possible-division-by-0-in-ttm_dma_pool_shrink_scan.patch
>>>>>>
>>>>>> 
drm-ttm-fix-possible-stack-overflow-by-recursive-shrinker-calls.patch
>>>>>> drm-ttm-pass-gfp-flags-in-order-to-avoid-deadlock.patch 
>>>>>> drm-ttm-use-mutex_trylock-to-avoid-deadlock-inside-shrinker-functions.patch
>>>>>
>>>>>> 
Thanks for info, Chuck.
>>>>> 
>>>>> Unfortunately, none of these fix TTM dma allocation doing
>>>>> CMA dma allocation, which is the root problem.
>>>>> 
>>>>> Regards, Peter Hurley
>>>> The problem is not really in TTM but in CMA, There was a guy
>>>> offering to fix this in the CMA code but I guess he didn't
>>>> probably because he didn't receive any feedback.
>>>> 
>>> Yeah, the "solution" to this problem seems to be "don't enable
>>> CMA on x86". Maybe it should even be disabled in the config
>>> system.
>> Or, as previously suggested, don't use CMA for order 0 (single
>> page) allocations....
> 
> On devices that actually need CMA pools to arrange for memory to be
> in certain ranges, I think you probably do want to have order 0
> pages come from the CMA pool.
> 
> Seems like disabling CMA on x86 (where it should be unneeded) is
> the better way, IMO

CMA has its uses on x86. For example, CMA is used to allocate 1GB huge
pages.

There may also be people with devices that do not scatter-gather, and
need a large physically contiguous buffer, though there should be
relatively few of those on x86.

I suspect it makes most sense to do DMA allocations up to PAGE_ORDER
through the normal allocator on x86, and only invoking CMA for larger
allocations.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUJV6lAAoJEM553pKExN6DjrQH/1N19Hp5FrJr+a3GpQDh6ouc
YSBChxe+wG1h3OmcFGAG69tOK9XPw0oaV77ohwLxnvSv6BQZyi2CUIJvUdgSaOOx
8XYnn8VIIlMn4IKYmraAhSWT/gm3FkyDW7tckEdLV0NsrKeUcavCRHcLXxh41OBw
XJboZyS3XvwF+scAwjHpWPxby1Byi0lZJizTAzI3xdlyVaM5Lio1xLvOW2MHY7dR
h/ai8mfAAdQvnaHsFLoypBM/xYJqaUVU8IyCzhOeO86dUMy2xhD4vm/f9vSLuOju
4VYf7POuziNo1q2vJ8YcrThsAjB0Oiu9B5nDar471G3l1xN1zHQVw/RAnpNF9Kk=
=iZlM
-----END PGP SIGNATURE-----
