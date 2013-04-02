Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab3DBOjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:39:07 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49966 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab3DBOjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:39:03 -0400
Message-ID: <515AED78.7000909@gmail.com>
Date: Tue, 02 Apr 2013 22:38:48 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux@openrisc.net
Subject: Re: [PATCH v3, part4 26/39] mm/openrisc: prepare for removing num_physpages
 and simplify mem_init()
References: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com> <1364313298-17336-27-git-send-email-jiang.liu@huawei.com> <515A6D40.90702@southpole.se>
In-Reply-To: <515A6D40.90702@southpole.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonas,
	Thanks for testing.
	Regards!
	Gerry
On 04/02/2013 01:31 PM, Jonas Bonn wrote:
> On 03/26/2013 04:54 PM, Jiang Liu wrote:
>> Prepare for removing num_physpages and simplify mem_init().
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Jonas Bonn <jonas@southpole.se>
>> Cc: David Howells <dhowells@redhat.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: linux@lists.openrisc.net
>> Cc: linux-kernel@vger.kernel.org
> 
> Tested and works fine on OpenRISC.
> 
> Acked-by: Jonas Bonn <jonas@southpole.se>
> 
> /Jonas
> 
>> ---
>> Hi all,
>>     Sorry for my mistake that my previous patch series has been screwed up.
>> So I regenerate a third version and also set up a git tree at:
>>     git://github.com/jiangliu/linux.git mem_init
>>     Any help to review and test are welcomed!
>>
>>     Regards!
>>     Gerry
>> ---
>>   arch/openrisc/mm/init.c |   44 ++++----------------------------------------
>>   1 file changed, 4 insertions(+), 40 deletions(-)
>>
>> diff --git a/arch/openrisc/mm/init.c b/arch/openrisc/mm/init.c
>> index 71d6b40..f3c8f47 100644
>> --- a/arch/openrisc/mm/init.c
>> +++ b/arch/openrisc/mm/init.c
>> @@ -191,56 +191,20 @@ void __init paging_init(void)
>>     /* References to section boundaries */
>>   -static int __init free_pages_init(void)
>> -{
>> -    int reservedpages, pfn;
>> -
>> -    /* this will put all low memory onto the freelists */
>> -    free_all_bootmem();
>> -
>> -    reservedpages = 0;
>> -    for (pfn = 0; pfn < max_low_pfn; pfn++) {
>> -        /*
>> -         * Only count reserved RAM pages
>> -         */
>> -        if (PageReserved(mem_map + pfn))
>> -            reservedpages++;
>> -    }
>> -
>> -    return reservedpages;
>> -}
>> -
>> -static void __init set_max_mapnr_init(void)
>> -{
>> -    max_mapnr = num_physpages = max_low_pfn;
>> -}
>> -
>>   void __init mem_init(void)
>>   {
>> -    int codesize, reservedpages, datasize, initsize;
>> -
>>       BUG_ON(!mem_map);
>>   -    set_max_mapnr_init();
>> -
>> +    max_mapnr = max_low_pfn;
>>       high_memory = (void *)__va(max_low_pfn * PAGE_SIZE);
>>         /* clear the zero-page */
>>       memset((void *)empty_zero_page, 0, PAGE_SIZE);
>>   -    reservedpages = free_pages_init();
>> -
>> -    codesize = (unsigned long)&_etext - (unsigned long)&_stext;
>> -    datasize = (unsigned long)&_edata - (unsigned long)&_etext;
>> -    initsize = (unsigned long)&__init_end - (unsigned long)&__init_begin;
>> +    /* this will put all low memory onto the freelists */
>> +    free_all_bootmem();
>>   -    printk(KERN_INFO
>> -           "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, %dk init, %ldk highmem)\n",
>> -           (unsigned long)nr_free_pages() << (PAGE_SHIFT - 10),
>> -           max_mapnr << (PAGE_SHIFT - 10), codesize >> 10,
>> -           reservedpages << (PAGE_SHIFT - 10), datasize >> 10,
>> -           initsize >> 10, (unsigned long)(0 << (PAGE_SHIFT - 10))
>> -        );
>> +    mem_init_print_info(NULL);
>>         printk("mem_init_done ...........................................\n");
>>       mem_init_done = 1;
> 
> 

