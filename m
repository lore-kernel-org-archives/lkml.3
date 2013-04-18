Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967160Ab3DROfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:35:47 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:35686 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965239Ab3DROfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:35:46 -0400
Message-ID: <1366295000.3824.47.camel@misato.fc.hp.com>
Subject: Re: [Bug fix PATCH v4] Reusing a resource structure allocated by
 bootmem
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 18 Apr 2013 08:23:20 -0600
In-Reply-To: <516FB07C.9010603@jp.fujitsu.com>
References: <516FB07C.9010603@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-18 at 17:36 +0900, Yasuaki Ishimatsu wrote:
> When hot removing memory presented at boot time, following messages are shown:
 :
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 4aef886..637e8d2 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -21,6 +21,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/device.h>
>  #include <linux/pfn.h>
> +#include <linux/mm.h>
>  #include <asm/io.h>
>  
> 
> @@ -50,6 +51,16 @@ struct resource_constraint {
>  
>  static DEFINE_RWLOCK(resource_lock);
>  
> +/*
> + * For memory hotplug, there is no way to free resource entries allocated
> + * by boot mem after the system is up. So for reusing the resource entry
> + * we need to remember the resource.
> + */
> +struct resource bootmem_resource = {
> +	.sibling = NULL,
> +};

This should be a pointer of struct resource and declared as static, such
as:

static struct resource *bootmem_resource_free;

> +static DEFINE_SPINLOCK(bootmem_resource_lock);
> +
>  static void *r_next(struct seq_file *m, void *v, loff_t *pos)
>  {
>  	struct resource *p = v;
> @@ -151,6 +162,39 @@ __initcall(ioresources_init);
>  
>  #endif /* CONFIG_PROC_FS */
>  
> +static void free_resource(struct resource *res)
> +{
> +	if (!res)
> +		return;
> +
> +	if (PageSlab(virt_to_head_page(res))) {
> +		spin_lock(&bootmem_resource_lock);
> +		res->sibling = bootmem_resource.sibling;
> +		bootmem_resource.sibling = res;
> +		spin_unlock(&bootmem_resource_lock);
> +	} else {
> +		kfree(res);
> +	}
> +}

I second with Johannes.

> +static struct resource *get_resource(gfp_t flags)
> +{
> +	struct resource *res = NULL;
> +
> +	spin_lock(&bootmem_resource_lock);
> +	if (bootmem_resource.sibling) {
> +		res = bootmem_resource.sibling;
> +		bootmem_resource.sibling = res->sibling;
> +		memset(res, 0, sizeof(struct resource));
> +	}
> +	spin_unlock(&bootmem_resource_lock);

I prefer to keep memset() outside of the spin lock.

spin_lock(&bootmem_resource_lock);
if (..) {
	:
	spin_unlock(&bootmem_resource_lock);
	memset(res, 0, sizeof(struct resource));
} else {
	spin_unlock(&bootmem_resource_lock);
	res = kzalloc(sizeof(struct resource), flags);
}

Thanks,
-Toshi

> +
> +	if (!res)
> +		res = kzalloc(sizeof(struct resource), flags);
> +
> +	return res;
> +}
> +


