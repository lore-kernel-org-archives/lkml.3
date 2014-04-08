Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbaDHDJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 23:09:44 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35219 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaDHDJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 23:09:43 -0400
Message-ID: <53436873.9020802@linaro.org>
Date: Mon, 07 Apr 2014 20:09:39 -0700
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
Subject: Re: [PATCH 2/5] vrange: Add purged page detection on setting memory
 non-volatile
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <1395436655-21670-3-git-send-email-john.stultz@linaro.org> <CAHGf_=pBUW1Za862NGeN2u2D8B9hjTk5DgP4SYqoM34KUnMMhQ@mail.gmail.com> <5342F083.5020509@linaro.org> <CAHGf_=pRy-8XjMjE4Kk9AgO2oeRcy+DiMLiN-rBhuWOexxbXJw@mail.gmail.com>
In-Reply-To: <CAHGf_=pRy-8XjMjE4Kk9AgO2oeRcy+DiMLiN-rBhuWOexxbXJw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 03:14 PM, KOSAKI Motohiro wrote:
>>> This change hwpoison and migration tag number. maybe ok, maybe not.
>> Though depending on config can't these tag numbers change anyway?
> I don't think distro disable any of these.

Well, it still shouldn't break if the config options are turned off.
This isn't some subtle userspace visible ABI, is it?
I'm fine with keeping the values the same, but it just seems worrying if
this logic is so fragile.


>>> I'd suggest to use younger number than hwpoison.
>>> (That's why hwpoison uses younger number than migration)
>> So I can, but the way these are defined makes the results seem pretty
>> terrible:
>>
>> #define SWP_MIGRATION_WRITE    (MAX_SWAPFILES + SWP_HWPOISON_NUM \
>>                     + SWP_MVOLATILE_PURGED_NUM + 1)
>>
>> Particularly when:
>> #define MAX_SWAPFILES ((1 << MAX_SWAPFILES_SHIFT)        \
>>                 - SWP_MIGRATION_NUM        \
>>                 - SWP_HWPOISON_NUM        \
>>                 - SWP_MVOLATILE_PURGED_NUM    \
>>             )
>>
>> Its a lot of unnecessary mental gymnastics. Yuck.
>>
>> Would a general cleanup like the following be ok to try to make this
>> more extensible?
>>
>> thanks
>> -john
>>
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 3507115..21387df 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -49,29 +49,38 @@ static inline int current_is_kswapd(void)
>>   * actions on faults.
>>   */
>>
>> +enum {
>> +       /*
>> +        * NOTE: We use the high bits here (subtracting from
>> +        * 1<<MAX_SWPFILES_SHIFT), so to preserve the values insert
>> +        * new entries here at the top of the enum, not at the bottom
>> +        */
>> +#ifdef CONFIG_MEMORY_FAILURE
>> +       SWP_HWPOISON_NR,
>> +#endif
>> +#ifdef CONFIG_MIGRATION
>> +       SWP_MIGRATION_READ_NR,
>> +       SWP_MIGRATION_WRITE_NR,
>> +#endif
>> +       SWP_MAX_NR,
>> +};
>> +#define MAX_SWAPFILES ((1 << MAX_SWAPFILES_SHIFT) - SWP_MAX_NR)
>> +
> I don't see any benefit of this code. At least, SWP_MAX_NR is suck.


So it makes adding new special swap types (like SWP_MVOLATILE_PURGED)
much cleaner. If we need to preserve the actual values for SWP_HWPOSIN
and SWP_MIGRATION_* as you suggested earlier, the cleanup above makes
doing so when adding a new type much easier.

For example adding the MVOLATILE_PURGED value (without effecting the
values of HWPOSIN or MIGRATION_*) is only:

@@ -55,6 +55,7 @@ enum {
         * 1<<MAX_SWPFILES_SHIFT), so to preserve the values insert
         * new entries here at the top of the enum, not at the bottom
         */
+       SWP_MVOLATILE_PURGED_NR,
 #ifdef CONFIG_MEMORY_FAILURE
        SWP_HWPOISON_NR,
 #endif
@@ -81,6 +82,10 @@ enum {
 #define SWP_HWPOISON           (MAX_SWAPFILES + SWP_HWPOISON_NR)
 #endif
 
+/*
+ * Purged volatile range pages
+ */
+#define SWP_MVOLATILE_PURGED   (MAX_SWAPFILES + SWP_MVOLATILE_PURGED_NR)
 

That's *much* nicer when compared with modifying every value to subtract the extra entry, as it was done before.


> The name doesn't match the actual meanings.
Would SWP_MAX_SPECIAL_TYPE_NR be a better name? Do you have other
suggestions?

thanks
-john

