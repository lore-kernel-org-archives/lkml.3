Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab3FCTZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:25:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37441 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab3FCTZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:25:20 -0400
Date: Mon, 3 Jun 2013 21:25:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
Message-ID: <20130603192505.GH8923@twins.programming.kicks-ass.net>
References: <20130523152611.GE23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
 <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu>
 <20130529074433.GB12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu>
 <20130530072532.GF4341@laptop>
 <alpine.DEB.2.10.1305300842040.11264@vincent-weaver-1.um.maine.edu>
 <20130603132645.GC8923@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603132645.GC8923@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 03:26:45PM +0200, Peter Zijlstra wrote:
> On Thu, May 30, 2013 at 08:51:00AM -0400, Vince Weaver wrote:
> > > I'll go prod, thanks again!
> 
> 
> OK the below builds and seems to survive both test cases and about 10 minutes
> of fuzzing -- fingers crossed.
> 
> ---
> @@ -3779,12 +3834,21 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
>  		return -EINVAL;
>  
>  	WARN_ON_ONCE(event->ctx->parent_ctx);
> +again:
>  	mutex_lock(&event->mmap_mutex);
>  	if (event->rb) {
> -		if (event->rb->nr_pages == nr_pages)
> -			atomic_inc(&event->rb->refcount);
> -		else
> +		if (event->rb->nr_pages != nr_pages)
		{
>  			ret = -EINVAL;
			goto unlock;
		}

Seems to cure it... I'm going to let it run over night.

> +
> +		if (!atomic_inc_not_zero(&event->rb->mmap_count)) {
> +			/*
> +			 * Raced against perf_mmap_close() through
> +			 * perf_event_set_output(). Try again, hope for better
> +			 * luck.
> +			 */
> +			mutex_unlock(&event->mmap_mutex);
> +			goto again;
> +		}
>  		goto unlock;
>  	}
>  
