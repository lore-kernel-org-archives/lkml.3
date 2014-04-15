Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbaDOACR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:02:17 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:30434 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbaDOACQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:02:16 -0400
Message-ID: <1397520133.31076.24.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 3/3] mm,vmacache: optimize overflow system-wide flushing
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, aswin@hp.com,
        Oleg Nesterov <oleg@redhat.com>
Date: Mon, 14 Apr 2014 17:02:13 -0700
In-Reply-To: <1397519841-24847-4-git-send-email-davidlohr@hp.com>
References: <1397519841-24847-1-git-send-email-davidlohr@hp.com>
	 <1397519841-24847-4-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stupid script... Cc'ing Oleg.

On Mon, 2014-04-14 at 16:57 -0700, Davidlohr Bueso wrote:
> For single threaded workloads, we can avoid flushing
> and iterating through the entire list of tasks, making
> the whole function a lot faster, requiring only a single
> atomic read for the mm_users.
> 
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  mm/vmacache.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/vmacache.c b/mm/vmacache.c
> index e167da2..61c38ae 100644
> --- a/mm/vmacache.c
> +++ b/mm/vmacache.c
> @@ -17,6 +17,16 @@ void vmacache_flush_all(struct mm_struct *mm)
>  {
>  	struct task_struct *g, *p;
>  
> +	/*
> +	 * Single threaded tasks need not iterate the entire
> +	 * list of process. We can avoid the flushing as well
> +	 * since the mm's seqnum was increased and don't have
> +	 * to worry about other threads' seqnum. Current's
> +	 * flush will occur upon the next lookup.
> +	 */
> +	if (atomic_read(&mm->mm_users) == 1)
> +		return;
> +
>  	rcu_read_lock();
>  	for_each_process_thread(g, p) {
>  		/*


