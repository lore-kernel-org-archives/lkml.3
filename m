Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbaEITkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:40:25 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49507 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaEITkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:40:24 -0400
Date: Fri, 9 May 2014 12:40:21 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH percpu/for-3.16 2/2] percpu-refcount: implement
 percpu_ref_tryget()
Message-ID: <20140509194020.GB2276@kmo>
References: <20140507155511.GB26540@htj.dyndns.org>
 <20140507155647.GC26540@htj.dyndns.org>
 <20140507155810.GD26540@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507155810.GD26540@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:58:10AM -0400, Tejun Heo wrote:
> Implement percpu_ref_tryget() which fails if the refcnt already
> reached zero.  Note that this is different from the recently renamed
> percpu_ref_tryget_live() which fails if the refcnt has been killed and
> is draining the remaining references.  percpu_ref_tryget() succeeds on
> a killed refcnt as long as its current refcnt is above zero.

I'd still kind of prefer tryget() to be labelled "deprecated, don't use outside
the cgroup code" or somesuch, but it's not a huge deal :)

Acked-by: Kent Overstreet <kmo@daterainc.com>

> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kent Overstreet <kmo@daterainc.com>
> ---
>  include/linux/percpu-refcount.h |   32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> --- a/include/linux/percpu-refcount.h
> +++ b/include/linux/percpu-refcount.h
> @@ -118,6 +118,36 @@ static inline void percpu_ref_get(struct
>  }
>  
>  /**
> + * percpu_ref_tryget - try to increment a percpu refcount
> + * @ref: percpu_ref to try-get
> + *
> + * Increment a percpu refcount unless its count already reached zero.
> + * Returns %true on success; %false on failure.
> + *
> + * The caller is responsible for ensuring that @ref stays accessible.
> + */
> +static inline bool percpu_ref_tryget(struct percpu_ref *ref)
> +{
> +	unsigned __percpu *pcpu_count;
> +	int ret = false;
> +
> +	rcu_read_lock_sched();
> +
> +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> +
> +	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR)) {
> +		__this_cpu_inc(*pcpu_count);
> +		ret = true;
> +	} else {
> +		ret = atomic_inc_not_zero(&ref->count);
> +	}
> +
> +	rcu_read_unlock_sched();
> +
> +	return ret;
> +}
> +
> +/**
>   * percpu_ref_tryget_live - try to increment a live percpu refcount
>   * @ref: percpu_ref to try-get
>   *
> @@ -128,6 +158,8 @@ static inline void percpu_ref_get(struct
>   * will fail.  For such guarantee, percpu_ref_kill_and_confirm() should be
>   * used.  After the confirm_kill callback is invoked, it's guaranteed that
>   * no new reference will be given out by percpu_ref_tryget().
> + *
> + * The caller is responsible for ensuring that @ref stays accessible.
>   */
>  static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
>  {
