Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaILJLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:11:50 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:58923 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaILJLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:11:47 -0400
MIME-Version: 1.0
In-Reply-To: <1409759373-22696-2-git-send-email-tomeu.vizoso@collabora.com>
References: <1409759373-22696-1-git-send-email-tomeu.vizoso@collabora.com> <1409759373-22696-2-git-send-email-tomeu.vizoso@collabora.com>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Fri, 12 Sep 2014 11:11:25 +0200
X-Google-Sender-Auth: N0Chd7jkP6lgZVSi-QxLWmjT2v8
Message-ID: <CAAObsKBkjqJiJ4OC4FYDXDBSFMFzvbvD_vJ6KzhqyyPCCB-o7g@mail.gmail.com>
Subject: Re: [REPOST PATCH v4 1/2] PM / QoS: Add PM_QOS_MEMORY_BANDWIDTH class
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?Q?Terje_Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        linux-pm@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 September 2014 17:49, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
> Also adds a class type PM_QOS_SUM that aggregates the values by summing them.
>
> It can be used by memory controllers to calculate the optimum clock frequency
> based on the bandwidth needs of the different memory clients.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Hi Rafael,

will you take this one for 3.18?

Thanks,

Tomeu

> ---
>
> v3: * Changed units to be megabits per second
> ---
>  Documentation/power/pm_qos_interface.txt |  4 +++-
>  include/linux/pm_qos.h                   |  5 ++++-
>  kernel/power/qos.c                       | 27 ++++++++++++++++++++++++++-
>  3 files changed, 33 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/power/pm_qos_interface.txt b/Documentation/power/pm_qos_interface.txt
> index a5da5c7..129f7c0 100644
> --- a/Documentation/power/pm_qos_interface.txt
> +++ b/Documentation/power/pm_qos_interface.txt
> @@ -5,7 +5,8 @@ performance expectations by drivers, subsystems and user space applications on
>  one of the parameters.
>
>  Two different PM QoS frameworks are available:
> -1. PM QoS classes for cpu_dma_latency, network_latency, network_throughput.
> +1. PM QoS classes for cpu_dma_latency, network_latency, network_throughput,
> +memory_bandwidth.
>  2. the per-device PM QoS framework provides the API to manage the per-device latency
>  constraints and PM QoS flags.
>
> @@ -13,6 +14,7 @@ Each parameters have defined units:
>   * latency: usec
>   * timeout: usec
>   * throughput: kbs (kilo bit / sec)
> + * memory bandwidth: mbs (mega bit / sec)
>
>
>  1. PM QoS framework
> diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
> index 9ab4bf7..636e828 100644
> --- a/include/linux/pm_qos.h
> +++ b/include/linux/pm_qos.h
> @@ -15,6 +15,7 @@ enum {
>         PM_QOS_CPU_DMA_LATENCY,
>         PM_QOS_NETWORK_LATENCY,
>         PM_QOS_NETWORK_THROUGHPUT,
> +       PM_QOS_MEMORY_BANDWIDTH,
>
>         /* insert new class ID */
>         PM_QOS_NUM_CLASSES,
> @@ -32,6 +33,7 @@ enum pm_qos_flags_status {
>  #define PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE       (2000 * USEC_PER_SEC)
>  #define PM_QOS_NETWORK_LAT_DEFAULT_VALUE       (2000 * USEC_PER_SEC)
>  #define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE        0
> +#define PM_QOS_MEMORY_BANDWIDTH_DEFAULT_VALUE  0
>  #define PM_QOS_RESUME_LATENCY_DEFAULT_VALUE    0
>  #define PM_QOS_LATENCY_TOLERANCE_DEFAULT_VALUE 0
>  #define PM_QOS_LATENCY_TOLERANCE_NO_CONSTRAINT (-1)
> @@ -69,7 +71,8 @@ struct dev_pm_qos_request {
>  enum pm_qos_type {
>         PM_QOS_UNITIALIZED,
>         PM_QOS_MAX,             /* return the largest value */
> -       PM_QOS_MIN              /* return the smallest value */
> +       PM_QOS_MIN,             /* return the smallest value */
> +       PM_QOS_SUM              /* return the sum */
>  };
>
>  /*
> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
> index 884b770..5f4c006 100644
> --- a/kernel/power/qos.c
> +++ b/kernel/power/qos.c
> @@ -105,11 +105,27 @@ static struct pm_qos_object network_throughput_pm_qos = {
>  };
>
>
> +static BLOCKING_NOTIFIER_HEAD(memory_bandwidth_notifier);
> +static struct pm_qos_constraints memory_bw_constraints = {
> +       .list = PLIST_HEAD_INIT(memory_bw_constraints.list),
> +       .target_value = PM_QOS_MEMORY_BANDWIDTH_DEFAULT_VALUE,
> +       .default_value = PM_QOS_MEMORY_BANDWIDTH_DEFAULT_VALUE,
> +       .no_constraint_value = PM_QOS_MEMORY_BANDWIDTH_DEFAULT_VALUE,
> +       .type = PM_QOS_SUM,
> +       .notifiers = &memory_bandwidth_notifier,
> +};
> +static struct pm_qos_object memory_bandwidth_pm_qos = {
> +       .constraints = &memory_bw_constraints,
> +       .name = "memory_bandwidth",
> +};
> +
> +
>  static struct pm_qos_object *pm_qos_array[] = {
>         &null_pm_qos,
>         &cpu_dma_pm_qos,
>         &network_lat_pm_qos,
> -       &network_throughput_pm_qos
> +       &network_throughput_pm_qos,
> +       &memory_bandwidth_pm_qos,
>  };
>
>  static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
> @@ -130,6 +146,9 @@ static const struct file_operations pm_qos_power_fops = {
>  /* unlocked internal variant */
>  static inline int pm_qos_get_value(struct pm_qos_constraints *c)
>  {
> +       struct plist_node *node;
> +       int total_value = 0;
> +
>         if (plist_head_empty(&c->list))
>                 return c->no_constraint_value;
>
> @@ -140,6 +159,12 @@ static inline int pm_qos_get_value(struct pm_qos_constraints *c)
>         case PM_QOS_MAX:
>                 return plist_last(&c->list)->prio;
>
> +       case PM_QOS_SUM:
> +               plist_for_each(node, &c->list)
> +                       total_value += node->prio;
> +
> +               return total_value;
> +
>         default:
>                 /* runtime check for not using enum */
>                 BUG();
> --
> 1.9.3
>
