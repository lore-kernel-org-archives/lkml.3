Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab3LFPDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:03:05 -0500
Received: from a9-113.smtp-out.amazonses.com ([54.240.9.113]:34696 "EHLO
	a9-113.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678Ab3LFPDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:03:03 -0500
X-Greylist: delayed 653 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Dec 2013 10:03:03 EST
Date: Fri, 6 Dec 2013 14:52:07 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Joonsoo Kim <js1304@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm/migrate: correct return value of
 migrate_pages()
In-Reply-To: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000142c864eed3-5e3737e5-9262-418a-9341-60b712ae281e-000000@email.amazonses.com>
References: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.06-54.240.9.113
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Dec 2013, Joonsoo Kim wrote:

> migrate_pages() should return number of pages not migrated or error code.
> When unmap_and_move return -EAGAIN, outer loop is re-execution without
> initialising nr_failed. This makes nr_failed over-counted.
>
> So this patch correct it by initialising nr_failed in outer loop.

Well nr_retry is the total number of attempts that got EGAIN. nr_failed is
the total number of failed attempts. You are making nr_failed the number
of pages of the list that have failed to migrated. That syncs with the
description.

> diff --git a/mm/migrate.c b/mm/migrate.c
> index 3747fcd..1f59ccc 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1102,6 +1102,7 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
>
>  	for(pass = 0; pass < 10 && retry; pass++) {
>  		retry = 0;
> +		nr_failed = 0;

The initialization of nr_failed and retry earlier is then useless.

