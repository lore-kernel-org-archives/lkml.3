Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab3E0N5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:57:15 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:33105 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab3E0N5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:57:12 -0400
Message-ID: <51A36633.2030905@cogentembedded.com>
Date: Mon, 27 May 2013 17:57:07 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH v8, part3 12/14] mm: correctly update zone->mamaged_pages
References: <1369575522-26405-1-git-send-email-jiang.liu@huawei.com> <1369575522-26405-13-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1369575522-26405-13-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26-05-2013 17:38, Jiang Liu wrote:

    Typo in the subject: s/mamaged_pages/managed_pages/.

> Enhance adjust_managed_page_count() to adjust totalhigh_pages for
> highmem pages. And change code which directly adjusts totalram_pages
> to use adjust_managed_page_count() because it adjusts totalram_pages,
> totalhigh_pages and zone->managed_pages altogether in a safe way.

> Remove inc_totalhigh_pages() and dec_totalhigh_pages() from xen/balloon
> driver bacause adjust_managed_page_count() has already adjusted
> totalhigh_pages.

> This patch also fixes two bugs:
> 1) enhances virtio_balloon driver to adjust totalhigh_pages when
>     reserve/unreserve pages.
> 2) enhance memory_hotplug.c to adjust totalhigh_pages when hot-removing
>     memory.

> We still need to deal with modifications of totalram_pages in file
> arch/powerpc/platforms/pseries/cmm.c, but need help from PPC experts.

> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Wen Congyang <wency@cn.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tang Chen <tangchen@cn.fujitsu.com>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: xen-devel@lists.xensource.com
> Cc: linux-mm@kvack.org
> ---
>   drivers/virtio/virtio_balloon.c |  8 +++++---
>   drivers/xen/balloon.c           | 23 +++++------------------
>   mm/hugetlb.c                    |  2 +-
>   mm/memory_hotplug.c             | 16 +++-------------
>   mm/page_alloc.c                 | 10 +++++-----
>   5 files changed, 19 insertions(+), 40 deletions(-)

> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index bd3ae32..6649968 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
[...]
> @@ -160,11 +160,13 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
>   static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
>   {
>   	unsigned int i;
> +	struct page *page;

    Why not declare it right in the *for* loop? You could use intializer 
then...

>
>   	/* Find pfns pointing at start of each page, get pages and free them. */
>   	for (i = 0; i < num; i += VIRTIO_BALLOON_PAGES_PER_PAGE) {
> -		balloon_page_free(balloon_pfn_to_page(pfns[i]));
> -		totalram_pages++;
> +		page = balloon_pfn_to_page(pfns[i]);
> +		balloon_page_free(page);
> +		adjust_managed_page_count(page, 1);
>   	}
>   }
>
[...]

WBR, Sergei

