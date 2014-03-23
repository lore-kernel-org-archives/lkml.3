Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaCWUeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 16:34:21 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:63424 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaCWUeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 16:34:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140323122058.GB2813@quack.suse.cz>
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org>
	<1395436655-21670-2-git-send-email-john.stultz@linaro.org>
	<20140323122058.GB2813@quack.suse.cz>
Date: Sun, 23 Mar 2014 13:34:19 -0700
Message-ID: <CALAqxLVR6mj7uS6oW3CkUwLXZpcD1=Xu2VGQ1v88uhZgZ2Y5gg@mail.gmail.com>
Subject: Re: [PATCH 1/5] vrange: Add vrange syscall and handle
 splitting/merging and marking vmas
From: John Stultz <john.stultz@linaro.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 5:20 AM, Jan Kara <jack@suse.cz> wrote:
> On Fri 21-03-14 14:17:31, John Stultz wrote:
>> RETURN VALUE
>>       On success vrange returns the number of bytes marked or unmarked.
>>       Similar to write(), it may return fewer bytes then specified
>>       if it ran into a problem.
>>
>>       When using VRANGE_NON_VOLATILE, if the return value is smaller
>>       then the specified length, then the value specified by the purged
>         ^^^ than

Ah, thanks!

> Also I'm not sure why *purged is set only if the return value is smaller
> than the specified legth. Won't the interface be more logical if we set
> *purged to appropriate value in all cases?

So yea, we do set purged to the appropriate value in all cases. The
confusion here is I'm trying to clarify that in the case that the
return value is smaller then the requested length, the value of the
purge variable will be set to the purge state of only the pages
successfully marked non-volatile. In other words, the purge value will
provide no information about the requested pages beyond the returned
byte count. I'm clearly making a bit of a mess with the wording there
(and here probably as well ;). Any suggestions for a more clear
phrasing would be appreciated.


>> +     ret = do_vrange(mm, start, end, mode, flags, &p);
>> +
>> +     if (purged) {
>> +             if (put_user(p, purged)) {
>> +                     /*
>> +                      * This would be bad, since we've modified volatilty
>> +                      * and the change in purged state would be lost.
>> +                      */
>> +                     WARN_ONCE(1, "vrange: purge state possibly lost\n");
>   I think this can happen when the application has several threads and
> vrange() in one thread races with munmap() in another thread. So
> WARN_ONCE() doesn't look appropriate (kernel shouldn't spew warnings about
> application programming bugs)... I'd just return -EFAULT. I know
> information will be lost but userspace is doing something utterly stupid.

Ok.. I guess that sounds reasonable.

Thanks for the review! Very much appreciate it!
-john
