Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab3LBWxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 17:53:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab3LBWxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 17:53:00 -0500
Date: Mon, 2 Dec 2013 14:52:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 4/9] mm/rmap: make rmap_walk to get the
 rmap_walk_control argument
Message-Id: <20131202145258.9f14767c1190c068becece0d@linux-foundation.org>
In-Reply-To: <1385624926-28883-5-git-send-email-iamjoonsoo.kim@lge.com>
References: <1385624926-28883-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1385624926-28883-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013 16:48:41 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> In each rmap traverse case, there is some difference so that we need
> function pointers and arguments to them in order to handle these
> difference properly.
> 
> For this purpose, struct rmap_walk_control is introduced in this patch,
> and will be extended in following patch. Introducing and extending are
> separate, because it clarify changes.
> 
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -198,7 +198,12 @@ out:
>   */
>  static void remove_migration_ptes(struct page *old, struct page *new)
>  {
> -	rmap_walk(new, remove_migration_pte, old);
> +	struct rmap_walk_control rwc;
> +
> +	memset(&rwc, 0, sizeof(rwc));
> +	rwc.main = remove_migration_pte;
> +	rwc.arg = old;
> +	rmap_walk(new, &rwc);
>  }

It is much neater to do

	struct rmap_walk_control rwc = {
		.main = remove_migration_pte,
		.arg = old,
	};

which will zero out all remaining fields as well.
