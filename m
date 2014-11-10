Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaKJJye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:54:34 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:51052 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaKJJyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:54:33 -0500
MIME-Version: 1.0
In-Reply-To: <1414597547-16506-1-git-send-email-tomeu.vizoso@collabora.com>
References: <20141029024426.GA7468@kroah.com>
	<1414597547-16506-1-git-send-email-tomeu.vizoso@collabora.com>
Date: Mon, 10 Nov 2014 15:24:32 +0530
Message-ID: <CAKohpokhS=+HpGuiM6GxJfCA4zknzpQ9N6LDREPXsURy-yxWWg@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: Guard against not-yet-initialized policies in cpufreq_cpu_get()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 October 2014 21:15, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
> There's a substantial window of opportunity from the time the policy objects
> are created until they are initialized, causing this:
>
> WARNING: CPU: 1 PID: 64 at include/linux/kref.h:47 kobject_get+0x64/0x70()
> Modules linked in:
> CPU: 1 PID: 64 Comm: irq/77-tegra-ac Not tainted 3.18.0-rc1-next-20141027ccu-00049-g21a0041 #248
> [<c0016fac>] (unwind_backtrace) from [<c001272c>] (show_stack+0x10/0x14)
> [<c001272c>] (show_stack) from [<c0601920>] (dump_stack+0x98/0xd8)
> [<c0601920>] (dump_stack) from [<c00288d8>] (warn_slowpath_common+0x70/0x8c)
> [<c00288d8>] (warn_slowpath_common) from [<c0028990>] (warn_slowpath_null+0x1c/0x24)
> [<c0028990>] (warn_slowpath_null) from [<c02227bc>] (kobject_get+0x64/0x70)
> [<c02227bc>] (kobject_get) from [<c03e5238>] (cpufreq_cpu_get+0x88/0xc8)
> [<c03e5238>] (cpufreq_cpu_get) from [<c03e52ec>] (cpufreq_get+0xc/0x64)
> [<c03e52ec>] (cpufreq_get) from [<c0287818>] (actmon_thread_isr+0x140/0x1a4)
> [<c0287818>] (actmon_thread_isr) from [<c0068a68>] (irq_thread_fn+0x1c/0x40)
> [<c0068a68>] (irq_thread_fn) from [<c0068d84>] (irq_thread+0x134/0x174)
> [<c0068d84>] (irq_thread) from [<c0040284>] (kthread+0xdc/0xf4)
> [<c0040284>] (kthread) from [<c000f4b8>] (ret_from_fork+0x14/0x3c)
>
> This commit checks that initialization has finished before trying to do
> anything with the policy.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  drivers/cpufreq/cpufreq.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 644b54e..7b84d1a 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -48,6 +48,9 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>  /* Flag to suspend/resume CPUFreq governors */
>  static bool cpufreq_suspended;
>
> +/* Flag that tells whether initialization is completed */
> +static atomic_t cpufreq_initialized = ATOMIC_INIT(0);
> +
>  static inline bool has_target(void)
>  {
>         return cpufreq_driver->target_index || cpufreq_driver->target;
> @@ -211,7 +214,7 @@ struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
>         /* get the cpufreq driver */
>         read_lock_irqsave(&cpufreq_driver_lock, flags);
>
> -       if (cpufreq_driver) {
> +       if (atomic_read(&cpufreq_initialized)) {
>                 /* get the CPU */
>                 policy = per_cpu(cpufreq_cpu_data, cpu);
>                 if (policy)
> @@ -1289,6 +1292,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>         kobject_uevent(&policy->kobj, KOBJ_ADD);
>         up_read(&cpufreq_rwsem);
>
> +       atomic_set(&cpufreq_initialized, 1);
> +
>         pr_debug("initialization complete\n");

Instead of all these:

Move:

        ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
                                   &dev->kobj, "cpufreq");

from cpufreq_add_dev_interface() to __cpufreq_add_dev() before
setting                 per_cpu(cpufreq_cpu_data, j) = policy;
