Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaKZWkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:40:11 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49338 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaKZWkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:40:09 -0500
Date: Wed, 26 Nov 2014 14:40:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [patch] fs, seq_file: fallback to vmalloc instead of oom kill
 processes
In-Reply-To: <20141126142404.bc6b03387d5e869908db5e38@linux-foundation.org>
Message-ID: <alpine.DEB.2.10.1411261434080.13014@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1411261415500.13014@chino.kir.corp.google.com> <20141126142404.bc6b03387d5e869908db5e38@linux-foundation.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014, Andrew Morton wrote:

> You forgot something.
> 
> --- a/fs/seq_file.c~fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix
> +++ a/fs/seq_file.c
> @@ -36,6 +36,10 @@ static void *seq_buf_alloc(unsigned long
>  {
>  	void *buf;
>  
> +	/*
> +	 * __GFP_NORETRY to avoid oom-killings with high-order allocations -
> +	 * it's better to fall back to vmalloc() than to kill things.
> +	 */
>  	buf = kmalloc(size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
>  	if (!buf && size > PAGE_SIZE)
>  		buf = vmalloc(size);
> 

Thanks!

> Is __GFP_NORETRY our preferred way of preventing oom-killings?  If so,
> it's a bit obscure - wouldn't it be better to create a
> __GFP_NO_OOM_KILL?
> 

The slowpath tries to allocate, calls memory compaction if necessary, 
tries to allocate, calls direct reclaim, tries to allocate, call the oom 
killer and tries to allocate if we are going to loop, and then loop if 
allowed.  There's no need to try to allocate if we don't call the oom 
killer since it won't succeed and there's no need to call the oom killer 
to free memory if we aren't going to retry.

Even if __GFP_NO_OOM_KILL existed, it wouldn't be applicable to this 
patch: the change here is that seqfile will now return -ENOMEM instead of 
oom killing processes; the slab allocation will no longer loop forever 
trying to allocate memory.
