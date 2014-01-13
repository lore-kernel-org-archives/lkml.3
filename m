Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaAMGEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 01:04:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaAMGEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 01:04:44 -0500
Date: Mon, 13 Jan 2014 07:04:41 +0100
From: Jan Kara <jack@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm/next] fanotify: fix corruption preventing startup
Message-ID: <20140113060441.GB3837@quack.suse.cz>
References: <alpine.LSU.2.11.1401112245290.4960@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1401112245290.4960@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 11-01-14 22:54:15, Hugh Dickins wrote:
> Two of my machines couldn't boot mmotm with fanotify enabled:
> 0x40000020 was being or'ed into a group's notification_waitq next
> pointer, with sad results.  It comes from an over-simplification in
> fanotify_merge(): test_event isn't NULL when the loop finds no merge.
  That's a really dumb bug. Thanks for the fix! It looks good, you can add:
Reviewed-by: Jan Kara <jack@suse.cz>

  I was wondering why I didn't see this problem during my testing.  I was
always running my tests with various debug options enabled (in a hope to
catch more problems ;), in particular with spinlock debugging enabled which
shifted the waitqueue pointers further and the corruption landed in
spinlock debugging fields and never got noticed... Ew :-|

								Honza
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
> Fixes fsnotify-do-not-share-events-between-notification-groups.patch
> 
>  fs/notify/fanotify/fanotify.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> --- mmotm/fs/notify/fanotify/fanotify.c	2014-01-10 18:25:01.700448941 -0800
> +++ linux/fs/notify/fanotify/fanotify.c	2014-01-11 22:15:31.580961010 -0800
> @@ -37,16 +37,19 @@ static bool should_merge(struct fsnotify
>  static struct fsnotify_event *fanotify_merge(struct list_head *list,
>  					     struct fsnotify_event *event)
>  {
> -	struct fsnotify_event *test_event = NULL;
> +	struct fsnotify_event *test_event;
> +	bool do_merge = false;
>  
>  	pr_debug("%s: list=%p event=%p\n", __func__, list, event);
>  
>  	list_for_each_entry_reverse(test_event, list, list) {
> -		if (should_merge(test_event, event))
> +		if (should_merge(test_event, event)) {
> +			do_merge = true;
>  			break;
> +		}
>  	}
>  
> -	if (!test_event)
> +	if (!do_merge)
>  		return NULL;
>  
>  	test_event->mask |= event->mask;
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
