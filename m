Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3DOHYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:24:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56694 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3DOHY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:24:29 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <516BAB16.4070501@jp.fujitsu.com>
Date: Mon, 15 Apr 2013 16:24:06 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <wency@cn.fujitsu.com>,
        <tangchen@cn.fujitsu.com>, <toshi.kani@hp.com>
Subject: Re: [PATCH] firmware, memmap: fix firmware_map_entry leak
References: <516B94A1.4040603@jp.fujitsu.com> <20130415070415.GA16757@hacker.(null)>
In-Reply-To: <20130415070415.GA16757@hacker.(null)>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/04/15 16:04, Wanpeng Li wrote:
> On Mon, Apr 15, 2013 at 02:48:17PM +0900, Yasuaki Ishimatsu wrote:
>> When hot removing a memory, a firmware_map_entry which has memory range
>> of the memory is released by release_firmware_map_entry(). If the entry
>> is allocated by bootmem, release_firmware_map_entry() adds the entry to
>> map_entires_bootmem list when firmware_map_find_entry() finds the entry
>>from map_entries list. But firmware_map_find_entry never find the entry
>> sicne map_entires list does not have the entry. So the entry just leaks.
>>
>> Here are steps of leaking firmware_map_entry:
>> firmware_map_remove()
>> -> firmware_map_find_entry()
>>    Find released entry from map_entries list
>> -> firmware_map_remove_entry()
>>    Delete the entry from map_entries list
>> -> remove_sysfs_fw_map_entry()
>>    ...
>>    -> release_firmware_map_entry()
>>       -> firmware_map_find_entry()
>>          Find the entry from map_entries list but the entry has been
>>          deleted from map_entries list. So the entry is not added
>>          to map_entries_bootmem. Thus the entry leaks
>>
>> release_firmware_map_entry() should not call firmware_map_find_entry()
>> since releaed entry has been deleted from map_entries list.
>> So the patch delete firmware_map_find_entry() from releae_firmware_map_entry()
>>
>
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Thank you for your review.

Thanks,
Yasuaki Ishimatsu

>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> ---
>> drivers/firmware/memmap.c |    9 +++------
>> 1 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
>> index 0b5b5f6..e2e04b0 100644
>> --- a/drivers/firmware/memmap.c
>> +++ b/drivers/firmware/memmap.c
>> @@ -114,12 +114,9 @@ static void __meminit release_firmware_map_entry(struct kobject *kobj)
>> 		 * map_entries_bootmem here, and deleted from &map_entries in
>> 		 * firmware_map_remove_entry().
>> 		 */
>> -		if (firmware_map_find_entry(entry->start, entry->end,
>> -		    entry->type)) {
>> -			spin_lock(&map_entries_bootmem_lock);
>> -			list_add(&entry->list, &map_entries_bootmem);
>> -			spin_unlock(&map_entries_bootmem_lock);
>> -		}
>> +		spin_lock(&map_entries_bootmem_lock);
>> +		list_add(&entry->list, &map_entries_bootmem);
>> +		spin_unlock(&map_entries_bootmem_lock);
>>
>> 		return;
>> 	}
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>


