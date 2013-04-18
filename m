Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936674Ab3DRXWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 19:22:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44095 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936608Ab3DRXWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 19:22:10 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51708000.4060106@jp.fujitsu.com>
Date: Fri, 19 Apr 2013 08:21:36 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: <akpm@linux-foundation.org>, <toshi.kani@hp.com>, <linuxram@us.ibm.com>,
        <rientjes@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [Bug fix PATCH v4] Reusing a resource structure allocated by
 bootmem
References: <516FB07C.9010603@jp.fujitsu.com> <20130418134206.GB21444@cmpxchg.org>
In-Reply-To: <20130418134206.GB21444@cmpxchg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/04/18 22:42, Johannes Weiner wrote:
> On Thu, Apr 18, 2013 at 05:36:12PM +0900, Yasuaki Ishimatsu wrote:
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
>

> The branch is mixed up, you are collecting slab objects in
> bootmem_resource and kfreeing bootmem.

Ah. I'm wrong. I'll update soon.

Thanks,
Yasuaki Ishimatsu

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
>> +
>> +	if (!res)
>> +		res = kzalloc(sizeof(struct resource), flags);
>> +
>> +	return res;
>> +}
>> +
>>   /* Return the conflict entry if you can't request it */
>>   static struct resource * __request_resource(struct resource *root, struct resource *new)
>>   {


