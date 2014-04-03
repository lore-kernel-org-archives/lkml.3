Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162466AbaDCHHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:07:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61769 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162355AbaDCHHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:07:01 -0400
MIME-Version: 1.0
In-Reply-To: <1395940862-31428-4-git-send-email-fweisbec@gmail.com>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
	<1395940862-31428-4-git-send-email-fweisbec@gmail.com>
Date: Thu, 3 Apr 2014 12:37:00 +0530
Message-ID: <CAKohponsqy37v6ZfVt1eZtE5gdEFiNpQe1K-E=oJJGF5a+Fbxg@mail.gmail.com>
Subject: Re: [PATCH 3/4] workqueue: Add anon workqueue sysfs hierarchy
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

On 27 March 2014 22:51, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c

>  static int __init wq_sysfs_init(void)
>  {
> -       return subsys_virtual_register(&wq_subsys, NULL);
> +       struct device *anon_dev;
> +       int ret;
> +
> +       ret = subsys_virtual_register(&wq_subsys, NULL);
> +       if (ret < 0)
> +               return ret;
> +
> +       mutex_lock(&wq_unbound_mutex);
> +       cpumask_copy(&wq_anon_cpumask, cpu_possible_mask);
> +       mutex_unlock(&wq_unbound_mutex);
> +
> +       anon_dev = kzalloc(sizeof(*anon_dev), GFP_KERNEL);
> +       if (!anon_dev)
> +               return -ENOMEM;
> +
> +       anon_dev->bus = &wq_subsys;
> +       anon_dev->init_name = "anon_wqs";
> +       anon_dev->release = device_release;
> +
> +       ret = device_register(anon_dev);
> +       if (ret) {
> +               kfree(anon_dev);
> +               return ret;
> +       }
> +
> +       ret = device_create_file(anon_dev, &wq_sysfs_anon_attr);
> +       if (ret) {
> +               device_unregister(anon_dev);

kfree(anon_dev) ??

> +               return ret;
> +       }
> +
> +       kobject_uevent(&anon_dev->kobj, KOBJ_ADD);
> +
> +       return 0;
>  }
>  core_initcall(wq_sysfs_init);
