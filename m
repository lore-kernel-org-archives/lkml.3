Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3BSJ5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:57:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10389 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755812Ab3BSJ5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:57:07 -0500
X-IronPort-AV: E=Sophos;i="4.84,694,1355068800"; 
   d="scan'208";a="6729673"
Message-ID: <51234C12.4020404@cn.fujitsu.com>
Date: Tue, 19 Feb 2013 17:55:30 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, bcrl@kvack.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com,
        rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, jiang.liu@huawei.com,
        linux-mm@kvack.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hotplug: implement non-movable version of get_user_pages()
 called get_user_pages_non_movable()
References: <1359972248-8722-1-git-send-email-linfeng@cn.fujitsu.com> <1359972248-8722-2-git-send-email-linfeng@cn.fujitsu.com> <20130204160624.5c20a8a0.akpm@linux-foundation.org> <20130205115722.GF21389@suse.de> <512203C4.8010608@cn.fujitsu.com> <20130218151716.GL4365@suse.de>
In-Reply-To: <20130218151716.GL4365@suse.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 17:56:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 17:56:26,
	Serialize complete at 2013/02/19 17:56:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On 02/18/2013 11:17 PM, Mel Gorman wrote:
>>> > > <SNIP>
>>> > >
>>> > > result. It's a little clumsy but the memory hot-remove failure message
>>> > > could list what applications have pinned the pages that cannot be removed
>>> > > so the administrator has the option of force-killing the application. It
>>> > > is possible to discover what application is pinning a page from userspace
>>> > > but it would involve an expensive search with /proc/kpagemap
>>> > > 
>>>>> > >>> +	if (migrate_pre_flag && !isolate_err) {
>>>>> > >>> +		ret = migrate_pages(&pagelist, alloc_migrate_target, 1,
>>>>> > >>> +					false, MIGRATE_SYNC, MR_SYSCALL);
>>> > > 
>>> > > The conversion of alloc_migrate_target is a bit problematic. It strips
>>> > > the __GFP_MOVABLE flag and the consequence of this is that it converts
>>> > > those allocation requests to MIGRATE_UNMOVABLE. This potentially is a large
>>> > > number of pages, particularly if the number of get_user_pages_non_movable()
>>> > > increases for short-lived pins like direct IO.
>> >
>> > Sorry, I don't quite understand here neither. If we use the following new 
>> > migration allocation function as you said, the increasing number of 
>> > get_user_pages_non_movable() will also lead to large numbers of MIGRATE_UNMOVABLE
>> > pages. What's the difference, do I miss something?
>> > 
> The replacement function preserves the __GFP_MOVABLE flag. It cannot use
> ZONE_MOVABLE but otherwise the newly allocated page will be grouped with
> other movable pages.

Ah, got it " But GFP_MOVABLE is not only a zone specifier but also an allocation policy.".

Could I clear __GFP_HIGHMEM flag in alloc_migrate_target depending on private parameter so
that we can keep MIGRATE_UNMOVABLE policy also allocate page none movable zones with little
change?

Does that approach work? Otherwise I have to follow your suggestion.

thanks,
linfeng
