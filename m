Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaEGVUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:20:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaEGVUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:20:35 -0400
Date: Wed, 7 May 2014 14:20:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v3 6/6] mm, compaction: terminate async compaction when
 rescheduling
Message-Id: <20140507142033.1ec148fe35059121db547f25@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 19:22:52 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> Async compaction terminates prematurely when need_resched(), see
> compact_checklock_irqsave().  This can never trigger, however, if the 
> cond_resched() in isolate_migratepages_range() always takes care of the 
> scheduling.
> 
> If the cond_resched() actually triggers, then terminate this pageblock scan for 
> async compaction as well.
> 
> ..
>
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -500,8 +500,13 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>  			return 0;
>  	}
>  
> +	if (cond_resched()) {
> +		/* Async terminates prematurely on need_resched() */
> +		if (cc->mode == MIGRATE_ASYNC)
> +			return 0;
> +	}

Comment comments the obvious.  What is less obvious is *why* we do this.


Someone please remind my why sync and async compaction use different
scanning cursors?

