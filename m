Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaJCKlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 06:41:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12322 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaJCKlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 06:41:23 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-28-542e7d50b04f
Date: Fri, 03 Oct 2014 12:40:54 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] thermal: core: fix: Check return code of the
 ->get_max_state() callback
Message-id: <20141003124054.404ac26c@amdc2363>
In-reply-to: <20141002222441.GA11510@developer>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1411547232-21493-4-git-send-email-l.majewski@samsung.com>
 <20141002222441.GA11510@developer>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jQd2AWr0Qg5VPrCw2zljPajH/yjVW
	izePuC0u75rDZvG59wijxZOHfWwObB47Z91l91i85yWTx7ppb5k9+rasYvT4vEkugDWKyyYl
	NSezLLVI3y6BK2P+2SfsBVNFKuZubmNrYPzO38XIySEhYCLR/PwYG4QtJnHh3nogm4tDSGA6
	o8SuzzfAEkICvxgl7p8Da2ARUJXYsnYfE4jNJqAn8fnuUzBbRMBb4vW+6YwgzcwC6xglFu3f
	xQySEBZIkngz/zsLiM0L1PD4fC/YUE4BfYnelvfMENtWMEpMfjQZLMEvICnR/u8HM8RJdhLn
	Pm1gh2gWlPgx+R7YIGYBLYnN25pYIWx5ic1r3jJPYBSchaRsFpKyWUjKFjAyr2IUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQIDvpn0jsYVzVYHGIU4GBU4uH9cEM3RIg1say4MvcQowQHs5II
	768CvRAh3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjEbd
	uvPsY7facTyfpMRwTWCGxYarX49Fujx+s/zpTO8zoldPF5xUsD/3WNe9VzUp+/aswwwLtEW+
	HBKxZOH/yCdjw/nyYuPycKHvVROkVYtEdsedXvfk+OyjnAcjj7lP/vc1bWHV1k+zXj5Yttaa
	wW3HCylLb6Gvnh4637ylrCas2l+UJ8uTtUeJpTgj0VCLuag4EQADGosHdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo, Rui,

> On Wed, Sep 24, 2014 at 10:27:12AM +0200, Lukasz Majewski wrote:
> > Without this check it was possible to execute cooling device
> > binding code even when wrong max cooling state was read.
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> 
> Acked-by: Eduardo Valentin <edubezval@gmail.com>
> 
> Rui, are you taking these patches? Do you prefer me to collect them?

I'd like to ask you NOT to apply those patches.

In short: It will cause regression on all non Exynos boards.

Explanation:

Up till now the cpu_cooling device was bind even when the
get_max_state() returned -EINVAL and everything worked after late
cpufreq policy initialization.

However, during this time window the thermal driver is not properly
configured.

Applying PATCH2/3 and PATCH3/3 would cause bind error without any
further occasion for re-bind. As a result THERAL will not be present
on the target system.

It works on the Exynos boards, since at the report_trigger() function, 
when first trip point is reached, it is checked if cpu_cooling device
is bind. If it is not (due to "fixes" at PATCH2/3 and PATCH3/3) it
is rebind then.

Due to above, I think that it would be best to leave things as they are
now and prepare proper fix as suggested by Eduardo.

> 
> Cheers
> 
> Eduardo
> 
> > ---
> >  drivers/thermal/thermal_core.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/thermal/thermal_core.c
> > b/drivers/thermal/thermal_core.c index 747618a..8a4dc35 100644
> > --- a/drivers/thermal/thermal_core.c
> > +++ b/drivers/thermal/thermal_core.c
> > @@ -928,7 +928,7 @@ int thermal_zone_bind_cooling_device(struct
> > thermal_zone_device *tz, struct thermal_zone_device *pos1;
> >  	struct thermal_cooling_device *pos2;
> >  	unsigned long max_state = 0;
> > -	int result;
> > +	int result, ret;
> >  
> >  	if (trip >= tz->trips || (trip < 0 && trip !=
> > THERMAL_TRIPS_NONE)) return -EINVAL;
> > @@ -945,7 +945,9 @@ int thermal_zone_bind_cooling_device(struct
> > thermal_zone_device *tz, if (tz != pos1 || cdev != pos2)
> >  		return -EINVAL;
> >  
> > -	cdev->ops->get_max_state(cdev, &max_state);
> > +	ret = cdev->ops->get_max_state(cdev, &max_state);
> > +	if (ret)
> > +		return ret;
> >  
> >  	/* lower default 0, upper default max_state */
> >  	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
> > -- 
> > 2.0.0.rc2
> > 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
