Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3H3M1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:27:21 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3602 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3H3M1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:27:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 30 Aug 2013 05:27:19 -0700
From: Daniel Fu <danifu@nvidia.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johnny Qiu <joqiu@nvidia.com>
Date: Fri, 30 Aug 2013 20:26:34 +0800
Subject: RE: [PATCH] cpuidle: Check cpuidle driver before add refcount
Thread-Topic: [PATCH] cpuidle: Check cpuidle driver before add refcount
Thread-Index: Ac6ldwNh+K3U/P3JRd6meJU5PctIZgAAOWLg
Message-ID: <D9A2FA38A1E15B4E832469E5FE40C7ABFB5833359F@HKMAIL01.nvidia.com>
References: <1377863302-22465-1-git-send-email-danifu@nvidia.com>
 <2041584.4YznqfT0Od@vostro.rjw.lan>
In-Reply-To: <2041584.4YznqfT0Od@vostro.rjw.lan>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7UCRPcB023955

X-NVConfidentiality: public

In SMP, When doing the cpuidle driver registration. There maybe only 1 cpu have register cpuidle(CPU0), 
but In the process of registration cpuidle driver, the scheduler maybe schedule the process to the other CPU (eg. CPU0 have heay load, migrate to CPU1) 
cpuidle_get_driver() --> get_cpu() , will get CPU1, if CPU1 didn't register cpuidle driver, Will get NULL.

I know we should prevent the registration migrate to the other CPU, but we should check drv before add refcount to prevent kernel panic at least, Right?

Best Regards,
Daniel

-----Original Message-----
From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
Sent: 2013å¹´8æœˆ30æ—¥ 20:01
To: Daniel Fu
Cc: daniel.lezcano@linaro.org; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Johnny Qiu
Subject: Re: [PATCH] cpuidle: Check cpuidle driver before add refcount

On Friday, August 30, 2013 07:48:22 PM Daniel Fu wrote:
> If the current CPU has no cpuidle driver, drv will be NULL.
> Check if we get drv successfully before add refount to prevent Kernel 
> panic.

What is the actual scenario that may lead to this panic?

Rafael


> Signed-off-by: Daniel Fu <danifu@nvidia.com>
> ---
>  drivers/cpuidle/driver.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c index 
> 3ac499d..6e11701 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -331,7 +331,8 @@ struct cpuidle_driver *cpuidle_driver_ref(void)
>  	spin_lock(&cpuidle_driver_lock);
>  
>  	drv = cpuidle_get_driver();
> -	drv->refcnt++;
> +	if (drv)
> +		drv->refcnt++;
>  
>  	spin_unlock(&cpuidle_driver_lock);
>  	return drv;
> 
--
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
