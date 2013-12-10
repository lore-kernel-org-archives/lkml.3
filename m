Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3LJO0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:26:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab3LJO0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:26:11 -0500
Message-ID: <52A72463.9080108@redhat.com>
Date: Tue, 10 Dec 2013 09:25:39 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 11/18] mm: fix TLB flush race between migration, and change_protection_range
References: <1386572952-1191-1-git-send-email-mgorman@suse.de> <1386572952-1191-12-git-send-email-mgorman@suse.de>
In-Reply-To: <1386572952-1191-12-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 02:09 AM, Mel Gorman wrote:

After reading the locking thread that Paul McKenney started,
I wonder if I got the barriers wrong in these functions...

> +#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
> +/*
> + * Memory barriers to keep this state in sync are graciously provided by
> + * the page table locks, outside of which no page table modifications happen.
> + * The barriers below prevent the compiler from re-ordering the instructions
> + * around the memory barriers that are already present in the code.
> + */
> +static inline bool tlb_flush_pending(struct mm_struct *mm)
> +{
> +	barrier();

Should this be smp_mb__after_unlock_lock(); ?

> +	return mm->tlb_flush_pending;
> +}
> +static inline void set_tlb_flush_pending(struct mm_struct *mm)
> +{
> +	mm->tlb_flush_pending = true;
> +	barrier();
> +}
> +/* Clearing is done after a TLB flush, which also provides a barrier. */
> +static inline void clear_tlb_flush_pending(struct mm_struct *mm)
> +{
> +	barrier();
> +	mm->tlb_flush_pending = false;
> +}

And these smp_mb__before_spinlock() ?

Paul? Peter?

-- 
All rights reversed
