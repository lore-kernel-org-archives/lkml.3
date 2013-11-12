Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3KLMfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:35:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab3KLMf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:35:28 -0500
Subject: Re: [PATCH] gfs2: fix potential NULL pointer dereference
From: Steven Whitehouse <swhiteho@redhat.com>
To: Michal Nazarewicz <mpn@google.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
In-Reply-To: <1384259405-7913-1-git-send-email-mpn@google.com>
References: <1384259405-7913-1-git-send-email-mpn@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 12 Nov 2013 12:35:12 +0000
Message-ID: <1384259712.2697.9.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yes, good catch. Thanks, I'll add it to the tree,

Steve.

On Tue, 2013-11-12 at 13:30 +0100, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
> 
> Commit [e66cf1610: GFS2: Use lockref for glocks] replaced call:
>     atomic_read(&gi->gl->gl_ref) == 0
> with:
>     __lockref_is_dead(&gl->gl_lockref)
> therefore changing how gl is accessed, from gi->gl to plan gl.
> However, gl can be a NULL pointer, and so gi->gl needs to be
> used instead (which is guaranteed not to be NULL because fo
> the while loop checking that condition).
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  fs/gfs2/glock.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> index e66a800..c8420f7 100644
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -1899,7 +1899,8 @@ static int gfs2_glock_iter_next(struct gfs2_glock_iter *gi)
>  			gi->nhash = 0;
>  		}
>  	/* Skip entries for other sb and dead entries */
> -	} while (gi->sdp != gi->gl->gl_sbd || __lockref_is_dead(&gl->gl_lockref));
> +	} while (gi->sdp != gi->gl->gl_sbd ||
> +		 __lockref_is_dead(&gi->gl->gl_lockref));
>  
>  	return 0;
>  }


