Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaKFJKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 04:10:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaKFJKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 04:10:07 -0500
Message-ID: <1415264981.15424.3.camel@linux-t7sj.site>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
From: Davidlohr Bueso <dave@stgolabs.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Nov 2014 01:09:41 -0800
In-Reply-To: <20141106164444.2123e6d5@canb.auug.org.au>
References: <20141106164444.2123e6d5@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-06 at 16:44 +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> mm/fremap.c: In function 'SYSC_remap_file_pages':
> mm/fremap.c:241:22: error: 'struct address_space' has no member named 'i_mmap_mutex'
>    mutex_lock(&mapping->i_mmap_mutex);
>                       ^
> mm/fremap.c:247:24: error: 'struct address_space' has no member named 'i_mmap_mutex'
>    mutex_unlock(&mapping->i_mmap_mutex);
>                         ^
> 
> Caused by commit 1f8c97e79f66 ("mm: convert i_mmap_mutex to rwsem").
> 
> I applied this patch for today (not sure if there is a better way):
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 6 Nov 2014 16:26:41 +1100
> Subject: [PATCH] mm: convert i_mmap_mutex to rwsem fix
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  mm/fremap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/fremap.c b/mm/fremap.c
> index 9129013732d7..2805d71cf476 100644
> --- a/mm/fremap.c
> +++ b/mm/fremap.c
> @@ -238,13 +238,13 @@ get_write_lock:
>  			}
>  			goto out_freed;
>  		}
> -		mutex_lock(&mapping->i_mmap_mutex);
> +		i_mmap_lock_write(mapping);

That's the correct fix, thanks. However, I had particularly dropped that
modification because linux-next no longer even has mm/fremap.c so I'm
not sure what went wrong here...

