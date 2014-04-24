Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbaDXWmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:42:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaDXWmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:42:32 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/4] workqueue: Create low-level unbound workqueues cpumask
References: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
	<1398350256-7834-2-git-send-email-fweisbec@gmail.com>
Date: Thu, 24 Apr 2014 15:42:28 -0700
In-Reply-To: <1398350256-7834-2-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Thu, 24 Apr 2014 16:37:33 +0200")
Message-ID: <7hy4yumjsb.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> Create a cpumask that limit the affinity of all unbound workqueues.
> This cpumask is controlled though a file at the root of the workqueue
> sysfs directory.
>
> It works on a lower-level than the per WQ_SYSFS workqueues cpumask files
> such that the effective cpumask applied for a given unbound workqueue is
> the intersection of /sys/devices/virtual/workqueue/$WORKQUEUE/cpumask and
> the new /sys/devices/virtual/workqueue/cpumask_unbounds file.
>
> This patch implements the basic infrastructure and the read interface.
> cpumask_unbounds is initially set to cpu_possible_mask.

For a nice default in the nohz_full case, how about this defaults to
!tick_nohz_full_mask? ...

[...]

> @@ -5033,6 +5055,9 @@ static int __init init_workqueues(void)
>  
>  	WARN_ON(__alignof__(struct pool_workqueue) < __alignof__(long long));
>  
> +	BUG_ON(!alloc_cpumask_var(&wq_unbound_cpumask, GFP_KERNEL));
> +	cpumask_copy(wq_unbound_cpumask, cpu_possible_mask);
> +

... so, something like this instead:

#ifdef CONFIG_NO_HZ_FULL
       cpumask_complement(wq_unbound_cpumask, tick_nohz_full_mask);
#else
       cpumask_copy(wq_unbound_cpumask, cpu_possible_mask);
#endif

Kevin

