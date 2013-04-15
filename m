Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3DOUN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:13:59 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:42239 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3DOUN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:13:58 -0400
Message-ID: <1366056094.3824.22.camel@misato.fc.hp.com>
Subject: Re: [Bug fix PATCH] resource: Reusing a resource structure
 allocated by bootmem
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, linuxram@us.ibm.com
Date: Mon, 15 Apr 2013 14:01:34 -0600
In-Reply-To: <516B62C0.70504@jp.fujitsu.com>
References: <516B62C0.70504@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 11:15 +0900, Yasuaki Ishimatsu wrote:
> When hot removing memory presented at boot time, following messages are shown:

:

> The reason why the messages are shown is to release a resource structure,
> allocated by bootmem, by kfree(). So when we release a resource structure,
> we should check whether it is allocated by bootmem or not.
> 
> But even if we know a resource structure is allocated by bootmem, we cannot
> release it since SLxB cannot treat it. So for reusing a resource structure,
> this patch remembers it by using bootmem_resource as follows:
> 
> When releasing a resource structure by free_resource(), free_resource() checks
> whether the resource structure is allocated by bootmem or not. If it is
> allocated by bootmem, free_resource() adds it to bootmem_resource. If it is
> not allocated by bootmem, free_resource() release it by kfree().
> 
> And when getting a new resource structure by get_resource(), get_resource()
> checks whether bootmem_resource has released resource structures or not. If
> there is a released resource structure, get_resource() returns it. If there is
> not a releaed resource structure, get_resource() returns new resource structure
> allocated by kzalloc().

Thanks for fixing this existing issue that also needed to be addressed.
I am not able to test this particular case in my test env, so I did not
notice it.

Can you update this patch to base off of the patch below?  Otherwise, it
won't apply cleanly.
https://lkml.org/lkml/2013/4/11/694

More comments below.

> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
> This patch is baseg on following Toshi's works:
> Support memory hot-delete to boot memory
>   https://lkml.org/lkml/2013/4/10/469
> 
>  kernel/resource.c |   72 +++++++++++++++++++++++++++++++++++++++++++---------
>  1 files changed, 59 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 16bfd39..152e9aa 100644
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
> +static DEFINE_SPINLOCK(bootmem_resource_lock);
> +
>  static void *r_next(struct seq_file *m, void *v, loff_t *pos)
>  {
>  	struct resource *p = v;
> @@ -151,6 +162,42 @@ __initcall(ioresources_init);
>  
>  #endif /* CONFIG_PROC_FS */
>  
> +static void __free_resource(struct resource *res)
> +{
> +	struct resource *next_res = bootmem_resource.sibling;
> +
> +	bootmem_resource.sibling = res;
> +	res->sibling = next_res;
> +}
> +
> +static void free_resource(struct resource *res)
> +{

You need to add the following if-statement here.  Otherwise it hits a
page fault when res is NULL.  This case happens when a resource entry
splits into two entries.

	if (!res)
		return;

> +	if (PageReserved(virt_to_page(res))) {
> +		spin_lock(&bootmem_resource_lock);
> +		__free_resource(res);

How about simply updating the link here, instead of having it done in
__free_resource()?  I think it makes it more consistent with
get_resource().

		res->sibling = bootmem_resource.sibling;
		bootmem_resource.sibling = res;

Thanks,
-Toshi

> +		spin_unlock(&bootmem_resource_lock);
> +	} else {
> +		kfree(res);
> +	}
> +}



