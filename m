Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936730Ab3DRXdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 19:33:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36877 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936645Ab3DRXdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 19:33:40 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <517082B9.7050708@jp.fujitsu.com>
Date: Fri, 19 Apr 2013 08:33:13 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <linuxram@us.ibm.com>, <rientjes@google.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [Bug fix PATCH v4] Reusing a resource structure allocated by
 bootmem
References: <516FB07C.9010603@jp.fujitsu.com> <1366295000.3824.47.camel@misato.fc.hp.com>
In-Reply-To: <1366295000.3824.47.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

2013/04/18 23:23, Toshi Kani wrote:
> On Thu, 2013-04-18 at 17:36 +0900, Yasuaki Ishimatsu wrote:
>> When hot removing memory presented at boot time, following messages are shown:
>   :
>> diff --git a/kernel/resource.c b/kernel/resource.c
>> index 4aef886..637e8d2 100644
>> --- a/kernel/resource.c
>> +++ b/kernel/resource.c
>> @@ -21,6 +21,7 @@
>>   #include <linux/seq_file.h>
>>   #include <linux/device.h>
>>   #include <linux/pfn.h>
>> +#include <linux/mm.h>
>>   #include <asm/io.h>
>>
>>
>> @@ -50,6 +51,16 @@ struct resource_constraint {
>>
>>   static DEFINE_RWLOCK(resource_lock);
>>
>> +/*
>> + * For memory hotplug, there is no way to free resource entries allocated
>> + * by boot mem after the system is up. So for reusing the resource entry
>> + * we need to remember the resource.
>> + */
>> +struct resource bootmem_resource = {
>> +	.sibling = NULL,
>> +};
>

> This should be a pointer of struct resource and declared as static, such
> as:
>
> static struct resource *bootmem_resource_free;

O.K. I'll update it.

>
>> +static DEFINE_SPINLOCK(bootmem_resource_lock);
>> +
>>   static void *r_next(struct seq_file *m, void *v, loff_t *pos)
>>   {
>>   	struct resource *p = v;
>> @@ -151,6 +162,39 @@ __initcall(ioresources_init);
>>
>>   #endif /* CONFIG_PROC_FS */
>>
>> +static void free_resource(struct resource *res)
>> +{
>> +	if (!res)
>> +		return;
>> +
>> +	if (PageSlab(virt_to_head_page(res))) {
>> +		spin_lock(&bootmem_resource_lock);
>> +		res->sibling = bootmem_resource.sibling;
>> +		bootmem_resource.sibling = res;
>> +		spin_unlock(&bootmem_resource_lock);
>> +	} else {
>> +		kfree(res);
>> +	}
>> +}
>

> I second with Johannes.

I'll update it.

>
>> +static struct resource *get_resource(gfp_t flags)
>> +{
>> +	struct resource *res = NULL;
>> +
>> +	spin_lock(&bootmem_resource_lock);
>> +	if (bootmem_resource.sibling) {
>> +		res = bootmem_resource.sibling;
>> +		bootmem_resource.sibling = res->sibling;
>> +		memset(res, 0, sizeof(struct resource));
>> +	}
>> +	spin_unlock(&bootmem_resource_lock);
>

> I prefer to keep memset() outside of the spin lock.
>
> spin_lock(&bootmem_resource_lock);
> if (..) {
> 	:
> 	spin_unlock(&bootmem_resource_lock);
> 	memset(res, 0, sizeof(struct resource));
> } else {
> 	spin_unlock(&bootmem_resource_lock);
> 	res = kzalloc(sizeof(struct resource), flags);
> }

Hmm. It is a little ugly. How about it?

spin_lock(&bootmem_resource_lock);
if (bootmem_resource.sibling) {
	res = bootmem_resource.sibling;
	bootmem_resource.sibling = res->sibling;
}
spin_unlock(&bootmem_resource_lock);

if (res)
	memset(res, 0, sizeof(struct resource));
else	
	res = kzalloc(sizeof(struct resource), flags);

Thanks,
Yasuaki Ishimatsu

>
> Thanks,
> -Toshi
>
>> +
>> +
>> +	return res;
>> +}
>> +
>
>


