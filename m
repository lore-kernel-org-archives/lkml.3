Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaDXPay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:30:54 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:53666 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaDXPaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:30:52 -0400
Date: Thu, 24 Apr 2014 11:30:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/4] workqueue: Allow modifying low level unbound
 workqueue cpumask
Message-ID: <20140424153048.GE14460@htj.dyndns.org>
References: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
 <1398350256-7834-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398350256-7834-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 04:37:35PM +0200, Frederic Weisbecker wrote:
> +static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
> +					const struct workqueue_attrs *attrs);

Can't we reorder things so that we don't need the above prototype?

> +/* Must be called with wq_unbound_mutex held */

Please use lockdep_assert_held() instead.

> +static int unbounds_cpumask_apply_all(cpumask_var_t cpumask)
> +{
> +	struct workqueue_struct *wq;
> +
> +	list_for_each_entry(wq, &workqueues, list) {
> +		struct workqueue_attrs *attrs;
> +
> +		if (!(wq->flags & WQ_UNBOUND))
> +			continue;
> +		/* Ordered workqueues need specific treatment */
> +		if (wq->flags & __WQ_ORDERED)
> +			continue;
> +
> +		attrs = wq_sysfs_prep_attrs(wq);
> +		if (!attrs)
> +			return -ENOMEM;

So, we're failing in the middle without rolling back?

> +
> +		WARN_ON_ONCE(apply_workqueue_attrs_locked(wq, attrs));

Are we triggering WARN on -ENOMEM too and then ignore the failure?

> +		free_workqueue_attrs(attrs);
> +	}
> +
> +	return 0;
> +}

Shouldn't we separate allocation stage from switching stage so that we
can either succeed or fail?  The above is very mushy about error
handling.

Thanks.

-- 
tejun
