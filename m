Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbaEMOza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:55:30 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34564 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933752AbaEMOz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:55:27 -0400
Date: Tue, 13 May 2014 16:55:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 6/6] workqueue: Record real per-workqueue cpumask
Message-ID: <20140513145519.GA13828@localhost.localdomain>
References: <1399480621-19555-1-git-send-email-fweisbec@gmail.com>
 <1399480621-19555-7-git-send-email-fweisbec@gmail.com>
 <CACvQF526QozPynmw46k36qZvPJFU1Tk0S5ii35zMH7dhCYNUzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF526QozPynmw46k36qZvPJFU1Tk0S5ii35zMH7dhCYNUzg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 09:20:45PM +0800, Lai Jiangshan wrote:
> On Thu, May 8, 2014 at 12:37 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > The real cpumask set by the user on WQ_SYSFS workqueues fails to be
> > recorded as is: What is actually recorded as per workqueue attribute
> > is the per workqueue cpumask intersected with the global unbounds cpumask.
> >
> > Eventually when the user overwrites a WQ_SYSFS cpumask and later read
> > this attibute, the value returned is not the last one written.
> >
> > The other bad side effect is that widening the global unbounds cpumask
> > doesn't actually widen the unbound workqueues affinity because their
> > own cpumask has been schrinked.
> >
> > In order to fix this, lets record the real per workqueue cpumask on the
> > workqueue struct. We restore this value when attributes are re-evaluated
> > later.
> >
> > FIXME: Maybe I should rather invert that. Have the user set workqueue
> > cpumask on attributes and the effective one on the workqueue struct instead.
> > We'll just need some tweaking in order to make the attributes of lower layers
> > (pools, worker pools, worker, ...) to inherit the effective cpumask and not
> > the user one.
> >
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: Mike Galbraith <bitbucket@online.de>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/workqueue.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index 5978cee..504cf0a 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -248,6 +248,7 @@ struct workqueue_struct {
> >         int                     saved_max_active; /* WQ: saved pwq max_active */
> >
> >         struct workqueue_attrs  *unbound_attrs; /* WQ: only for unbound wqs */
> > +       cpumask_var_t           saved_cpumask;  /* WQ: only for unbound wqs */
> 
> 
> Forgot to use it? or use it in next patches?

Hmm, no it's used below.

> 
> >         struct pool_workqueue   *dfl_pwq;       /* WQ: only for unbound wqs */
> >
> >  #ifdef CONFIG_SYSFS
> > @@ -3694,6 +3695,7 @@ static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
> >         mutex_lock(&wq->mutex);
> >
> >         copy_workqueue_attrs(wq->unbound_attrs, new_attrs);
> > +       cpumask_copy(wq->saved_cpumask, attrs->cpumask);
> 
> I think you can use ->unbound_attrs directly:
>           copy_workqueue_attrs(wq->unbound_attrs, attrs);
> 
> and update wq_update_unbound_numa():
>          copy_workqueue_attrs(tmp_attrs, wq->unbound_attrs);
>          cpumask_and(&tmp_attrs->cpumask, wq_unbound_cpumask)
> 
> use tmp_attr instead of wq->unbound_attrs in the left code of
> wq_update_unbound_numa()

But wq_update_unbound_numa() is only called on cpu hotplug operations
right? So this may have no effect after setting a cpumask in sysfs.

How about keeping the sysfs cpu in wq's unbound_attrs but pass the effective
one to pwq creation in apply_workqueue_attrs_locked.

And also do what you suggest in wq_update_unbound_numa for hotplug
operations.
