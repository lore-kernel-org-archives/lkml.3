Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab3EHPu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:50:57 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63718 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab3EHPuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:50:55 -0400
Message-ID: <518A7457.9090400@gmail.com>
Date: Wed, 08 May 2013 23:50:47 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH v5, part3 11/15] mm: use a dedicated lock to protect totalram_pages
 and zone->managed_pages
References: <1368026235-5976-1-git-send-email-jiang.liu@huawei.com> <1368026235-5976-12-git-send-email-jiang.liu@huawei.com> <518A6EEC.6060102@redhat.com>
In-Reply-To: <518A6EEC.6060102@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 11:27 PM, Rik van Riel wrote:
> On 05/08/2013 11:17 AM, Jiang Liu wrote:
> 
>> @@ -5186,6 +5189,15 @@ early_param("movablecore", cmdline_parse_movablecore);
>>
>>   #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
>>
>> +void adjust_managed_page_count(struct page *page, long count)
>> +{
>> +    spin_lock(&managed_page_count_lock);
>> +    page_zone(page)->managed_pages += count;
>> +    totalram_pages += count;
>> +    spin_unlock(&managed_page_count_lock);
>> +}
>> +EXPORT_SYMBOL(adjust_managed_page_count);
>> +
> 
> Something I should have thought of when I reviewed the patch
> last time, but forgot...
> 
> What happens when the hotplug event adds more pages than fit
> in this zone, and some of the pages should go in the next
> zone?
> 
> For example, think about a 3GB x86_64 machine, which gets
> 2GB of memory hot-added. Roughly half may get added to the
> DMA32 zone, the rest to the NORMAL zone.
> 
> Do the callers of adjust_managed_page_count correctly make
> one call for each zone, or does the above code open up a
> window for a bug?
Hi Rik,
	Thanks for review! 
	Yes, the caller will make one call for each zone. Actually it will
call adjust_managed_page_count() for each page.
	Regards!
	Gerry
