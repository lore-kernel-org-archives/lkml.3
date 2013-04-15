Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847Ab3DOVMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:12:35 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:31639 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab3DOVMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:12:35 -0400
Message-ID: <1366059610.3824.25.camel@misato.fc.hp.com>
Subject: Re: [PATCH] firmware, memmap: fix firmware_map_entry leak
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wency@cn.fujitsu.com, tangchen@cn.fujitsu.com
Date: Mon, 15 Apr 2013 15:00:10 -0600
In-Reply-To: <516B94A1.4040603@jp.fujitsu.com>
References: <516B94A1.4040603@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 14:48 +0900, Yasuaki Ishimatsu wrote:
> When hot removing a memory, a firmware_map_entry which has memory range
> of the memory is released by release_firmware_map_entry(). If the entry
> is allocated by bootmem, release_firmware_map_entry() adds the entry to
> map_entires_bootmem list when firmware_map_find_entry() finds the entry
> from map_entries list. But firmware_map_find_entry never find the entry
> sicne map_entires list does not have the entry. So the entry just leaks.
> 
> Here are steps of leaking firmware_map_entry:
> firmware_map_remove()
> -> firmware_map_find_entry()
>    Find released entry from map_entries list
> -> firmware_map_remove_entry()
>    Delete the entry from map_entries list
> -> remove_sysfs_fw_map_entry()
>    ...
>    -> release_firmware_map_entry()
>       -> firmware_map_find_entry()
>          Find the entry from map_entries list but the entry has been
>          deleted from map_entries list. So the entry is not added
>          to map_entries_bootmem. Thus the entry leaks
> 
> release_firmware_map_entry() should not call firmware_map_find_entry()
> since releaed entry has been deleted from map_entries list.
> So the patch delete firmware_map_find_entry() from releae_firmware_map_entry()
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


> ---
>  drivers/firmware/memmap.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
> index 0b5b5f6..e2e04b0 100644
> --- a/drivers/firmware/memmap.c
> +++ b/drivers/firmware/memmap.c
> @@ -114,12 +114,9 @@ static void __meminit release_firmware_map_entry(struct kobject *kobj)
>  		 * map_entries_bootmem here, and deleted from &map_entries in
>  		 * firmware_map_remove_entry().
>  		 */
> -		if (firmware_map_find_entry(entry->start, entry->end,
> -		    entry->type)) {
> -			spin_lock(&map_entries_bootmem_lock);
> -			list_add(&entry->list, &map_entries_bootmem);
> -			spin_unlock(&map_entries_bootmem_lock);
> -		}
> +		spin_lock(&map_entries_bootmem_lock);
> +		list_add(&entry->list, &map_entries_bootmem);
> +		spin_unlock(&map_entries_bootmem_lock);
>  
>  		return;
>  	}
> 


