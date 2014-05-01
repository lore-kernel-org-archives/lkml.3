Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaEAOkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:40:31 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:56204 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaEAOka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:40:30 -0400
Date: Thu, 1 May 2014 16:40:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/4] workqueue: Split apply attrs code from its locking
Message-ID: <20140501144018.GA25369@localhost.localdomain>
References: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
 <1398350256-7834-3-git-send-email-fweisbec@gmail.com>
 <20140424144832.GD14460@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424144832.GD14460@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:48:32AM -0400, Tejun Heo wrote:
> On Thu, Apr 24, 2014 at 04:37:34PM +0200, Frederic Weisbecker wrote:
> > +static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
> > +					const struct workqueue_attrs *attrs)
> >  {
> >  	struct workqueue_attrs *new_attrs, *tmp_attrs;
> >  	struct pool_workqueue **pwq_tbl, *dfl_pwq;
> > @@ -3976,15 +3960,6 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
> >  	copy_workqueue_attrs(tmp_attrs, new_attrs);
> >  
> >  	/*
> > -	 * CPUs should stay stable across pwq creations and installations.
> > -	 * Pin CPUs, determine the target cpumask for each node and create
> > -	 * pwqs accordingly.
> > -	 */
> > -	get_online_cpus();
> > -
> > -	mutex_lock(&wq_pool_mutex);
> 
> lockdep_assert_held()

Not sure... Only a small part of the function actually needs to be locked. Namely
those doing the pwq allocations, which already have the lockdep_assert_held().
