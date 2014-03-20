Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaCTA5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 20:57:39 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39911 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaCTA5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 20:57:37 -0400
Message-ID: <532A3CFC.4080406@linaro.org>
Date: Wed, 19 Mar 2014 17:57:32 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, Michal Hocko <mhocko@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/3] Volatile Ranges (v11)
References: <1394822013-23804-1-git-send-email-john.stultz@linaro.org> <20140318122425.GD3191@dhcp22.suse.cz> <532A3872.1080101@sr71.net>
In-Reply-To: <532A3872.1080101@sr71.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 05:38 PM, Dave Hansen wrote:
> On 03/18/2014 05:24 AM, Michal Hocko wrote:
>> On Fri 14-03-14 11:33:30, John Stultz wrote:
>> [...]
>>> Volatile ranges provides a method for userland to inform the kernel that
>>> a range of memory is safe to discard (ie: can be regenerated) but
>>> userspace may want to try access it in the future.  It can be thought of
>>> as similar to MADV_DONTNEED, but that the actual freeing of the memory
>>> is delayed and only done under memory pressure, and the user can try to
>>> cancel the action and be able to quickly access any unpurged pages. The
>>> idea originated from Android's ashmem, but I've since learned that other
>>> OSes provide similar functionality.
>> Maybe I have missed something (I've only glanced through the patches)
>> but it seems that marking a range volatile doesn't alter neither
>> reference bits nor position in the LRU. I thought that a volatile page
>> would be moved to the end of inactive LRU with the reference bit
>> dropped. Or is this expectation wrong and volatility is not supposed to
>> touch page aging?
> I'm not really convinced it should alter the aging.  Things could
> potentially go in and out of volatile state frequently, and requiring
> aging means we've got to go after them page-by-page or pte-by-pte at
> best.  That doesn't seem like something we want to do in a path we want
> to be fast.
>
> Why not just let normal page aging deal with them?  It seems to me like
> like trying to infer intended lru position from volatility is the wrong
> thing.  It's quite possible we'd have two pages in the same range that
> we want in completely different parts of the LRU.  Maybe the structure
> has a hot page and a cold one, and we would ideally want the cold one
> swapped out and not the hot one.
s/swapped/purged

But yea. Part of the request here is that when talking with potential
users, there were some folks who were particularly concerned that if we
purge a page from a range, we should purge the rest of that range before
purging any pages of other ranges. Minchan has pushed for a flag
VRANGE_FULL option (vs VRANGE_PARTIAL) to trigger this sort of
full-range purging semantics.

Subtly, the same potential user wanted the partial semantics as well,
since they could continue to access the unpurged volatile data, allowing
only the cold pages to be purged.

I'm not particularly fond of having a option to specify this behavior,
since I really want to leave all purging decisions to the VM and not
have userland expect a particular behavior for volatile purging (since
the right call at a system level may be different from one situation to
the next - much as userspace cannot expect constant memory access times
since some pages may be swapped out).

So one way to approximate full range purging, while still doing page
based purging, is to touch the pages being marked volatile as we mark
them. Thus they will be all of the same "age", and thus likely to be
purged together (assuming they haven't been accessed since being made
volatile, in which case the cold pages rightly are purged first). Now,
while setting them to all be of the same age, there is still the open
question of what should that age be? And I'm not sure that answer is yet
clear.  But as long as they are together, we still get the (approximate)
full range purging behavior that was desired.

Now.. one could also argue (as you have) that such behavior could be
done separately from the mark-volatile operation. Possibly via making an
madvise call on the range, prior to calling
vrange(VRANGE_VOLATILE,...).  This is attractive, since it lowers the
performance overhead. But I wanted to at least try to implement the page
referencing, since I had talked about it as a solution to the
FULL/PARTIAL purging issue.

thanks
-john







