Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab3FFOhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:37:00 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41839 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab3FFOg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:36:58 -0400
Message-ID: <51B09E83.9040606@gmail.com>
Date: Thu, 06 Jun 2013 22:36:51 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/10] zram: use atomic64_xxx() to replace zram_stat64_xxx()
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com> <1370361968-8764-10-git-send-email-jiang.liu@huawei.com> <51AF28C4.3040405@redhat.com> <51AF659F.9080205@gmail.com> <51B0584F.6080609@redhat.com>
In-Reply-To: <51B0584F.6080609@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06 Jun 2013 05:37:19 PM CST, Jerome Marchand wrote:
> On 06/05/2013 06:21 PM, Jiang Liu wrote:
>> On Wed 05 Jun 2013 08:02:12 PM CST, Jerome Marchand wrote:
>>> On 06/04/2013 06:06 PM, Jiang Liu wrote:
>>>> Use atomic64_xxx() to replace open-coded zram_stat64_xxx().
>>>> Some architectures have native support of atomic64 operations,
>>>> so we can get rid of the spin_lock() in zram_stat64_xxx().
>>>> On the other hand, for platforms use generic version of atomic64
>>>> implement, it may cause an extra save/restore of the interrupt
>>>> flag.  So it's a tradeoff.
>>>>
>>>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>>>
>>> Before optimizing stats, I'd like to make sure that they're correct.
>>> What makes 64 bits fields so different that they need atomicity while
>>> 32 bits wouldn't? Actually all of them save compr_size only increase,
>>> which would make a race less critical than for 32 bits fields that all
>>> can go up and down (if a decrement overwrites a increment, the counter
>>> can wrap around zero).
>>>
>>> Jerome
>>>
>> Hi Jerome,
>>           I'm not sure about the design decision, but I could give a
>> guess here.
>> 1) All 32-bit counters are only modified by
>> zram_bvec_write()/zram_page_free()
>> and is/should be protected by down_write(&zram->lock).
>
> Good point!
>
>> 2) __zram_make_request() modifies some 64-bit counters without
>> protection.
>> 3) zram_bvec_write() modifies some 64-bit counters and it's protected
>> with
>>      down_read(&zram->lock).
>
> I assume you mean down_write().
Actually I mean "zram_bvec_read()" instead of "zram_bvec_write()".
Read side is protected by down_read(&zram->lock).
Regards!
Gerry

>
>> 4) It's always safe for sysfs handler to read 32bit counters.
>> 5) It's unsafe for sysfs handler to read 64bit counters on 32bit
>> platforms.
>
> I was unaware of that.
>
>>
>> So it does work with current design, but very hard to understand.
>> Suggest to use atomic_t for 32bit counters too for maintainability,
>> though may be a little slower.
>> Any suggestion?
>
> If atomic counter aren't necessary, no need to use them, but a comment
> in zram_stats definition would be nice. Could you add one in your next
> version of this patch?
Sure!

>
> Thanks
> Jerome
>
>> Regards!
>> Gerry
>>
>


