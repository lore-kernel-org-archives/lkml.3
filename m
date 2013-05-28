Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292Ab3E1OVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:21:08 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56812 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933972Ab3E1OVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:21:04 -0400
Message-ID: <51A4BD38.2040302@gmail.com>
Date: Tue, 28 May 2013 22:20:40 +0800
From: Liu Jiang <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
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
References: <1369575522-26405-1-git-send-email-jiang.liu@huawei.com> <1369575522-26405-13-git-send-email-jiang.liu@huawei.com> <51A36633.2030905@cogentembedded.com>
In-Reply-To: <51A36633.2030905@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,
	Thanks for review!

On 05/27/2013 09:57 PM, Sergei Shtylyov wrote:
> On 26-05-2013 17:38, Jiang Liu wrote:
> 
>    Typo in the subject: s/mamaged_pages/managed_pages/.
Will fix it in next version.

> 
>> Enhance adjust_managed_page_count() to adjust totalhigh_pages for
>> highmem pages. And change code which directly adjusts totalram_pages
>> to use adjust_managed_page_count() because it adjusts totalram_pages,
>> totalhigh_pages and zone->managed_pages altogether in a safe way.
> 
>> Remove inc_totalhigh_pages() and dec_totalhigh_pages() from xen/balloon
>> driver bacause adjust_managed_page_count() has already adjusted
>> totalhigh_pages.
> 
>> This patch also fixes two bugs:
>> 1) enhances virtio_balloon driver to adjust totalhigh_pages when
>>     reserve/unreserve pages.
>> 2) enhance memory_hotplug.c to adjust totalhigh_pages when hot-removing
>>     memory.
> 
>> We still need to deal with modifications of totalram_pages in file
>> arch/powerpc/platforms/pseries/cmm.c, but need help from PPC experts.
> 
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Chris Metcalf <cmetcalf@tilera.com>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>> Cc: Wen Congyang <wency@cn.fujitsu.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Tang Chen <tangchen@cn.fujitsu.com>
>> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Minchan Kim <minchan@kernel.org>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: virtualization@lists.linux-foundation.org
>> Cc: xen-devel@lists.xensource.com
>> Cc: linux-mm@kvack.org
>> ---
>>   drivers/virtio/virtio_balloon.c |  8 +++++---
>>   drivers/xen/balloon.c           | 23 +++++------------------
>>   mm/hugetlb.c                    |  2 +-
>>   mm/memory_hotplug.c             | 16 +++-------------
>>   mm/page_alloc.c                 | 10 +++++-----
>>   5 files changed, 19 insertions(+), 40 deletions(-)
> 
>> diff --git a/drivers/virtio/virtio_balloon.c
>> b/drivers/virtio/virtio_balloon.c
>> index bd3ae32..6649968 100644
>> --- a/drivers/virtio/virtio_balloon.c
>> +++ b/drivers/virtio/virtio_balloon.c
> [...]
>> @@ -160,11 +160,13 @@ static void fill_balloon(struct virtio_balloon
>> *vb, size_t num)
>>   static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
>>   {
>>       unsigned int i;
>> +    struct page *page;
> 
>    Why not declare it right in the *for* loop? You could use intializer
> then...
Good suggestion, will change it in next version.

> 
>>
>>       /* Find pfns pointing at start of each page, get pages and free
>> them. */
>>       for (i = 0; i < num; i += VIRTIO_BALLOON_PAGES_PER_PAGE) {
>> -        balloon_page_free(balloon_pfn_to_page(pfns[i]));
>> -        totalram_pages++;
>> +        page = balloon_pfn_to_page(pfns[i]);
>> +        balloon_page_free(page);
>> +        adjust_managed_page_count(page, 1);
>>       }
>>   }
>>
> [...]
> 
> WBR, Sergei
> 

