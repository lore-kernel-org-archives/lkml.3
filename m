Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaCSFEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 01:04:47 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:55462 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaCSFEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 01:04:45 -0400
MIME-Version: 1.0
In-Reply-To: <1395163361-26380-2-git-send-email-dirk.j.brandewie@intel.com>
References: <1394831037-15553-1-git-send-email-dirk.j.brandewie@intel.com>
	<1395163361-26380-1-git-send-email-dirk.j.brandewie@intel.com>
	<1395163361-26380-2-git-send-email-dirk.j.brandewie@intel.com>
Date: Wed, 19 Mar 2014 10:34:45 +0530
Message-ID: <CAKohpo=zbtuHfNwbKFgfoNgn3c+bBfZYMBBWenCac2=gk2AWqw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: Add stop callback to cpufreq_driver interface
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Patrick Marlier <patrick.marlier@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 March 2014 22:52,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>
> This callback allows the driver to do clean up before the CPU is
> completely down and its state cannot be modified.  This is used
> by the intel_pstate driver to reduce the requested P state prior to
> the core going away.  This is required because the requested P state
> of the offline core is used to select the package P state. This
> effectively sets the floor package P state to the requested P state on
> the offline core.
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  Documentation/cpu-freq/cpu-drivers.txt | 8 +++++++-
>  drivers/cpufreq/cpufreq.c              | 3 ++-
>  include/linux/cpufreq.h                | 1 +
>  3 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
> index 8b1a445..79def80 100644
> --- a/Documentation/cpu-freq/cpu-drivers.txt
> +++ b/Documentation/cpu-freq/cpu-drivers.txt
> @@ -61,7 +61,13 @@ target_index         -       See below on the differences.
>
>  And optionally
>
> -cpufreq_driver.exit -          A pointer to a per-CPU cleanup function.
> +cpufreq_driver.exit -          A pointer to a per-CPU cleanup
> +                               function called during CPU_POST_DEAD
> +                               phase of cpu hotplug process.
> +
> +cpufreq_driver.stop -          A pointer to a per-CPU stop function
> +                               called during CPU_DOWN_PREPARE phase of
> +                               cpu hotplug process.
>
>  cpufreq_driver.resume -                A pointer to a per-CPU resume function
>                                 which is called with interrupts disabled
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index cf485d9..6e6beae 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1336,7 +1336,8 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>                                                 __func__, new_cpu, cpu);
>                         }
>                 }
> -       }
> +       } else if (cpufreq_driver->stop)
> +               cpufreq_driver->stop(policy);
>
>         return 0;
>  }
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 4d89e0e..ff8db19 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -224,6 +224,7 @@ struct cpufreq_driver {
>         int     (*bios_limit)   (int cpu, unsigned int *limit);
>
>         int     (*exit)         (struct cpufreq_policy *policy);
> +       int     (*stop)         (struct cpufreq_policy *policy);
>         int     (*suspend)      (struct cpufreq_policy *policy);
>         int     (*resume)       (struct cpufreq_policy *policy);
>         struct freq_attr        **attr;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
