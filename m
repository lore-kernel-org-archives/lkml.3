Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbaLVVFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 16:05:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbaLVVFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 16:05:40 -0500
Date: Mon, 22 Dec 2014 13:05:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Toshi Kikuchi <toshik@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/genalloc.c: fix the end addr check in
 addr_in_gen_pool()
Message-Id: <20141222130539.8bcb58ffa9db2258204bf807@linux-foundation.org>
In-Reply-To: <1418956259-13003-1-git-send-email-toshik@chromium.org>
References: <1418956259-13003-1-git-send-email-toshik@chromium.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014 18:30:59 -0800 Toshi Kikuchi <toshik@chromium.org> wrote:

> Since chunk->end_addr is (chunk->start_addr + size - 1),
> the end address to compare should be (start + size - 1).
> 
> Signed-off-by: Toshi Kikuchi <toshik@chromium.org>
> ---
>  lib/genalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/genalloc.c b/lib/genalloc.c
> index 2e65d20..42a95e9 100644
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -415,7 +415,7 @@ bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
>  			size_t size)
>  {
>  	bool found = false;
> -	unsigned long end = start + size;
> +	unsigned long end = start + size - 1;
>  	struct gen_pool_chunk *chunk;
>  
>  	rcu_read_lock();

urgh.  gen_pool_chunk.end_addr should have been made exclusive, not
inclusive.  Or switch to start_addr/size.  The code would be
considerably nicer that way.

And the struct gen_pool_chunk definition should be moved into
genalloc.c.  I'm not sure what drivers/acpi/apei/ghes.c is doing
fiddling around with genalloc internals, but it should stop doing it.

Sigh :(
