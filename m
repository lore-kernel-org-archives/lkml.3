Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbbAUXJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:09:50 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:48287 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbAUXJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:09:44 -0500
Date: Wed, 21 Jan 2015 15:09:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pan Xinhui <xinhuix.pan@intel.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, oleg@redhat.com, bill.c.roberts@gmail.com,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] mm/util.c: add a none zero check of "len"
In-Reply-To: <54BE0FB3.1030008@intel.com>
Message-ID: <alpine.DEB.2.10.1501211506120.2716@chino.kir.corp.google.com>
References: <54BE0FB3.1030008@intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Pan Xinhui wrote:

> Although this check should have been done by caller. But as it's exported to
> others,
> It's better to add a none zero check of "len" like other functions.
> 
> Signed-off-by: xinhuix.pan <xinhuix.pan@intel.com>
> ---
>  mm/util.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/util.c b/mm/util.c
> index fec39d4..3dc2873 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -72,6 +72,9 @@ void *kmemdup(const void *src, size_t len, gfp_t gfp)
>  {
>  	void *p;
>  +	if (unlikely(!len))
> +		return ERR_PTR(-EINVAL);
> +
>  	p = kmalloc_track_caller(len, gfp);
>  	if (p)
>  		memcpy(p, src, len);
> @@ -91,6 +94,8 @@ void *memdup_user(const void __user *src, size_t len)
>  {
>  	void *p;
>  +	if (unlikely(!len))
> +		return ERR_PTR(-EINVAL);
>  	/*
>  	 * Always use GFP_KERNEL, since copy_from_user() can sleep and
>  	 * cause pagefault, which makes it pointless to use GFP_NOFS

Nack, there's no need for this since both slab and slub check for 
ZERO_OR_NULL_PTR() and kmalloc_slab() will return ZERO_SIZE_PTR in these 
cases.  kmemdup() would then return NULL, which is appropriate since it 
doesn't return an ERR_PTR() even when memory cannot be allocated.  
memdup_user() would return -ENOMEM for size == 0, which would arguably be 
the wrong return value, but I don't think we need to slow down either of 
these library functions to check for something as stupid as duplicating 
size == 0.
