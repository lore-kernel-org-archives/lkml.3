Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654Ab3DRNmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:42:37 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43323 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934480Ab3DRNmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:42:36 -0400
Date: Thu, 18 Apr 2013 06:42:06 -0700
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, toshi.kani@hp.com, linuxram@us.ibm.com,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [Bug fix PATCH v4] Reusing a resource structure allocated by
 bootmem
Message-ID: <20130418134206.GB21444@cmpxchg.org>
References: <516FB07C.9010603@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516FB07C.9010603@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 05:36:12PM +0900, Yasuaki Ishimatsu wrote:
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

The branch is mixed up, you are collecting slab objects in
bootmem_resource and kfreeing bootmem.

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
> +
> +	if (!res)
> +		res = kzalloc(sizeof(struct resource), flags);
> +
> +	return res;
> +}
> +
>  /* Return the conflict entry if you can't request it */
>  static struct resource * __request_resource(struct resource *root, struct resource *new)
>  {
