Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162387AbaDCHJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:09:40 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:44213 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162361AbaDCHJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:09:38 -0400
MIME-Version: 1.0
In-Reply-To: <1395940862-31428-2-git-send-email-fweisbec@gmail.com>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
	<1395940862-31428-2-git-send-email-fweisbec@gmail.com>
Date: Thu, 3 Apr 2014 12:39:37 +0530
Message-ID: <CAKohpok=W_302w2yhof_x6LnB6Eqxvr8MOKjm13bUmhJT3RZ+A@mail.gmail.com>
Subject: Re: [PATCH 1/4] workqueue: Move workqueue bus attr to device attribute
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing much, just some nitpicks :)

On 27 March 2014 22:50, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> A workqueue directory implements at least two files: max_active and
> per_cpu. Since thse are constant over WQ_SYSFS workqueues, they are

s/thse/these

> implemented as bus attributes.

> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 193e977..4d230e3 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3133,7 +3133,6 @@ static ssize_t per_cpu_show(struct device *dev, struct device_attribute *attr,
>
>         return scnprintf(buf, PAGE_SIZE, "%d\n", (bool)!(wq->flags & WQ_UNBOUND));
>  }
> -static DEVICE_ATTR_RO(per_cpu);
>
>  static ssize_t max_active_show(struct device *dev,
>                                struct device_attribute *attr, char *buf)
> @@ -3156,14 +3155,12 @@ static ssize_t max_active_store(struct device *dev,
>         workqueue_set_max_active(wq, val);
>         return count;
>  }
> -static DEVICE_ATTR_RW(max_active);
>
> -static struct attribute *wq_sysfs_attrs[] = {
> -       &dev_attr_per_cpu.attr,
> -       &dev_attr_max_active.attr,
> -       NULL,
> +static struct device_attribute wq_sysfs_default_attrs[] = {
> +       __ATTR(per_cpu, 0444, per_cpu_show, NULL),
> +       __ATTR(max_active, 0644, max_active_show, max_active_store),
> +       __ATTR_NULL,
>  };
> -ATTRIBUTE_GROUPS(wq_sysfs);
>
>  static ssize_t wq_pool_ids_show(struct device *dev,
>                                 struct device_attribute *attr, char *buf)
> @@ -3313,7 +3310,6 @@ static struct device_attribute wq_sysfs_unbound_attrs[] = {
>
>  static struct bus_type wq_subsys = {
>         .name                           = "workqueue",
> -       .dev_groups                     = wq_sysfs_groups,
>  };
>
>  static int __init wq_sysfs_init(void)
> @@ -3346,6 +3342,7 @@ static void wq_device_release(struct device *dev)
>   */
>  int workqueue_sysfs_register(struct workqueue_struct *wq)
>  {
> +       struct device_attribute *attr;
>         struct wq_device *wq_dev;
>         int ret;
>
> @@ -3379,8 +3376,16 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
>                 return ret;
>         }
>
> +       for (attr = wq_sysfs_default_attrs; attr->attr.name; attr++) {
> +               ret = device_create_file(&wq_dev->dev, attr);
> +               if (ret) {
> +                       device_unregister(&wq_dev->dev);
> +                       wq->wq_dev = NULL;
> +                       return ret;
> +               }
> +       }

Exactly same as below loop, probably create a routine for this?

>         if (wq->flags & WQ_UNBOUND) {
> -               struct device_attribute *attr;
>

probably remove this blank line as well..

>                 for (attr = wq_sysfs_unbound_attrs; attr->attr.name; attr++) {
>                         ret = device_create_file(&wq_dev->dev, attr);
> --
> 1.8.3.1
>
