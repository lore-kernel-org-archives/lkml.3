Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3LRMZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:25:52 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:47069 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab3LRMZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:25:51 -0500
Date: Wed, 18 Dec 2013 07:25:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] async: fix insert entry in ascending list
Message-ID: <20131218122545.GD4324@htj.dyndns.org>
References: <1387336523-13756-1-git-send-email-vaughan.cao@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387336523-13756-1-git-send-email-vaughan.cao@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 18, 2013 at 11:15:23AM +0800, Vaughan Cao wrote:
> I suppose there is a fault in the patch of https://lkml.org/lkml/2013/1/16/546.
> I know you made a new patch for latest kernel which don't move the entry
> between pending and running list that remove the code I mentioned, but our
> kernel is based on v3.8.13 that has the code.
> 
> In my understanding, both pending and running list are sorted ascendingly by
> cookie value. To find the correct postion to insert the entry into running
> list, we traverse reversely to the head. When a node with a smaller cookie is
> found, we break out and add the new entry after it. But the origin code tries 
> to find a larger cookie and insert itself before that node, it won't result in
> a sorted list in any direction...

Yeah, I should have used list_for_each_entry() there.  LOL, I'm an
idiot.

> I don't know if my understanding about the async mechanism is right, so here 
> to have a check with you. Thanks.
> 
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  kernel/async.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/async.c b/kernel/async.c
> index 6f34904..596c5e7 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -135,9 +135,9 @@ static void async_run_entry_fn(struct work_struct *work)
>  	/* 1) move self to the running queue, make sure it stays sorted */
>  	spin_lock_irqsave(&async_lock, flags);
>  	list_for_each_entry_reverse(pos, &running->domain, list)
> -		if (entry->cookie < pos->cookie)
> +		if (entry->cookie > pos->cookie)
>  			break;
> -	list_move_tail(&entry->list, &pos->list);
> +	list_move(&entry->list, &pos->list);

Hmmm... sadly, upstream doesn't have the ability to backport this.
The relevant code path is gone and -stable doesn't backport patches
which aren't mainline first.  The only way would be backporting
through distros, I guess.  But, again, this problem shouldn't be
noticeable with modern userland and it has been broekn without anyone
noticing for long enough, so maybe we can just leave it alone?

Thanks.

-- 
tejun
