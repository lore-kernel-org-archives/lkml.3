Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbbAGOXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:23:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbbAGOXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:23:38 -0500
Message-ID: <54AD4167.8020703@suse.com>
Date: Wed, 07 Jan 2015 15:23:35 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, david.vrabel@citrix.com,
        konrad.wilk@oracle.com
CC: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/xen: Free bootmem in free_p2m_page() during early
 boot
References: <1420639734-24808-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1420639734-24808-1-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 03:08 PM, Boris Ostrovsky wrote:
> With recent changes in p2m we now have legitimate cases when
> p2m memory needs to be freed during early boot (i.e. before
> slab is initialized).
>
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Reviewed-by: Juergen Gross <jgross@suse.com>

> ---
>   arch/x86/xen/p2m.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index edbc7a6..df8acb4 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -167,10 +167,13 @@ static void * __ref alloc_p2m_page(void)
>   	return (void *)__get_free_page(GFP_KERNEL | __GFP_REPEAT);
>   }
>
> -/* Only to be called in case of a race for a page just allocated! */
>   static void free_p2m_page(void *p)
>   {
> -	BUG_ON(!slab_is_available());
> +	if (unlikely(!slab_is_available())) {
> +		free_bootmem((unsigned long)p, PAGE_SIZE);
> +		return;
> +	}
> +
>   	free_page((unsigned long)p);
>   }
>
>

