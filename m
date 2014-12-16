Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaLPFdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 00:33:35 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:54344 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaLPFdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 00:33:33 -0500
MIME-Version: 1.0
In-Reply-To: <20141216005048.GA3802@dtor-ws>
References: <20141216005048.GA3802@dtor-ws>
Date: Tue, 16 Dec 2014 11:03:33 +0530
Message-ID: <CAKohpok+b36_7SAUZmgM6jdtiWNu01u_0U4zQqE1b3B4xh0Svw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: imx6: prorect calls to dev_pm_opp_get_opp_count
 with RCU lock
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Shawn Guo <shawn.guo@freescale.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Anson Huang <b20788@freescale.com>,
        John Tobias <john.tobias.ph@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 December 2014 at 06:20, Dmitry Torokhov <dtor@chromium.org> wrote:
> dev_pm_opp_get_opp_count() must be called with RCU lock held.
>
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> ---
>
> Not tested at all...
>
>  drivers/cpufreq/imx6q-cpufreq.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
> index 380a90d..851d4fd 100644
> --- a/drivers/cpufreq/imx6q-cpufreq.c
> +++ b/drivers/cpufreq/imx6q-cpufreq.c
> @@ -200,7 +200,9 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
>          * Just, incase the platform did not supply the OPP
>          * table, it will try to get it.
>          */
> +       rcu_read_lock();
>         num = dev_pm_opp_get_opp_count(cpu_dev);
> +       rcu_read_unlock();
>         if (num < 0) {
>                 ret = of_init_opp_table(cpu_dev);
>                 if (ret < 0) {
> @@ -211,7 +213,9 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
>                 /* Because we have added the OPPs here, we must free them */
>                 free_opp = true;
>
> +               rcu_read_lock();
>                 num = dev_pm_opp_get_opp_count(cpu_dev);
> +               rcu_read_unlock();
>                 if (num < 0) {
>                         ret = num;
>                         dev_err(cpu_dev, "no OPP table is found: %d\n", ret);

This one looks fine for sure but I was wondering for the users which just
need to call opp-count from under the locks, what about something like:

dev_pm_opp_get_opp_count_locked() ?

--
viresh
