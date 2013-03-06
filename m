Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab3CFL1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:27:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:21837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757359Ab3CFL1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:27:15 -0500
X-IronPort-AV: E=Sophos;i="4.84,795,1355068800"; 
   d="scan'208";a="6824350"
Message-ID: <513728AD.6020307@cn.fujitsu.com>
Date: Wed, 06 Mar 2013 19:29:49 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: akpm@linux-foundation.org, mgorman@suse.de, bcrl@kvack.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com,
        rientjes@google.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, jiang.liu@huawei.com,
        zab@redhat.com, jmoyer@redhat.com, linux-mm@kvack.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com
Subject: Re: [PATCH V3 1/2] mm: hotplug: implement non-movable version of
 get_user_pages() called get_user_pages_non_movable()
References: <1361444504-31888-1-git-send-email-linfeng@cn.fujitsu.com> <1361444504-31888-2-git-send-email-linfeng@cn.fujitsu.com> <512C7C13.9050602@cn.fujitsu.com> <5136F4D2.8080205@jp.fujitsu.com>
In-Reply-To: <5136F4D2.8080205@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 19:26:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 19:26:10,
	Serialize complete at 2013/03/06 19:26:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yasuaki,

On 03/06/2013 03:48 PM, Yasuaki Ishimatsu wrote:
> Hi Lin,
> 
> IMHO, current implementation depends on luck. So even if system has
> many non movable memory, get_user_pages_non_movable() may not allocate
> non movable memory.

Sorry, I'm not quite understand here, since the to be pinned pages are
never pinned before, the migration successful probability is quite high,
not just depends on luck.

> 
> At following thread, Marek Szyprowski implemented similar feature which
> allocates non movable memory by "get_user_pages()".
> 
> https://lkml.org/lkml/2013/3/5/44
> 
> I think Marek's way is better.

I think the two versions of get_user_pages() are not that great and one
I can see is that Marek's patchset adding new flag to instruct the page
allocation while I'm not sure if that approach is proper since it touches
the core page allocation codes.

Besides in Marek's version we also have to patch every place if we want to 
get around migration failure caused by GUP long pinned pages unless
we want GUP fall into getting all pages from non movable zones.

As Mel suggested before adding a migrate callback for such pages may be 
another approach, but we also have to distinguish the long-time pin
and short-time pin while which is not expectable beforehand. 

So what we can do to improve is to migrate the pinned pages by GUP just
the time we perform the migration caused by memory hotplug or cma people
so that nobody cases if the page is long-time pinned or not :)

But is that feasible to migrate a being pinned page ? 
  
thanks,
linfeng
