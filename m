Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaKZWYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:24:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaKZWYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:24:06 -0500
Date: Wed, 26 Nov 2014 14:24:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [patch] fs, seq_file: fallback to vmalloc instead of oom kill
 processes
Message-Id: <20141126142404.bc6b03387d5e869908db5e38@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.10.1411261415500.13014@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1411261415500.13014@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014 14:16:46 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> Since commit 058504edd026 ("fs/seq_file: fallback to vmalloc allocation"),
> seq_buf_alloc() falls back to vmalloc() when the kmalloc() for contiguous
> memory fails.  This was done to address order-4 slab allocations for
> reading /proc/stat on large machines and noticed because
> PAGE_ALLOC_COSTLY_ORDER < 4, so there is no infinite loop in the page
> allocator when allocating new slab for such high-order allocations.
> 
> Contiguous memory isn't necessary for caller of seq_buf_alloc(), however.
> Other GFP_KERNEL high-order allocations that are <=
> PAGE_ALLOC_COSTLY_ORDER will simply loop forever in the page allocator
> and oom kill processes as a result.
> 
> We don't want to kill processes so that we can allocate contiguous memory
> in situations when contiguous memory isn't necessary.
> 
> This patch does the kmalloc() allocation with __GFP_NORETRY for
> high-order allocations.  This still utilizes memory compaction and direct 
> reclaim in the allocation path, the only difference is that it will fail 
> immediately instead of oom kill processes when out of memory.
> 
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -36,7 +36,7 @@ static void *seq_buf_alloc(unsigned long size)
>  {
>  	void *buf;
>  
> -	buf = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
> +	buf = kmalloc(size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
>  	if (!buf && size > PAGE_SIZE)
>  		buf = vmalloc(size);
>  	return buf;

You forgot something.

--- a/fs/seq_file.c~fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix
+++ a/fs/seq_file.c
@@ -36,6 +36,10 @@ static void *seq_buf_alloc(unsigned long
 {
 	void *buf;
 
+	/*
+	 * __GFP_NORETRY to avoid oom-killings with high-order allocations -
+	 * it's better to fall back to vmalloc() than to kill things.
+	 */
 	buf = kmalloc(size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
 	if (!buf && size > PAGE_SIZE)
 		buf = vmalloc(size);

Is __GFP_NORETRY our preferred way of preventing oom-killings?  If so,
it's a bit obscure - wouldn't it be better to create a
__GFP_NO_OOM_KILL?

There are eleventy billion places where we do the open coded
kmalloc-or-vmalloc thing.  Sigh.  Perhaps it is time to add a helper
function which does this, so that all such callers use
__GFP_NO_OOM_KILL.

