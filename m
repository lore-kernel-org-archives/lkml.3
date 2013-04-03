Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab3DCBMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:12:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36260 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3DCBL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:11:59 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <515B81B8.9020307@jp.fujitsu.com>
Date: Wed, 3 Apr 2013 10:11:20 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linuxram@us.ibm.com>, <tmac@hp.com>,
        <wency@cn.fujitsu.com>, <tangchen@cn.fujitsu.com>,
        <jiang.liu@huawei.com>
Subject: Re: [PATCH 1/3] resource: Add __adjust_resource() for internal use
References: <1364919450-8741-1-git-send-email-toshi.kani@hp.com> <1364919450-8741-2-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1364919450-8741-2-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

2013/04/03 1:17, Toshi Kani wrote:
> Added __adjust_resource(), which is called by adjust_resource()
> internally after the resource_lock is held.  There is no interface
> change to adjust_resource().  This change allows other functions
> to call __adjust_resource() internally while the resource_lock is
> held.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

The patch looks good.
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

> ---
>   kernel/resource.c |   35 ++++++++++++++++++++++-------------
>   1 file changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 73f35d4..ae246f9 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -706,24 +706,13 @@ void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
>   	write_unlock(&resource_lock);
>   }
>   
> -/**
> - * adjust_resource - modify a resource's start and size
> - * @res: resource to modify
> - * @start: new start value
> - * @size: new size
> - *
> - * Given an existing resource, change its start and size to match the
> - * arguments.  Returns 0 on success, -EBUSY if it can't fit.
> - * Existing children of the resource are assumed to be immutable.
> - */
> -int adjust_resource(struct resource *res, resource_size_t start, resource_size_t size)
> +static int __adjust_resource(struct resource *res, resource_size_t start,
> +				resource_size_t size)
>   {
>   	struct resource *tmp, *parent = res->parent;
>   	resource_size_t end = start + size - 1;
>   	int result = -EBUSY;
>   
> -	write_lock(&resource_lock);
> -
>   	if (!parent)
>   		goto skip;
>   
> @@ -751,6 +740,26 @@ skip:
>   	result = 0;
>   
>    out:
> +	return result;
> +}
> +
> +/**
> + * adjust_resource - modify a resource's start and size
> + * @res: resource to modify
> + * @start: new start value
> + * @size: new size
> + *
> + * Given an existing resource, change its start and size to match the
> + * arguments.  Returns 0 on success, -EBUSY if it can't fit.
> + * Existing children of the resource are assumed to be immutable.
> + */
> +int adjust_resource(struct resource *res, resource_size_t start,
> +			resource_size_t size)
> +{
> +	int result;
> +
> +	write_lock(&resource_lock);
> +	result = __adjust_resource(res, start, size);
>   	write_unlock(&resource_lock);
>   	return result;
>   }
> 


