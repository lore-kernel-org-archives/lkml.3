Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbaLQEKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 23:10:44 -0500
Received: from mail-oi0-f52.google.com ([209.85.218.52]:38846 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaLQEKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 23:10:42 -0500
MIME-Version: 1.0
In-Reply-To: <1418771379-24369-2-git-send-email-dtor@chromium.org>
References: <1418771379-24369-1-git-send-email-dtor@chromium.org>
	<1418771379-24369-2-git-send-email-dtor@chromium.org>
Date: Wed, 17 Dec 2014 09:40:42 +0530
Message-ID: <CAKohponveD5W3=L5rd_vVjs2CTHcH93qS8S3H-Bg-S-DckiViA@mail.gmail.com>
Subject: Re: [PATCH 1/4] PM / OPP: add some lockdep annotations
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 December 2014 at 04:39, Dmitry Torokhov <dtor@chromium.org> wrote:
> Certain OPP APIs need to be called under RCU lock; let's add a few
> rcu_lockdep_assert() calls to warn about potential misuse.
>
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> ---
>  drivers/base/power/opp.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index d24dd614a..b78c14d 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -108,6 +108,14 @@ static LIST_HEAD(dev_opp_list);
>  /* Lock to allow exclusive modification to the device and opp lists */
>  static DEFINE_MUTEX(dev_opp_list_lock);
>
> +#define opp_rcu_lockdep_assert()                                       \
> +do {                                                                   \
> +       rcu_lockdep_assert(rcu_read_lock_held() ||                      \
> +                               lockdep_is_held(&dev_opp_list_lock),    \
> +                          "Missing rcu_read_lock() or "                \
> +                          "dev_opp_list_lock protection");             \
> +} while (0)
> +
>  /**
>   * find_device_opp() - find device_opp struct using device pointer
>   * @dev:       device pointer used to lookup device OPPs
> @@ -218,6 +226,8 @@ int dev_pm_opp_get_opp_count(struct device *dev)
>         struct dev_pm_opp *temp_opp;
>         int count = 0;
>
> +       opp_rcu_lockdep_assert();
> +
>         dev_opp = find_device_opp(dev);
>         if (IS_ERR(dev_opp)) {
>                 int r = PTR_ERR(dev_opp);
> @@ -267,6 +277,8 @@ struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
>         struct device_opp *dev_opp;
>         struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
>
> +       opp_rcu_lockdep_assert();
> +
>         dev_opp = find_device_opp(dev);
>         if (IS_ERR(dev_opp)) {
>                 int r = PTR_ERR(dev_opp);
> @@ -313,6 +325,8 @@ struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
>         struct device_opp *dev_opp;
>         struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
>
> +       opp_rcu_lockdep_assert();
> +
>         if (!dev || !freq) {
>                 dev_err(dev, "%s: Invalid argument freq=%p\n", __func__, freq);
>                 return ERR_PTR(-EINVAL);
> @@ -361,6 +375,8 @@ struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
>         struct device_opp *dev_opp;
>         struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
>
> +       opp_rcu_lockdep_assert();
> +
>         if (!dev || !freq) {
>                 dev_err(dev, "%s: Invalid argument freq=%p\n", __func__, freq);
>                 return ERR_PTR(-EINVAL);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
