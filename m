Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaJRN6D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 09:58:03 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47538 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaJRN57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 09:57:59 -0400
MIME-Version: 1.0
In-Reply-To: <1413367243-23524-1-git-send-email-heesub.shin@samsung.com>
References: <1413367243-23524-1-git-send-email-heesub.shin@samsung.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Sat, 18 Oct 2014 09:57:37 -0400
X-Google-Sender-Auth: zBU7_ZhZpfHDgHQUJVN-RlZ_Y68
Message-ID: <CALZtONDkBakFoBz6Pi_xN0A+uiAmWqKxPyzP-ynqF4f77ZNTog@mail.gmail.com>
Subject: Re: [PATCH] mm/zbud: init user ops only when it is needed
To: Heesub Shin <heesub.shin@samsung.com>
Cc: Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sunae Seo <sunae.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 6:00 AM, Heesub Shin <heesub.shin@samsung.com> wrote:
> When zbud is initialized through the zpool wrapper, pool->ops which
> points to user-defined operations is always set regardless of whether it
> is specified from the upper layer. This causes zbud_reclaim_page() to
> iterate its loop for evicting pool pages out without any gain.
>
> This patch sets the user-defined ops only when it is needed, so that
> zbud_reclaim_page() can bail out the reclamation loop earlier if there
> is no user-defined operations specified.

Though the only current user (zswap) always passes an ops param, other
future users may not and this is the right way to handle it.  thanks!

>
> Signed-off-by: Heesub Shin <heesub.shin@samsung.com>

Acked-by: Dan Streetman <ddstreet@ieee.org>

> ---
>  mm/zbud.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/zbud.c b/mm/zbud.c
> index ecf1dbe..db8de74 100644
> --- a/mm/zbud.c
> +++ b/mm/zbud.c
> @@ -132,7 +132,7 @@ static struct zbud_ops zbud_zpool_ops = {
>
>  static void *zbud_zpool_create(gfp_t gfp, struct zpool_ops *zpool_ops)
>  {
> -       return zbud_create_pool(gfp, &zbud_zpool_ops);
> +       return zbud_create_pool(gfp, zpool_ops ? &zbud_zpool_ops : NULL);
>  }
>
>  static void zbud_zpool_destroy(void *pool)
> --
> 1.9.1
>
