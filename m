Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbaCTAiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 20:38:16 -0400
Received: from www.sr71.net ([198.145.64.142]:49454 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbaCTAiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 20:38:15 -0400
Message-ID: <532A3872.1080101@sr71.net>
Date: Wed, 19 Mar 2014 17:38:10 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>, John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dgiani@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/3] Volatile Ranges (v11)
References: <1394822013-23804-1-git-send-email-john.stultz@linaro.org> <20140318122425.GD3191@dhcp22.suse.cz>
In-Reply-To: <20140318122425.GD3191@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 05:24 AM, Michal Hocko wrote:
> On Fri 14-03-14 11:33:30, John Stultz wrote:
> [...]
>> Volatile ranges provides a method for userland to inform the kernel that
>> a range of memory is safe to discard (ie: can be regenerated) but
>> userspace may want to try access it in the future.  It can be thought of
>> as similar to MADV_DONTNEED, but that the actual freeing of the memory
>> is delayed and only done under memory pressure, and the user can try to
>> cancel the action and be able to quickly access any unpurged pages. The
>> idea originated from Android's ashmem, but I've since learned that other
>> OSes provide similar functionality.
> 
> Maybe I have missed something (I've only glanced through the patches)
> but it seems that marking a range volatile doesn't alter neither
> reference bits nor position in the LRU. I thought that a volatile page
> would be moved to the end of inactive LRU with the reference bit
> dropped. Or is this expectation wrong and volatility is not supposed to
> touch page aging?

I'm not really convinced it should alter the aging.  Things could
potentially go in and out of volatile state frequently, and requiring
aging means we've got to go after them page-by-page or pte-by-pte at
best.  That doesn't seem like something we want to do in a path we want
to be fast.

Why not just let normal page aging deal with them?  It seems to me like
like trying to infer intended lru position from volatility is the wrong
thing.  It's quite possible we'd have two pages in the same range that
we want in completely different parts of the LRU.  Maybe the structure
has a hot page and a cold one, and we would ideally want the cold one
swapped out and not the hot one.

