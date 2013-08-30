Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3H3NkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:40:14 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11066 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab3H3NkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:40:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 30 Aug 2013 06:37:35 -0700
From: Daniel Fu <danifu@nvidia.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johnny Qiu <joqiu@nvidia.com>
Date: Fri, 30 Aug 2013 21:39:27 +0800
Subject: RE: [PATCH] cpuidle: Check cpuidle driver before add refcount
Thread-Topic: [PATCH] cpuidle: Check cpuidle driver before add refcount
Thread-Index: Ac6lgtKojrVm+qRwTIClb2exepmvkAAAg0cw
Message-ID: <D9A2FA38A1E15B4E832469E5FE40C7ABFB583335A4@HKMAIL01.nvidia.com>
References: <1377863302-22465-1-git-send-email-danifu@nvidia.com>
 <2041584.4YznqfT0Od@vostro.rjw.lan>
 <D9A2FA38A1E15B4E832469E5FE40C7ABFB5833359F@HKMAIL01.nvidia.com>
 <1725801.dn2z0gQifB@vostro.rjw.lan>
In-Reply-To: <1725801.dn2z0gQifB@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7UDeLrc024869

Yes, I saw it. 
Thanks. found one case when  Find PM domain and connect cpuidle to it , in when Kernel booting ,opening early prink testing
pm_genpd_name_attach_cpuidle()->cpuidle_driver_ref().

-----Original Message-----
From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
Sent: 2013å¹´8æœˆ30æ—¥ 21:26
To: Daniel Fu
Cc: daniel.lezcano@linaro.org; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Johnny Qiu
Subject: Re: [PATCH] cpuidle: Check cpuidle driver before add refcount

On Friday, August 30, 2013 08:26:34 PM Daniel Fu wrote:
> X-NVConfidentiality: public
> 
> In SMP, When doing the cpuidle driver registration. There maybe only 1 
> cpu have register cpuidle(CPU0), but In the process of registration 
> cpuidle driver, the scheduler maybe schedule the process to the other 
> CPU (eg. CPU0 have heay load, migrate to CPU1)
> cpuidle_get_driver() --> get_cpu() , will get CPU1, if CPU1 didn't register cpuidle driver, Will get NULL.
> 
> I know we should prevent the registration migrate to the other CPU, but we should check drv before add refcount to prevent kernel panic at least, Right?

Well, cpuidle_driver_ref() has only one caller, which is not the registration.

However, the caller apparently assumes that that function may return NULL and
cpuidle_driver_unref() check drv against NULL too, so cpuidle_driver_ref() should do that either.

Did you see that problem in testing or just through code inspection?

Rafael


> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: 2013å¹´8æœˆ30æ—¥ 20:01
> To: Daniel Fu
> Cc: daniel.lezcano@linaro.org; linux-pm@vger.kernel.org; 
> linux-kernel@vger.kernel.org; Johnny Qiu
> Subject: Re: [PATCH] cpuidle: Check cpuidle driver before add refcount
> 
> On Friday, August 30, 2013 07:48:22 PM Daniel Fu wrote:
> > If the current CPU has no cpuidle driver, drv will be NULL.
> > Check if we get drv successfully before add refount to prevent 
> > Kernel panic.
> 
> What is the actual scenario that may lead to this panic?
> 
> Rafael
> 
> 
> > Signed-off-by: Daniel Fu <danifu@nvidia.com>
> > ---
> >  drivers/cpuidle/driver.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c 
> > index
> > 3ac499d..6e11701 100644
> > --- a/drivers/cpuidle/driver.c
> > +++ b/drivers/cpuidle/driver.c
> > @@ -331,7 +331,8 @@ struct cpuidle_driver *cpuidle_driver_ref(void)
> >  	spin_lock(&cpuidle_driver_lock);
> >  
> >  	drv = cpuidle_get_driver();
> > -	drv->refcnt++;
> > +	if (drv)
> > +		drv->refcnt++;
> >  
> >  	spin_unlock(&cpuidle_driver_lock);
> >  	return drv;
> > 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> 
--
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
