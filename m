Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3DOOKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:10:44 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:42952 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3DOOKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:10:42 -0400
MIME-Version: 1.0
In-Reply-To: <1366007087-12090-1-git-send-email-amit.daniel@samsung.com>
References: <1366007087-12090-1-git-send-email-amit.daniel@samsung.com>
Date: Mon, 15 Apr 2013 09:10:40 -0500
X-Google-Sender-Auth: vpxTZ8LXivPVFoOeSwBNQmzDEeM
Message-ID: <CAGo_u6qD5hO7x0fYwe+cZ5GHRA6tRG+vmhnf4GFjt9G0inQ0xA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: exynos5440: Protect opp search calls with rcu lock
From: Nishanth Menon <nm@ti.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kukjin Kim <kgene.kim@samsung.com>,
        lkml <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,
On Mon, Apr 15, 2013 at 1:24 AM, Amit Daniel Kachhap
<amit.daniel@samsung.com> wrote:
> As per the OPP library documentation(Documentation/power/opp.txt) all
> opp find/get calls should be protected by rcu locks.
>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>
> This patch is created against linux-next tree and is suggested by
> Nishanth Menon. (https://lkml.org/lkml/2013/4/12/119)
>
>  drivers/cpufreq/exynos5440-cpufreq.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
> index ead7ed4..0c74018 100644
> --- a/drivers/cpufreq/exynos5440-cpufreq.c
> +++ b/drivers/cpufreq/exynos5440-cpufreq.c
> @@ -120,11 +120,13 @@ static int init_div_table(void)
>         int i = 0;
>         struct opp *opp;
>
> +       rcu_read_lock();
>         for (i = 0; freq_tbl[i].frequency != CPUFREQ_TABLE_END; i++) {
>
>                 opp = opp_find_freq_exact(dvfs_info->dev,
>                                         freq_tbl[i].frequency * 1000, true);
>                 if (IS_ERR(opp)) {
> +                       rcu_read_unlock();
>                         dev_err(dvfs_info->dev,
>                                 "failed to find valid OPP for %u KHZ\n",
>                                 freq_tbl[i].frequency);
> @@ -159,6 +161,7 @@ static int init_div_table(void)
>                 __raw_writel(tmp, dvfs_info->base + XMU_PMU_P0_7 + 4 * i);
>         }
>
> +       rcu_read_unlock();

Is it not possible to reduce the amount of code protected by RCU lock?
something like this:
+               rcu_read_lock();
                opp = opp_find_freq_exact(dvfs_info->dev,
                                        freq_tbl[i].frequency * 1000, true);
                if (IS_ERR(opp)) {
+                       rcu_read_unlock();
                        dev_err(dvfs_info->dev,
                                "failed to find valid OPP for %u KHZ\n",
                                freq_tbl[i].frequency);
                        return PTR_ERR(opp);
                }
+               volt_id = opp_get_voltage(opp);
+               rcu_unlock();
