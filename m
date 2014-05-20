Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaETMcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:32:51 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:65178 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaETMct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomKvPcioNmfzvx7vqJHqs_TrhnHH6yYb5w_0f+YvA5hvA@mail.gmail.com>
References: <1400230809-11401-1-git-send-email-chander.kashyap@linaro.org>
	<537A0247.1030503@ti.com>
	<CAKohpoknoFuz8qnDpunA7oxr5E_18=+EQsFEy0P39fcU=4Ps9w@mail.gmail.com>
	<CAGo_u6o+Vysq0LkdFTrP82WOpS1TT-=MD+zgP+Q_L=3RV8x5hA@mail.gmail.com>
	<CAKohponAx=Hi_Ywgg4hXxrpmmaqy5=pYnb3nSBNUP3KtADTEeA@mail.gmail.com>
	<CAKohpomKvPcioNmfzvx7vqJHqs_TrhnHH6yYb5w_0f+YvA5hvA@mail.gmail.com>
Date: Tue, 20 May 2014 07:32:48 -0500
X-Google-Sender-Auth: 1OQb9a3cvo6KciWVwiQtJDE2BQg
Message-ID: <CAGo_u6pJ0n5Z1-aXdGfh6RNgoe=Pp_9Xaf3sDK6zss1t=qU57Q@mail.gmail.com>
Subject: Re: [PATCH v3] PM / OPP: discard duplicate OPPs
From: Nishanth Menon <nm@ti.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Chander Kashyap <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 7:05 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 20 May 2014 16:56, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> But we aren't talking about failure here. Its not failure. The operation
>> we are trying to do is already done and nothing should break if the
>> OPP was already there or its added now. Its all the same.
>
> Though after more thought into this I feel this must also be done:
>
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index bdf09f5..3f540d8 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -453,9 +453,13 @@ int dev_pm_opp_add(struct device *dev, unsigned
> long freq, unsigned long u_volt)
>         }
>
>         if (new_opp->rate == opp->rate) {
> +               int ret = 0;
> +
> +               if (new_opp->u_volt == opp->u_volt)
> +                       ret = -EEXIST;
Else -> we now have two OPPs with the same key (same frequency, but
different voltage) -> That does not make sense.
Example: why would you add:
If you already had {1GHz, 1.2V}
and you attempted:
{1GHz, 1.1V} (if you could do that, then you should added {1GHz, 1.1V}
in the first place)
OR
{1GHz, 1.3V} (if you could do that, then you should add {1GHz, 1.3V}
and the {1GHz, 1.2V} is wrong)


In addition, if old OPP was disabled, that new OPP would be in enabled
state -> which also does not make sense either - since we disabled
that frequency for some reason.

>                 mutex_unlock(&dev_opp_list_lock);
>                 kfree(new_opp);
> -               return 0;
> +               return ret;
>         }
>
>         list_add_rcu(&new_opp->node, head);

The reason I ask to return error is because if we attempt to add two
OPPs with the same key (frequency), then it breaks the logic in
remaining search logic.


Regards,
Nishanth Menon
