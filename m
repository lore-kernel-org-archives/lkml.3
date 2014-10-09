Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaJIKuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:50:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:39098 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbaJIKuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:50:39 -0400
Date: Thu, 9 Oct 2014 12:50:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>
Subject: Re: [PATCH 2/4] mm: gup: add get_user_pages_locked and
 get_user_pages_unlocked
Message-ID: <20141009105037.GM4750@worktop.programming.kicks-ass.net>
References: <1412153797-6667-1-git-send-email-aarcange@redhat.com>
 <1412153797-6667-3-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412153797-6667-3-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:56:35AM +0200, Andrea Arcangeli wrote:

> +static inline long __get_user_pages_locked(struct task_struct *tsk,
> +					   struct mm_struct *mm,
> +					   unsigned long start,
> +					   unsigned long nr_pages,
> +					   int write, int force,
> +					   struct page **pages,
> +					   struct vm_area_struct **vmas,
> +					   int *locked,
> +					   bool notify_drop)
> +{

> +	if (notify_drop && lock_dropped && *locked) {
> +		/*
> +		 * We must let the caller know we temporarily dropped the lock
> +		 * and so the critical section protected by it was lost.
> +		 */
> +		up_read(&mm->mmap_sem);
> +		*locked = 0;
> +	}
> +	return pages_done;
> +}

> +long get_user_pages_locked(struct task_struct *tsk, struct mm_struct *mm,
> +			   unsigned long start, unsigned long nr_pages,
> +			   int write, int force, struct page **pages,
> +			   int *locked)
> +{
> +	return __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
> +				       pages, NULL, locked, true);
> +}

> +long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
> +			     unsigned long start, unsigned long nr_pages,
> +			     int write, int force, struct page **pages)
> +{
> +	long ret;
> +	int locked = 1;
> +	down_read(&mm->mmap_sem);
> +	ret = __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
> +				      pages, NULL, &locked, false);
> +	if (locked)
> +		up_read(&mm->mmap_sem);
> +	return ret;
> +}

>  long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>  		unsigned long start, unsigned long nr_pages, int write,
>  		int force, struct page **pages, struct vm_area_struct **vmas)
>  {
> +	return __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
> +				       pages, vmas, NULL, false);
>  }

I'm wondering about that notify_drop parameter, what's the added
benefit? If you look at these 3 callers we can do away with it, since in
the second called where we have locked but !notify_drop we seem to do
the exact same thing afterwards anyway.
