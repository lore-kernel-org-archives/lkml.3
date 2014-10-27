Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaJ0HEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:04:36 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:43192 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaJ0HD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:03:59 -0400
Date: Mon, 27 Oct 2014 12:33:29 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, hughd@google.com, riel@redhat.com,
        mgorman@suse.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, dbueso@suse.de, linux-mm@kvack.org
Subject: Re: [PATCH 05/10] uprobes: share the i_mmap_rwsem
Message-ID: <20141027070329.GA10867@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1414188380-17376-1-git-send-email-dave@stgolabs.net>
 <1414188380-17376-6-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1414188380-17376-6-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102707-0033-0000-0000-0000027642B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Davidlohr Bueso <dave@stgolabs.net> [2014-10-24 15:06:15]:

> Both register and unregister call build_map_info() in order
> to create the list of mappings before installing or removing
> breakpoints for every mm which maps file backed memory. As
> such, there is no reason to hold the i_mmap_rwsem exclusively,
> so share it and allow concurrent readers to build the mapping
> data.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>


Copying Oleg (since he should have been copied on this one)

Please see one comment below.

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com> 

> ---
>  kernel/events/uprobes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 045b649..7a9e620 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -724,7 +724,7 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
>  	int more = 0;
>  
>   again:
> -	i_mmap_lock_write(mapping);
> +	i_mmap_lock_read(mapping);
>  	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
>  		if (!valid_vma(vma, is_register))
>  			continue;


Just after this, we have
if (!prev && !more) {
	/*
	 * Needs GFP_NOWAIT to avoid i_mmap_mutex recursion through
	 * reclaim. This is optimistic, no harm done if it fails.
	 */
	prev = kmalloc(sizeof(struct map_info),
			GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);
	if (prev)
		prev->next = NULL;
}

However in patch 02/10
I dont think the comment referring to i_mmap_mutex was modified to
refer i_mmap_lock_write.

When thats taken care off, this patch should change that part accordingly.


-- 
Thanks and Regards
Srikar Dronamraju

