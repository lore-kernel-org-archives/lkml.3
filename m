Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab3AYAN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:13:58 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39757 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3AYANv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:13:51 -0500
Date: Fri, 25 Jan 2013 00:13:45 +0000
From: James Hogan <james@albanarts.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] async: replace list of active domains with global
 list of pending items
Message-ID: <20130125001345.GA1960@balrog>
References: <20130119003923.GH24579@htj.dyndns.org>
 <20130119004100.GL24579@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130119004100.GL24579@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 18, 2013 at 04:41:00PM -0800, Tejun Heo wrote:
> @@ -125,9 +134,8 @@ static void async_run_entry_fn(struct work_struct *work)
>  
>  	/* 2) remove self from the pending queues */
>  	spin_lock_irqsave(&async_lock, flags);
> -	list_del(&entry->list);
> -	if (domain->registered && list_empty(&domain->pending))
> -		list_del_init(&domain->node);
> +	list_del_init(&entry->domain_list);
> +	list_del_init(&entry->global_list);

this unconditionally unlinks the global_list entry, however...

>  
>  	/* 3) free the entry */
>  	kfree(entry);
> @@ -168,10 +176,14 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct a
>  	entry->domain = domain;
>  
>  	spin_lock_irqsave(&async_lock, flags);
> +
> +	/* allocate cookie and queue */
>  	newcookie = entry->cookie = next_cookie++;
> -	if (domain->registered && list_empty(&domain->pending))
> -		list_add_tail(&domain->node, &async_domains);
> -	list_add_tail(&entry->list, &domain->pending);
> +
> +	list_add_tail(&entry->domain_list, &domain->pending);
> +	if (domain->registered)
> +		list_add_tail(&entry->global_list, &async_global_pending);

if (!domain->registered) then entry->global_list will have NULL pointers
from the kzalloc, so the list_del_init above will crash.

Should it have this?
+	else
+		INIT_LIST_HEAD(&entry->global_list)

Cheers
James
