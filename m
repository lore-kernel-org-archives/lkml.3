Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab3FKUAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:00:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3FKUAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:00:44 -0400
Date: Tue, 11 Jun 2013 13:00:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v8, part3 10/14] mm: use a dedicated lock to protect
 totalram_pages and zone->managed_pages
Message-Id: <20130611130042.3dec2cc6737f21180bc09bb1@linux-foundation.org>
In-Reply-To: <1369575522-26405-11-git-send-email-jiang.liu@huawei.com>
References: <1369575522-26405-1-git-send-email-jiang.liu@huawei.com>
	<1369575522-26405-11-git-send-email-jiang.liu@huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 May 2013 21:38:38 +0800 Jiang Liu <liuj97@gmail.com> wrote:

> Currently lock_memory_hotplug()/unlock_memory_hotplug() are used to
> protect totalram_pages and zone->managed_pages. Other than the memory
> hotplug driver, totalram_pages and zone->managed_pages may also be
> modified at runtime by other drivers, such as Xen balloon,
> virtio_balloon etc. For those cases, memory hotplug lock is a little
> too heavy, so introduce a dedicated lock to protect totalram_pages
> and zone->managed_pages.
> 
> Now we have a simplified locking rules totalram_pages and
> zone->managed_pages as:
> 1) no locking for read accesses because they are unsigned long.
> 2) no locking for write accesses at boot time in single-threaded context.
> 3) serialize write accesses at runtime by acquiring the dedicated
>    managed_page_count_lock.
> 
> Also adjust zone->managed_pages when freeing reserved pages into the
> buddy system, to keep totalram_pages and zone->managed_pages in
> consistence.
> 
> ...
>
> +void adjust_managed_page_count(struct page *page, long count)
> +{
> +	spin_lock(&managed_page_count_lock);
> +	page_zone(page)->managed_pages += count;
> +	totalram_pages += count;
> +	spin_unlock(&managed_page_count_lock);
> +}
> +EXPORT_SYMBOL(adjust_managed_page_count);

This is exported to modules but there are no modular callers at this
time.

I assume this was done for some forthcoming xen/virtio_balloon/etc
patches?  If so, it would be better to avoid adding the export until it
is actually needed.



