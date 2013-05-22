Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab3EVJZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:25:04 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55348
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255Ab3EVJZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:25:02 -0400
Date: Wed, 22 May 2013 11:24:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/9] liblockdep: Support using LD_PRELOAD
Message-ID: <20130522092453.GH18810@twins.programming.kicks-ass.net>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
 <1368674141-10796-8-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368674141-10796-8-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:15:39PM -0400, Sasha Levin wrote:
> +static struct lock_lookup __locks[LIBLOCKDEP_STATIC_ENTRIES];
> +static int __locks_nr;
> +
> +static inline bool is_static_lock(struct lock_lookup *lock)
> +{
> +	return lock >= __locks && lock < __locks + ARRAY_SIZE(__locks);
> +}
> +
> +static struct lock_lookup *alloc_lock(void)
> +{
> +	if (__init_state != done) {
> +		/*
> +		 * Some programs attempt to initialize and use locks in their
> +		 * allocation path. This means that a call to malloc() would
> +		 * result in locks being initialized and locked.
> +		 *
> +		 * Why is it an issue for us? dlsym() below will try allocating
> +		 * to give us the original function. Since this allocation will
> +		 * result in a locking operations, we have to let pthread deal
> +		 * with it, but we can't! we don't have the pointer to the
> +		 * original API since we're inside dlsym() trying to get it 
> +		 */
> +
> +		int idx = __locks_nr++;
> +		if (idx >= ARRAY_SIZE(__locks)) {
> +			fprintf(stderr,
> +		"LOCKDEP error: insufficient LIBLOCKDEP_STATIC_ENTRIES\n");
> +			exit(EX_UNAVAILABLE);
> +		}
> +		return __locks + idx;
> +	}
> +
> +	return malloc(sizeof(struct lock_lookup));
> +}

Do we still need this with the glibc __pthread_* static initialization?
