Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab3FQCNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 22:13:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33080 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab3FQCNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 22:13:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,877,1363104000"; 
   d="scan'208";a="7570881"
Message-ID: <51BE6F61.6010108@cn.fujitsu.com>
Date: Mon, 17 Jun 2013 10:07:29 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jianguo Wu <wujianguo@huawei.com>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Part3 PATCH v2 0/4] Support hot-remove local pagetable pages.
References: <1371128636-9027-1-git-send-email-tangchen@cn.fujitsu.com> <51BE6D47.9020805@huawei.com>
In-Reply-To: <51BE6D47.9020805@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/17 10:02:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/17 10:11:43,
	Serialize complete at 2013/06/17 10:11:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 09:58 AM, Jianguo Wu wrote:
> Hi Tang,
>
> On 2013/6/13 21:03, Tang Chen wrote:
>
>> The following patch-set from Yinghai allocates pagetables to local nodes.
>> v1: https://lkml.org/lkml/2013/3/7/642
>> v2: https://lkml.org/lkml/2013/3/10/47
>> v3: https://lkml.org/lkml/2013/4/4/639
>> v4: https://lkml.org/lkml/2013/4/11/829
>>
>> Since pagetable pages are used by the kernel, they cannot be offlined.
>> As a result, they cannot be hot-remove.
>>
>> This patch fix this problem with the following solution:
>>
>>       1.   Introduce a new bootmem type LOCAL_NODE_DATAL, and register local
>>            pagetable pages as LOCAL_NODE_DATAL by setting page->lru.next to
>>            LOCAL_NODE_DATAL, just like we register SECTION_INFO pages.
>>
>>       2.   Skip LOCAL_NODE_DATAL pages in offline/online procedures. When the
>>            whole memory block they reside in is offlined, the kernel can
>>            still access the pagetables.
>>            (This changes the semantics of offline/online a little bit.)
>>
>>       3.   Do not free LOCAL_NODE_DATAL pages to buddy system because they
>>            were skipped when in offline/online procedures. The memory block
>>            they reside in could have been offlined.
>>
>
> s/LOCAL_NODE_DATAL/LOCAL_NODE_DATA

Oh...thank you. Will send a new version soon. :)

>
>> Anyway, this problem should be fixed. Any better idea is welcome.
>>
>> Change log:
>> v1 ->  v2:
>>          patch2: As suggested by Wu Jianguo, define a macro to check if a page
>>                  cantains local node data.
>>          patch4: As suggested by Wu Jianguo, prevent freeing LOCAL_NODE_DATA
>>                  pages in free_pagetable() instead of in put_page_bootmem().
>>
>> Tang Chen (4):
>>    bootmem, mem-hotplug: Register local pagetable pages with
>>      LOCAL_NODE_DATA when freeing bootmem.
>>    mem-hotplug: Skip LOCAL_NODE_DATA pages in memory offline procedure.
>>    mem-hotplug: Skip LOCAL_NODE_DATA pages in memory online procedure.
>>    mem-hotplug: Do not free LOCAL_NODE_DATA pages to buddy system in
>>      hot-remove procedure.
>>
>>   arch/x86/mm/init_64.c          |   10 +++++++-
>>   include/linux/memblock.h       |   22 +++++++++++++++++
>>   include/linux/memory_hotplug.h |   20 +++++++++++++--
>>   mm/memblock.c                  |   52 ++++++++++++++++++++++++++++++++++++++++
>>   mm/memory_hotplug.c            |   31 +++++++++++++++++++++++
>>   mm/page_alloc.c                |   15 ++++++++++-
>>   mm/page_isolation.c            |    5 ++++
>>   7 files changed, 149 insertions(+), 6 deletions(-)
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>
>>
>> .
>>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
