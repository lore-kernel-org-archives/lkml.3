Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab3GKKOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:14:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:5207 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab3GKKOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:14:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,1043,1363104000"; 
   d="scan'208";a="7862846"
Message-ID: <51DE84D0.2000209@cn.fujitsu.com>
Date: Thu, 11 Jul 2013 18:11:28 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Benjamin LaHaise <bcrl@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] Add support to aio ring pages migration
References: <51DA96BC.1060701@cn.fujitsu.com>
In-Reply-To: <51DA96BC.1060701@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/11 18:13:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/11 18:13:09,
	Serialize complete at 2013/07/11 18:13:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping...

On 07/08/2013 06:38 PM, Gu Zheng wrote:

> Currently aio ring pages use get_user_pages() to allocate pages from movable
> zone,as discussed in thread https://lkml.org/lkml/2012/11/29/69, it is easy to
> pin user pages for a long time, which is fatal for memory hotplug/remove framework.
> 
> As Mel Gorman suggested, "Implement a callback for migration to unpin pages,
> barrier operations until migration completes and pin the new pfns" can soloved
> this issue. And the best palce to hold the callbacks is address space operations
> which can be found via page->mapping.
> 
> But the current aio ring pages are anonymous pages, they don't have
> address_space_operations, so we use an anon inode file as the aio ring file to
> manage the aio ring pages, so that we can implement the callback and register it
> to page->mmapping->a_ops->migratepage.
> 
> But there's a ploblem that all files created by anon_inode_getfile() share the
> same inode, so mutil aio context will share the same aio ring pages, it'll lead
> to io events chaos. In order to solve this issus, we introduce a new fucntion
> anon_inode_getfile_private() which is samilar to anon_inode_getfile(), but each
> new file has its own anon inode.
> 
> This work is based on Benjamin's patch,
> http://www.spinics.net/lists/linux-fsdevel/msg66014.html
> 
> Gu Zheng (2):
>   fs/anon_inode: Introduce a new lib function
>     anon_inode_getfile_private()
>   fs/aio: Add support to aio ring pages migration
> 
>  fs/aio.c                    |  120 +++++++++++++++++++++++++++++++++++++++----
>  fs/anon_inodes.c            |   66 +++++++++++++++++++++++
>  include/linux/anon_inodes.h |    3 +
>  include/linux/migrate.h     |    3 +
>  mm/migrate.c                |    2 +-
>  5 files changed, 182 insertions(+), 12 deletions(-)
> 


