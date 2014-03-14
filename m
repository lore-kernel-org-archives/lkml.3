Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaCNSRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:17:38 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:55252 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaCNSRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:17:37 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/3] workqueues: Account unbound workqueue in a seperate list
References: <1394815131-17271-1-git-send-email-fweisbec@gmail.com>
	<1394815131-17271-3-git-send-email-fweisbec@gmail.com>
Date: Fri, 14 Mar 2014 11:17:35 -0700
In-Reply-To: <1394815131-17271-3-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Fri, 14 Mar 2014 17:38:50 +0100")
Message-ID: <7hob18ir0g.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> The workqueues are all listed in a global list protected by a big mutex.
> And this big mutex is used in apply_workqueue_attrs() as well.
>
> Now as we plan to implement a directory to control the cpumask of
> all non-ABI unbound workqueues, we want to be able to iterate over all
> unbound workqueues and call apply_workqueue_attrs() for each of
> them with the new cpumask.
>
> But the risk for a deadlock is on the way: we need to iterate the list
> of workqueues under wq_pool_mutex. But then apply_workqueue_attrs()
> itself calls wq_pool_mutex.
>
> The easiest solution to work around this is to keep track of unbound
> workqueues in a separate list with a separate mutex.
>
> It's not very pretty unfortunately.
>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Mike Galbraith <bitbucket@online.de>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Not-Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/workqueue.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 4d230e3..ad8f727 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -232,6 +232,7 @@ struct wq_device;
>  struct workqueue_struct {
>  	struct list_head	pwqs;		/* WR: all pwqs of this wq */
>  	struct list_head	list;		/* PL: list of all workqueues */
> +	struct list_head	unbound_list;	/* PL: list of unbound workqueues */
>  
>  	struct mutex		mutex;		/* protects this wq */
>  	int			work_color;	/* WQ: current work color */
> @@ -288,9 +289,11 @@ static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */
>  static struct workqueue_attrs *wq_update_unbound_numa_attrs_buf;
>  
>  static DEFINE_MUTEX(wq_pool_mutex);	/* protects pools and workqueues list */
> +static DEFINE_MUTEX(wq_unbound_mutex);	/* protects list of unbound workqueues */
>  static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
>  
>  static LIST_HEAD(workqueues);		/* PL: list of all workqueues */
> +static LIST_HEAD(workqueues_unbound);	/* PL: list of unbound workqueues */
>  static bool workqueue_freezing;		/* PL: have wqs started freezing? */
>  
>  /* the per-cpu worker pools */
> @@ -4263,6 +4266,12 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
>  
>  	mutex_unlock(&wq_pool_mutex);
>  
> +	if (wq->flags & WQ_UNBOUND) {
> +		mutex_lock(&wq_unbound_mutex);
> +		list_add(&wq->unbound_list, &workqueues_unbound);
> +		mutex_unlock(&wq_unbound_mutex);
> +	}
> +
>  	return wq;
>  
>  err_free_wq:
> @@ -4318,6 +4327,12 @@ void destroy_workqueue(struct workqueue_struct *wq)
>  	list_del_init(&wq->list);
>  	mutex_unlock(&wq_pool_mutex);
>  
> +	if (wq->flags & WQ_UNBOUND) {
> +		mutex_lock(&wq_unbound_mutex);
> +		list_del(&wq->unbound_list);
> +		mutex_unlock(&wq_unbound_mutex);
> +	}
> +
>  	workqueue_sysfs_unregister(wq);
>  
>  	if (wq->rescuer) {

Looks good, except for minor nit: I think you're missing an init of the
new list:

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cc708f23d801..a01592f08321 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4309,6 +4309,7 @@ struct workqueue_struct
*__alloc_workqueue_key(const char *fmt,

        lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
        INIT_LIST_HEAD(&wq->list);
+       INIT_LIST_HEAD(&wq->unbound_list);

        if (alloc_and_link_pwqs(wq) < 0)
                goto err_free_wq;


Kevin
