Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaFDKYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:24:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57250 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbaFDKYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:24:45 -0400
Date: Wed, 4 Jun 2014 12:24:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 04/13] resource: Provide new functions to walk through
 resources
Message-ID: <20140604102420.GC4105@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-5-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401800822-27425-5-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:06:53AM -0400, Vivek Goyal wrote:
> @@ -322,7 +327,71 @@ int release_resource(struct resource *old)
>  
>  EXPORT_SYMBOL(release_resource);
>  
> -#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
> +/*
> + * Finds the lowest iomem reosurce exists with-in [res->start.res->end)
> + * the caller must specify res->start, res->end, res->flags and "name".
> + * If found, returns 0, res is overwritten, if not found, returns -1.
> + * This walks through whole tree and not just first level children.
> + */
> +static int find_next_iomem_res(struct resource *res, char *name)
> +{
> +	resource_size_t start, end;
> +	struct resource *p;
> +
> +	BUG_ON(!res);
> +
> +	start = res->start;
> +	end = res->end;
> +	BUG_ON(start >= end);
> +
> +	read_lock(&resource_lock);
> +	p = &iomem_resource;
> +	while ((p = next_resource(p))) {

Just a thought - this function differs from find_next_system_ram() only
in the traversal mode through resources. I wonder if next_resource()
could be given a flag, say TRAVERSE_SIBLINGS_ONLY or so and be called
from both, once with the flag set and once without and thus save us the
code duplication.

> +		if (p->flags != res->flags)
> +			continue;
> +		if (name && strcmp(p->name, name))
> +			continue;
> +		if (p->start > end) {
> +			p = NULL;
> +			break;
> +		}
> +		if ((p->end >= start) && (p->start < end))
> +			break;
> +	}
> +
> +	read_unlock(&resource_lock);
> +	if (!p)
> +		return -1;
> +	/* copy data */
> +	if (res->start < p->start)
> +		res->start = p->start;
> +	if (res->end > p->end)
> +		res->end = p->end;
> +	return 0;
> +}

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
