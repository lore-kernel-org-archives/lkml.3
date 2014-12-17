Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaLQE2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 23:28:20 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:42928 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaLQE2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 23:28:18 -0500
MIME-Version: 1.0
In-Reply-To: <1418771379-24369-3-git-send-email-dtor@chromium.org>
References: <1418771379-24369-1-git-send-email-dtor@chromium.org>
	<1418771379-24369-3-git-send-email-dtor@chromium.org>
Date: Wed, 17 Dec 2014 09:58:17 +0530
Message-ID: <CAKohpok+_wee9HwvQqpn7HRj_9zH3EifNn0MX_1yXx=WJuK0RQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] PM / OPP: fix warning in of_free_opp_table
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
> Not having OPP defined for a device is not a crime, we should not splat
> warning in this case. Also, it seems that we are ready to accept invalid
> dev (find_device_opp will return ERR_PTR(-EINVAL) then) so let's not
> crash in dev_name() in such case.
>
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> ---
>  drivers/base/power/opp.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index b78c14d..413c7fe 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -799,9 +799,15 @@ void of_free_opp_table(struct device *dev)
>
>         /* Check for existing list for 'dev' */
>         dev_opp = find_device_opp(dev);
> -       if (WARN(IS_ERR(dev_opp), "%s: dev_opp: %ld\n", dev_name(dev),
> -                PTR_ERR(dev_opp)))
> +       if (IS_ERR(dev_opp)) {
> +               int error = PTR_ERR(dev_opp);
> +               if (error != -ENODEV)
> +                       WARN(1, "%s: dev_opp: %ld\n",
> +                            IS_ERR_OR_NULL(dev) ?
> +                                       "Invalid device" : dev_name(dev),
> +                            error);
>                 return;

What about this:

        if (IS_ERR(dev_opp)) {
                int error = PTR_ERR(dev_opp);
                WARN(error != -ENODEV, "%s: dev_opp: %ld\n",
                     IS_ERR_OR_NULL(dev) ?  "Invalid device" : dev_name(dev),
                     error);
                return;
        }

We can get rid of the extra indentation level and an extra comparison check.

Otherwise:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
