Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab3CRCUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:20:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55379 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3CRCUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:20:40 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <514679BC.5020700@jp.fujitsu.com>
Date: Mon, 18 Mar 2013 11:19:40 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>, <tangchen@cn.fujitsu.com>,
        <wency@cn.fujitsu.com>, <laijs@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove acpi_memory_info->failed bit
References: <514022BF.3080303@jp.fujitsu.com> <1363186213.12845.174.camel@misato.fc.hp.com>
In-Reply-To: <1363186213.12845.174.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

Sorry for the late reply

2013/03/13 23:50, Toshi Kani wrote:
> On Wed, 2013-03-13 at 15:54 +0900, Yasuaki Ishimatsu wrote:
>> At http://marc.info/?l=linux-acpi&m=135769405622667&w=2 thread,
>> Toshi Kani mentioned as follows:
>>
>> "I have a question about the change you made in commit 65479472 in
>> acpi_memhotplug.c.  This change seems to require that
>> acpi_memory_enable_device() calls add_memory() to add all memory ranges
>> represented by memory device objects at boot-time, and keep the results
>> be used for hot-remove.
>>
>> If I understand it right, this add_memory() call fails with EEXIST at
>> boot-time since all memory ranges should have been added from EFI memory
>> table (or e820) already.  This results all memory ranges be marked as !
>> enabled & !failed.  I think this means that we cannot hot-delete any
>> memory ranges presented at boot-time since acpi_memory_remove_memory()
>> only calls remove_memory() when the enabled flag is set.  Is that
>> correct?"
>>
>> Above mention is correct. Thus even if memory device supports hotplug,
>> memory presented at boot-time cannot be hot removed since the memory
>> device's acpi_memory_info->enabled is always 0.
>>
>> This patch changes to set 1 to "acpi_memory_info->enabled" of memory
>> device presented at boot-time for hot removing the memory device.
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> ---
>>   drivers/acpi/acpi_memhotplug.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
>> index da1f82b..88fd46a 100644
>> --- a/drivers/acpi/acpi_memhotplug.c
>> +++ b/drivers/acpi/acpi_memhotplug.c
>> @@ -254,8 +254,8 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>>   			continue;
>>   		}
>>
>> -		if (!result)
>> -			info->enabled = 1;
>> +		info->enabled = 1;
>
> Do we still need to keep the enable bit?  I think !failed means enabled
> with this change.

For controlling memory hotplug, we need either failed bit or enabled bit.
So I want to remove failed bit as follows:

---

acpi_memory_info has enabled bit and failed bit for controlling memory
hotplug. But we don't need to keep both bits.

The patch removes acpi_memory_info->failed bit.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
  drivers/acpi/acpi_memhotplug.c |   15 ++-------------
  1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 88fd46a..cf4e1cf 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -79,7 +79,6 @@ struct acpi_memory_info {
  	unsigned short caching;	/* memory cache attribute */
  	unsigned short write_protect;	/* memory read/write attribute */
  	unsigned int enabled:1;
-	unsigned int failed:1;
  };
  
  struct acpi_memory_device {
@@ -249,10 +248,8 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
  		 * returns -EEXIST. If add_memory() returns the other error, it
  		 * means that this memory block is not used by the kernel.
  		 */
-		if (result && result != -EEXIST) {
-			info->failed = 1;
+		if (result && result != -EEXIST)
  			continue;
-		}
  
  		info->enabled = 1;
  
@@ -286,16 +283,8 @@ static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
  	nid = acpi_get_node(mem_device->device->handle);
  
  	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
-		if (info->failed)
-			/* The kernel does not use this memory block */
-			continue;
-
  		if (!info->enabled)
-			/*
-			 * The kernel uses this memory block, but it may be not
-			 * managed by us.
-			 */
-			return -EBUSY;
+			continue;
  
  		if (nid < 0)
  			nid = memory_add_physaddr_to_nid(info->start_addr);

