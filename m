Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3EOHSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:18:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:47113 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755108Ab3EOHSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:18:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,675,1363104000"; 
   d="scan'208";a="7274242"
Message-ID: <5193377E.30102@cn.fujitsu.com>
Date: Wed, 15 May 2013 15:21:34 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>, Mel Gorman <mgorman@suse.de>
CC: Jeff Moyer <jmoyer@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Lin Feng <linfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, zab@redhat.com,
        linux-mm@kvack.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH V2 1/2] mm: hotplug: implement non-movable version of
 get_user_pages() called get_user_pages_non_movable()
References: <1360056113-14294-2-git-send-email-linfeng@cn.fujitsu.com> <20130205120137.GG21389@suse.de> <20130206004234.GD11197@blaptop> <20130206095617.GN21389@suse.de> <5190AE4F.4000103@cn.fujitsu.com> <20130513091902.GP11497@suse.de> <20130513143757.GP31899@kvack.org> <x49obcfnd6c.fsf@segfault.boston.devel.redhat.com> <20130513150147.GQ31899@kvack.org> <5191926A.2090608@cn.fujitsu.com> <20130514135850.GG13845@kvack.org> <5192EE40.7060407@cn.fujitsu.com>
In-Reply-To: <5192EE40.7060407@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 15:17:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 15:17:33,
	Serialize complete at 2013/05/15 15:17:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin, Mel,

On 05/15/2013 10:09 AM, Tang Chen wrote:
> Hi Benjamin, Mel,
>
> Please see below.
>
> On 05/14/2013 09:58 PM, Benjamin LaHaise wrote:
>> On Tue, May 14, 2013 at 09:24:58AM +0800, Tang Chen wrote:
>>> Hi Mel, Benjamin, Jeff,
>>>
>>> On 05/13/2013 11:01 PM, Benjamin LaHaise wrote:
>>>> On Mon, May 13, 2013 at 10:54:03AM -0400, Jeff Moyer wrote:
>>>>> How do you propose to move the ring pages?
>>>>
>>>> It's the same problem as doing a TLB shootdown: flush the old pages
>>>> from
>>>> userspace's mapping, copy any existing data to the new pages, then
>>>> repopulate the page tables. It will likely require the addition of
>>>> address_space_operations for the mapping, but that's not too hard to
>>>> do.
>>>>
>>>
>>> I think we add migrate_unpin() callback to decrease page->count if
>>> necessary,
>>> and migrate the page to a new page, and add migrate_pin() callback to
>>> pin
>>> the new page again.
>>
>> You can't just decrease the page count for this to work. The pages are
>> pinned because aio_complete() can occur at any time and needs to have a
>> place to write the completion events. When changing pages, aio has to
>> take the appropriate lock when changing one page for another.
>
> In aio_complete(),
>
> aio_complete() {
> ......
> spin_lock_irqsave(&ctx->completion_lock, flags);
> //write the completion event.
> spin_unlock_irqrestore(&ctx->completion_lock, flags);
> ......
> }
>
> So for this problem, I think we can hold kioctx->completion_lock in the aio
> callbacks to prevent aio subsystem accessing pages who are being migrated.
>

Another problem here is:

We intend to call these callbacks in the page migrate path, and we need to
know which lock to hold. But there is no way for migrate path to know this
info.

The migrate path is common for all kinds of pages, so we cannot pass any
specific parameter to the callbacks in migrate path.

When we get a page, we cannot get any kioctx info from the page. So how can
the callback know which lock to require without any parameter ? Or do we 
have
any other way to do so ?

Would you please give some more advice about this ?

BTW, we also need to update kioctx->ring_pages.

Thanks. :)

>>
>>> The migrate procedure will work just as before. We use callbacks to
>>> decrease
>>> the page->count before migration starts, and increase it when the
>>> migration
>>> is done.
>>>
>>> And migrate_pin() and migrate_unpin() callbacks will be added to
>>> struct address_space_operations.
>>
>> I think the existing migratepage operation in address_space_operations
>> can
>> be used. Does it get called when hot unplug occurs? That is: is testing
>> with the migrate_pages syscall similar enough to the memory removal case?
>>
>
> But as I said, for anonymous pages such as aio ring buffer, they don't have
> address_space_operations. So where should we put the callbacks' pointers ?
>
> Add something like address_space_operations to struct anon_vma ?
>
> Thanks. :)
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
>
