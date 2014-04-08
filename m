Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbaDHSxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:53:05 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52551 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723AbaDHSxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:53:00 -0400
Message-ID: <53444587.6040504@linaro.org>
Date: Tue, 08 Apr 2014 11:52:55 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] vrange: Add vrange syscall and handle splitting/merging
 and marking vmas
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <1395436655-21670-2-git-send-email-john.stultz@linaro.org> <CAHGf_=rKpOW5PSbAOZtg6GehJD6dOvRbBTSWV_2HOehw8xCa4g@mail.gmail.com>
In-Reply-To: <CAHGf_=rKpOW5PSbAOZtg6GehJD6dOvRbBTSWV_2HOehw8xCa4g@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Kosaki-san,
   Sorry to not have replied to this earlier, I really appreciate your
review! I'm now running through your feedback to make sure its all
integrated into my upcoming v13 patch series, and while most of your
comments have been addressed there are a few items outstanding, which I
suspect is from misunderstanding on my part or yours.

Anyway, thanks again for the comments. A few notes below.

On 03/23/2014 09:50 AM, KOSAKI Motohiro wrote:
> On Fri, Mar 21, 2014 at 2:17 PM, John Stultz <john.stultz@linaro.org> wrote:
>> RETURN VALUE
>>         On success vrange returns the number of bytes marked or unmarked.
>>         Similar to write(), it may return fewer bytes then specified
>>         if it ran into a problem.
> This explanation doesn't match your implementation. You return the
> last VMA - orig_start.
> That said, when some hole is there at middle of the range marked (or
> unmarked) bytes
> aren't match the return value.

As soon as we hit the hole, we will stop making further changes and will
return the number of successfully modified bytes up to that part. Thus
last VMA - orig_start should still match the modified values up to the hole.

I'm not sure how this is inconsistent with the implementation or
documentation, but there may still be bugs so I'd appreciate your
clarification if you think this is still an issue in the v13 release.


>
>>         When using VRANGE_NON_VOLATILE, if the return value is smaller
>>         then the specified length, then the value specified by the purged
>>         pointer will be set to 1 if any of the pages specified in the
>>         return value as successfully marked non-volatile had been purged.
>>
>>         If an error is returned, no changes were made.
> At least, this explanation doesn't match the implementation. When you find file
> mappings, you don't rollback prior changes.
No. If we find a file mapping, we simply return the amount of
successfully modified bytes prior to hitting that file mapping. This is
much in the same way as if we hit a hole in the address space. Again,
maybe you mis-read this or I am not understanding the issue you're
pointing out.



>
>> diff --git a/include/linux/vrange.h b/include/linux/vrange.h
>> new file mode 100644
>> index 0000000..6e5331e
>> --- /dev/null
>> +++ b/include/linux/vrange.h
>> @@ -0,0 +1,8 @@
>> +#ifndef _LINUX_VRANGE_H
>> +#define _LINUX_VRANGE_H
>> +
>> +#define VRANGE_NONVOLATILE 0
>> +#define VRANGE_VOLATILE 1
> Maybe, moving uapi is better?

Agreed! Fixed in my tree.


>> +
>> +       down_read(&mm->mmap_sem);
> This should be down_write. VMA split and merge require write lock.

Very true. Minchan has already sent a fix that I've folded into my tree.



>> +
>> +       len &= PAGE_MASK;
>> +       if (!len)
>> +               goto out;
> This code doesn't match the explanation of "not page size units."

Again, good eye! Fixed in my tree.



>> +       if (purged) {
>> +               if (put_user(p, purged)) {
>> +                       /*
>> +                        * This would be bad, since we've modified volatilty
>> +                        * and the change in purged state would be lost.
>> +                        */
>> +                       WARN_ONCE(1, "vrange: purge state possibly lost\n");
> Don't do that.
> If userland app unmap the page between do_vrange and here, it's just
> their fault, not kernel.
> Therefore kernel warning make no sense. Please just move 1st put_user to here.
Yes, per Jan's suggestion I've changed this to return EFAULT.


Thanks again for your great review here!
-john

