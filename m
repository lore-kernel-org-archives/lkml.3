Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaFXXUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:20:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaFXXUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:20:54 -0400
Date: Tue, 24 Jun 2014 16:20:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH -mm 3/3] page-cgroup: fix flags definition
Message-Id: <20140624162052.6778a13e3b3f4af251e300e7@linux-foundation.org>
In-Reply-To: <aacc50fb60eeb9cbe14e07235310fb9295b2658b.1403626729.git.vdavydov@parallels.com>
References: <9f5abf8dcb07fe5462f12f81867f199c22e883d3.1403626729.git.vdavydov@parallels.com>
	<aacc50fb60eeb9cbe14e07235310fb9295b2658b.1403626729.git.vdavydov@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014 20:33:06 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> Since commit a9ce315aaec1f ("mm: memcontrol: rewrite uncharge API"),
> PCG_* flags are used as bit masks, but they are still defined in a enum
> as bit numbers. Fix it.
> 
> ...
>
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -1,12 +1,10 @@
>  #ifndef __LINUX_PAGE_CGROUP_H
>  #define __LINUX_PAGE_CGROUP_H
>  
> -enum {
> -	/* flags for mem_cgroup */
> -	PCG_USED,	/* This page is charged to a memcg */
> -	PCG_MEM,	/* This page holds a memory charge */
> -	PCG_MEMSW,	/* This page holds a memory+swap charge */
> -};
> +/* flags for mem_cgroup */
> +#define PCG_USED	0x01	/* This page is charged to a memcg */
> +#define PCG_MEM		0x02	/* This page holds a memory charge */
> +#define PCG_MEMSW	0x04	/* This page holds a memory+swap charge */
>  
>  struct pglist_data;
>  
> @@ -44,7 +42,7 @@ struct page *lookup_cgroup_page(struct page_cgroup *pc);
>  
>  static inline int PageCgroupUsed(struct page_cgroup *pc)
>  {
> -	return test_bit(PCG_USED, &pc->flags);
> +	return !!(pc->flags & PCG_USED);
>  }
>  #else /* !CONFIG_MEMCG */
>  struct page_cgroup;

hm, yes, whoops.  I think I'll redo this as a fix against
mm-memcontrol-rewrite-uncharge-api.patch:

--- a/include/linux/page_cgroup.h~page-cgroup-fix-flags-definition
+++ a/include/linux/page_cgroup.h
@@ -3,9 +3,9 @@
 
 enum {
 	/* flags for mem_cgroup */
-	PCG_USED,	/* This page is charged to a memcg */
-	PCG_MEM,	/* This page holds a memory charge */
-	PCG_MEMSW,	/* This page holds a memory+swap charge */
+	PCG_USED = 0x01,	/* This page is charged to a memcg */
+	PCG_MEM = 0x02,		/* This page holds a memory charge */
+	PCG_MEMSW = 0x04,	/* This page holds a memory+swap charge */
 	__NR_PCG_FLAGS,
 };
 
@@ -46,7 +46,7 @@ struct page *lookup_cgroup_page(struct p
 
 static inline int PageCgroupUsed(struct page_cgroup *pc)
 {
-	return test_bit(PCG_USED, &pc->flags);
+	return !!(pc->flags & PCG_USED);
 }
 
 #else /* CONFIG_MEMCG */
_

