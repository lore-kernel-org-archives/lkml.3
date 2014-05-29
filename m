Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbaE2NRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:17:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54417 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388AbaE2NRZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:17:25 -0400
References: <1401344554-3596-1-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1401344554-3596-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <7534A26C-36BC-455C-94DE-CA1234CE1803@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
X-Mailer: iPad Mail (10B146)
From: Richard Yao <ryao@gentoo.org>
Subject: Re: [PATCH] vmalloc: use rcu list iterator to reduce vmap_area_lock contention
Date: Thu, 29 May 2014 09:17:22 -0400
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not have a way of tracing it. I meant to reply when I did, but that has not changed. That being said, I like this patch.

On May 29, 2014, at 2:22 AM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> Richard Yao reported a month ago that his system have a trouble
> with vmap_area_lock contention during performance analysis
> by /proc/meminfo. Andrew asked why his analysis checks /proc/meminfo
> stressfully, but he didn't answer it.
> 
> https://lkml.org/lkml/2014/4/10/416
> 
> Although I'm not sure that this is right usage or not, there is a solution
> reducing vmap_area_lock contention with no side-effect. That is just
> to use rcu list iterator in get_vmalloc_info(). This function only needs
> values on vmap_area structure, so we don't need to grab a spinlock.
> 
> Reported-by: Richard Yao <ryao@gentoo.org>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index f64632b..fdbb116 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2690,14 +2690,14 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
> 
>    prev_end = VMALLOC_START;
> 
> -    spin_lock(&vmap_area_lock);
> +    rcu_read_lock();
> 
>    if (list_empty(&vmap_area_list)) {
>        vmi->largest_chunk = VMALLOC_TOTAL;
>        goto out;
>    }
> 
> -    list_for_each_entry(va, &vmap_area_list, list) {
> +    list_for_each_entry_rcu(va, &vmap_area_list, list) {
>        unsigned long addr = va->va_start;
> 
>        /*
> @@ -2724,7 +2724,7 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
>        vmi->largest_chunk = VMALLOC_END - prev_end;
> 
> out:
> -    spin_unlock(&vmap_area_lock);
> +    rcu_read_unlock();
> }
> #endif
> 
> -- 
> 1.7.9.5
> 
