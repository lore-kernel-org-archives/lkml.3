Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbaEHQir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:38:47 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34984 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaEHQip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:38:45 -0400
Message-ID: <536BB310.1050105@linaro.org>
Date: Thu, 08 May 2014 09:38:40 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Keith Packard <keithp@keithp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/4] MADV_VOLATILE: Add MADV_VOLATILE/NONVOLATILE hooks
 and handle marking vmas
References: <1398806483-19122-1-git-send-email-john.stultz@linaro.org> <1398806483-19122-3-git-send-email-john.stultz@linaro.org> <20140508012142.GA5282@bbox>
In-Reply-To: <20140508012142.GA5282@bbox>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 06:21 PM, Minchan Kim wrote:
> Hey John,
>
> On Tue, Apr 29, 2014 at 02:21:21PM -0700, John Stultz wrote:
>> This patch introduces MADV_VOLATILE/NONVOLATILE flags to madvise(),
>> which allows for specifying ranges of memory as volatile, and able
>> to be discarded by the system.
>>
>> This initial patch simply adds flag handling to madvise, and the
>> vma handling, splitting and merging the vmas as needed, and marking
>> them with VM_VOLATILE.
>>
>> No purging or discarding of volatile ranges is done at this point.
>>
>> This a simplified implementation which reuses some of the logic
>> from Minchan's earlier efforts. So credit to Minchan for his work.
> Remove purged argument is really good thing but I'm not sure merging
> the feature into madvise syscall is good idea.
> My concern is how we support user who don't want SIGBUS.
> I believe we should support them because someuser(ex, sanitizer) really
> want to avoid MADV_NONVOLATILE call right before overwriting their cache
> (ex, If there was purged page for cyclic cache, user should call NONVOLATILE
> right before overwriting to avoid SIGBUS).

So... Why not use MADV_FREE then for this case?

Just to be clear, by moving back to madvise, I'm not trying to replace
MADV_FREE. I think you're work there is still useful and splitting the
semantics between the two is cleaner.


> Moreover, this changes made unmarking cost O(N) so I'd like to avoid
> NOVOLATILE syscall if possible.
Well, I think that was made in v13, but yes. NONVOLATILE is currently an
expensive operation in order to keep the semantics simpler, as requested
by Johannes and Kosaki-san.


> For me, SIGBUS is more special usecase for code pages but I believe
> both are reasonable for each usecase so my preference is MADV_VOLATILE
> is just zero-filled page and MADV_VOLATILE_SIGBUS, another new advise
> if you really want to merge volatile range feature with madvise.

This I disagree with. Even for non-code page cases, SIGBUS on volatile
page access is important for normal users who might accidentally touch
volatile data, so they know they are corrupting their data. I know
Johannes suggested this is simply a use-after-free issue, but I really
feel it results in having very strange semantics. And for those cases
where there is a benefit to zero-fill, MADV_FREE seems more appropriate.

thanks
-john



