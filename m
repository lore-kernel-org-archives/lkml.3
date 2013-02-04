Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3BDKFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:05:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:3594 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab3BDKFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:05:33 -0500
X-IronPort-AV: E=Sophos;i="4.84,599,1355068800"; 
   d="scan'208";a="6687004"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, mgorman@suse.de, bcrl@kvack.org,
        viro@zeniv.linux.org.uk
Cc: khlebnikov@openvz.org, walken@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        minchan@kernel.org, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, linux-mm@kvack.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH 0/2] mm: hotplug: implement non-movable version of get_user_pages() to kill long-time pin pages
Date: Mon, 4 Feb 2013 18:04:06 +0800
Message-Id: <1359972248-8722-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/04 18:04:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/04 18:04:15,
	Serialize complete at 2013/02/04 18:04:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently get_user_pages() always tries to allocate pages from movable zone,
as discussed in thread https://lkml.org/lkml/2012/11/29/69, in some case users
of get_user_pages() is easy to pin user pages for a long time(for now we found
that pages pinned as aio ring pages is such case), which is fatal for memory
hotplug/remove framework.

So the 1st patch introduces a new library function called
get_user_pages_non_movable() to pin pages only from zone non-movable in memory.
It's a wrapper of get_user_pages() but it makes sure that all pages come from
non-movable zone via additional page migration.

The 2nd patch gets around the aio ring pages can't be migrated bug caused by
get_user_pages() via using the new function. It only works when configed with
CONFIG_MEMORY_HOTREMOVE, otherwise it uses the old version of get_user_pages().

Lin Feng (2):
  mm: hotplug: implement non-movable version of get_user_pages()
  fs/aio.c: use non-movable version of get_user_pages() to pin ring
    pages when support memory hotremove

 fs/aio.c               |  6 +++++
 include/linux/mm.h     |  5 ++++
 include/linux/mmzone.h |  4 ++++
 mm/memory.c            | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/page_isolation.c    |  5 ++++
 5 files changed, 83 insertions(+)

-- 
1.7.11.7

