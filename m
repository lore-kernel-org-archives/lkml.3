Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbaFYXfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:35:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaFYXfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:35:30 -0400
Date: Wed, 25 Jun 2014 16:35:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] mm: page_alloc: Reduce cost of dirty zone balancing
Message-Id: <20140625163528.11368b86ef7d0a38cf9d1255@linux-foundation.org>
In-Reply-To: <1403683129-10814-6-git-send-email-mgorman@suse.de>
References: <1403683129-10814-1-git-send-email-mgorman@suse.de>
	<1403683129-10814-6-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014 08:58:48 +0100 Mel Gorman <mgorman@suse.de> wrote:

> @@ -325,7 +321,14 @@ static unsigned long zone_dirty_limit(struct zone *zone)
>   */
>  bool zone_dirty_ok(struct zone *zone)
>  {
> -	unsigned long limit = zone_dirty_limit(zone);
> +	unsigned long limit = zone->dirty_limit_cached;
> +	struct task_struct *tsk = current;
> +
> +	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
> +		limit = zone_dirty_limit(zone);
> +		zone->dirty_limit_cached = limit;
> +		limit += limit / 4;
> +	}

Could we get a comment in here explaining what we're doing and why
PF_LESS_THROTTLE and rt_task control whether we do it?

