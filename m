Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab3ENEM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 00:12:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15616 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab3ENEM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 00:12:27 -0400
X-IronPort-AV: E=Sophos;i="4.87,667,1363104000"; 
   d="scan'208";a="7262498"
Message-ID: <5191B5B3.7080406@cn.fujitsu.com>
Date: Tue, 14 May 2013 11:55:31 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Minchan Kim <minchan@kernel.org>, Lin Feng <linfeng@cn.fujitsu.com>,
        akpm@linux-foundation.org, bcrl@kvack.org, viro@zeniv.linux.org.uk,
        khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, zab@redhat.com,
        jmoyer@redhat.com, linux-mm@kvack.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH V2 1/2] mm: hotplug: implement non-movable version of
 get_user_pages() called get_user_pages_non_movable()
References: <1360056113-14294-1-git-send-email-linfeng@cn.fujitsu.com> <1360056113-14294-2-git-send-email-linfeng@cn.fujitsu.com> <20130205120137.GG21389@suse.de> <20130206004234.GD11197@blaptop> <20130206095617.GN21389@suse.de> <5190AE4F.4000103@cn.fujitsu.com> <20130513091902.GP11497@suse.de>
In-Reply-To: <20130513091902.GP11497@suse.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 11:51:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 11:51:59,
	Serialize complete at 2013/05/14 11:51:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On 05/13/2013 05:19 PM, Mel Gorman wrote:
>> For memory hot-remove case, the aio pages are pined in memory and making
>> the pages cannot be offlined, furthermore, the pages cannot be removed.
>>
>> IIUC, you mean implement migrate_unpin() and migrate_pin() callbacks in aio
>> subsystem, and call them when hot-remove code tries to offline
>> pages, right ?
>>
>> If so, I'm wondering where should we put this callback pointers ?
>> In struct page ?
>>
>
> No, I would expect the callbacks to be part the address space operations
> which can be found via page->mapping.
>

Two more problems I don't quite understand.

1. For an anonymous page, it has no address_space, and no address space
    operation. But the aio ring problem just happened when dealing with
    anonymous pages. Please refer to:
    (https://lkml.org/lkml/2012/11/29/69)

    If we put the the callbacks in page->mapping->a_ops, the anonymous 
pages
    won't be able to use them.

    And we cannot give a default callback because the situation we are 
dealing
    with is a special situation.

    So where to put the callback for anonymous pages ?


2. How to find out the reason why page->count != 1 in 
migrate_page_move_mapping() ?

    In the problem we are dealing with, get_user_pages() is called to 
pin the pages
    in memory. And the pages are migratable. So we want to decrease the 
page->count.

    But get_user_pages() is not the only reason leading to page->count 
increased.
    How can I know when should decrease teh page->count or when should not ?

    The way I can figure out is to assign the callback pointer in 
get_user_pages()
    because it is get_user_pages() who pins the pages.


Thanks. :)








