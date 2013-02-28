Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3B1G6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:58:15 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:35000 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3B1G6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:58:14 -0500
MIME-Version: 1.0
In-Reply-To: <512E45E9.5020801@semaphore.gr>
References: <512E45E9.5020801@semaphore.gr>
Date: Thu, 28 Feb 2013 12:28:11 +0530
X-Google-Sender-Auth: zdmltFduYSKUVyek0nnt2RERVwE
Message-ID: <CAOh2x==vxM+qoebcUGNca50oeszwnqSfSzVPSEOyS6GKENudeg@mail.gmail.com>
Subject: Re: [PATCH linux-next] cpufreq: governors: Calculate iowait time only
 when necessary
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 11:14 PM, Stratos Karafotis
<stratosk@semaphore.gr> wrote:
> Currently we always calculate the CPU iowait time and add it to idle time.
> If we are in ondemand and we use io_is_busy, we re-calculate iowait time
> and we subtract it from idle time.
>
> With this patch iowait time is calculated only when necessary avoiding
> the double call to get_cpu_iowait_time_us. We use a parameter in
> function get_cpu_idle_time to distinguish when the iowait time will be
> added to idle time or not, without the need of keeping the prev_io_wait.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq_conservative.c |  2 +-
>  drivers/cpufreq/cpufreq_governor.c     | 46 +++++++++++++---------------------
>  drivers/cpufreq/cpufreq_governor.h     |  3 +--
>  drivers/cpufreq/cpufreq_ondemand.c     | 11 +++++++-
>  4 files changed, 29 insertions(+), 33 deletions(-)

I have really spent some 10-15 minutes reviewing this patch as initially it
looked to me like something is missing here and calculations are going wrong.

But it was fine :)


> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index f3eb26c..46be2c4 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -339,11 +339,20 @@ static ssize_t store_io_is_busy(struct kobject *a, struct attribute *b,
>  {

> +       /* we need to re-evaluate prev_cpu_idle */
> +       for_each_online_cpu(j) {
> +               struct od_cpu_dbs_info_s *dbs_info;
> +               dbs_info = &per_cpu(od_cpu_dbs_info, j);

Probably squash above two lines and give a blank line after it.

> +               dbs_info->cdbs.prev_cpu_idle = get_cpu_idle_time(j,
> +                       &dbs_info->cdbs.prev_cpu_wall, od_tuners.io_is_busy);
> +       }
>         return count;
>  }

And after that add my:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
