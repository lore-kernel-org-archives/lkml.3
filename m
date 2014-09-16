Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbaIPToQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:44:16 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:56939 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbaIPToP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:44:15 -0400
MIME-Version: 1.0
In-Reply-To: <x4961gnz844.fsf@segfault.boston.devel.redhat.com>
References: <cover.1410810247.git.milosz@adfin.com>
	<ead00ff46b581749da6d1a6d2db9d8f8dc3aed67.1410810247.git.milosz@adfin.com>
	<x4961gnz844.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 16 Sep 2014 15:44:13 -0400
Message-ID: <CANP1eJEiGxQ0fZMkOY1utmkUOkGC4gOHYrXt+yO-9+tnzA24hw@mail.gmail.com>
Subject: Re: [PATCH 4/7] O_NONBLOCK flag for readv2/preadv2
From: Milosz Tanski <milosz@adfin.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 3:19 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> writes:
>
>> Filesystems that generic_file_read_iter will not be allowed to perform
>> non-blocking reads. This only will read data if it's in the page cache and if
>> there is no page error (causing a re-read).
>>
>> Signed-off-by: Milosz Tanski <milosz@adfin.com>
>
>> @@ -1662,6 +1676,10 @@ no_cached_page:
>>                       goto out;
>>               }
>>               goto readpage;
>> +
>> +would_block:
>> +             error = -EAGAIN;
>> +             goto out;
>>       }
>
> Why did you put the wouldblock label inside the loop?  That should be
> pushed down to just above out, and then you can get rid of the goto.

When I put the code outside the loop it actually looked worse (imo):

}

goto out;

would_block:
error = -EAGAIN;

out:
...

>
> Other than that, it looks like you put the check in all the right places
> in that function.
>
>>  out:
>> @@ -1697,6 +1715,9 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter, int flags)
>>               size_t count = iov_iter_count(iter);
>>               loff_t size;
>>
>> +             if (flags & O_NONBLOCK)
>> +                     return -EAGAIN;
>> +
>
> If a program is attempting non-blocking reads on a file opened with
> O_DIRECT, I think returning -EAGAIN is very misleading.  Better to
> return -EINVAL in this case, and maybe check that earlier in the stack?

Point taken and I can fix this for the next version further up the
stack. A longer term question is how the flags the file is open with
interact with the read/write flags ... since I imagine folks will want
to add other flags (like force a SYNC write).

>
> Cheers,
> Jeff

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
