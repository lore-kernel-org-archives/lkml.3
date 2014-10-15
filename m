Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaJOURN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:17:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaJOURM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:17:12 -0400
Date: Wed, 15 Oct 2014 13:17:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heesub Shin <heesub.shin@samsung.com>
Cc: Dan Streetman <ddstreet@ieee.org>,
        Seth Jennings <sjennings@variantweb.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Sunae Seo <sunae.seo@samsung.com>
Subject: Re: [PATCH] mm/zbud: init user ops only when it is needed
Message-Id: <20141015131710.ffd6c40996cd1ce6c16dbae8@linux-foundation.org>
In-Reply-To: <1413367243-23524-1-git-send-email-heesub.shin@samsung.com>
References: <1413367243-23524-1-git-send-email-heesub.shin@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014 19:00:43 +0900 Heesub Shin <heesub.shin@samsung.com> wrote:

> When zbud is initialized through the zpool wrapper, pool->ops which
> points to user-defined operations is always set regardless of whether it
> is specified from the upper layer. This causes zbud_reclaim_page() to
> iterate its loop for evicting pool pages out without any gain.
> 
> This patch sets the user-defined ops only when it is needed, so that
> zbud_reclaim_page() can bail out the reclamation loop earlier if there
> is no user-defined operations specified.

Which callsite is calling zbud_zpool_create(..., NULL)?

> ...
> --- a/mm/zbud.c
> +++ b/mm/zbud.c
> @@ -132,7 +132,7 @@ static struct zbud_ops zbud_zpool_ops = {
>  
>  static void *zbud_zpool_create(gfp_t gfp, struct zpool_ops *zpool_ops)
>  {
> -	return zbud_create_pool(gfp, &zbud_zpool_ops);
> +	return zbud_create_pool(gfp, zpool_ops ? &zbud_zpool_ops : NULL);
>  }
>  
>  static void zbud_zpool_destroy(void *pool)

