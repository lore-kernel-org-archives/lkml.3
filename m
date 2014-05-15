Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbaEOQ5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:57:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41332 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaEOQ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:57:13 -0400
X-AuditID: cbfee61b-b7f766d00000646c-37-5374f1e61c4e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] thermal: exynos: remove redundant threshold_code
 checks from exynos_tmu_initialize()
Date: Thu, 15 May 2014 18:56:55 +0200
Message-id: <2759070.4B75QlgKJJ@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140515145552.GB27690@developer>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
 <1399288539-1793-7-git-send-email-b.zolnierkie@samsung.com>
 <20140515145552.GB27690@developer>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9jQd1nH0uCDbZes7ZouBpisWb/TyaL
	+VeusVqcbXrDbnF51xw2i8+9RxgtZpzfx2Rx5vQlVosnD/vYLNbPeM3iwOWxc9Zddo/Fe14y
	eWy52s7i0bdlFaPH8RvbmTw+b5ILYIvisklJzcksSy3St0vgyrg19zhzQbtUxamZU9kaGGeK
	dDFyckgImEgcO93HCmGLSVy4t56ti5GLQ0hgOqPE3Lbd7BBOC5PEnkldLCBVbAJWEhPbVzGC
	2CICWhInLm1nAiliFrjJJHH41w+wImGBQomnW5rYQGwWAVWJV/232EFsXgFNiXP908HWiQp4
	SuzYvhKshlNAX2LZ7HtQq1cxSrTcm8gG0SAo8WPyPbChzALyEvv2T2WFsLUk1u88zjSBUWAW
	krJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Ip5J72Bc1WBxiFGAg1GJ
	h5dhcnGwEGtiWXFl7iFGCQ5mJRFe8+clwUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJ
	pCeWpGanphakFsFkmTg4pRoY0xdMe7JS4cSXU6pr1xX/O7RplcmOxS9ky62Yn61vf5B1oaFq
	34ekhuYIoYXqZUbn43LSk1lvH/b4zsw1fwFzZPO8a3PMPoV+yVzqbPjYLi3W+vkfkYLyrKqV
	08zU5q91WP8z2OxMQPBHO6kKnimxkhICBk9PJx6quDhdsuHi5g3v1zuevfIsXImlOCPRUIu5
	qDgRAJ/OkW6EAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 15, 2014 10:55:52 AM Eduardo Valentin wrote:
> Hello Bartlomiej,

Hi,

> On Mon, May 05, 2014 at 01:15:35PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > Remove runtime checks for negative return values of temp_to_code()
> > from exynos_tmu_initialize().  The current level temperature data
> > hardcoded in pdata will never cause a negative temp_to_code()
> > return values and for the new code potential mistakes should be
> > caught during development/review phases.
> > 
> > Theres should be no functional changes caused by this patch.
> > 
> 
> Same question as in previous patch. Removing defensive code must

Simirarly like in a previous case.  Such verification should not be done
at runtime in a production code because it is already too late for such
checking.  It should be done during development and review phases.

> be done carefully. 

BTW In case of temp_to_code() its users should be audited to pass only
input values that give positive results and later the function itself
may be modified to catch wrong input values by using WARN_ON (or even
BUG_ON).

> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > ---
> >  drivers/thermal/samsung/exynos_tmu.c | 16 +---------------
> >  1 file changed, 1 insertion(+), 15 deletions(-)
> > 
> > diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> > index 789d745..a415829 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.c
> > +++ b/drivers/thermal/samsung/exynos_tmu.c
> > @@ -170,10 +170,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
> >  	if (data->soc == SOC_ARCH_EXYNOS4210) {
> >  		/* Write temperature code for threshold */
> >  		threshold_code = temp_to_code(data, pdata->threshold);
> > -		if (threshold_code < 0) {
> > -			ret = threshold_code;
> > -			goto out;
> > -		}
> >  		writeb(threshold_code,
> >  			data->base + reg->threshold_temp);
> >  		for (i = 0; i < trigger_levs; i++)
> > @@ -187,18 +183,12 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
> >  		i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++) {
> >  			threshold_code = temp_to_code(data,
> >  						pdata->trigger_levels[i]);
> > -			if (threshold_code < 0) {
> > -				ret = threshold_code;
> > -				goto out;
> > -			}
> >  			rising_threshold |= threshold_code << 8 * i;
> >  			if (pdata->threshold_falling) {
> >  				threshold_code = temp_to_code(data,
> >  						pdata->trigger_levels[i] -
> >  						pdata->threshold_falling);
> > -				if (threshold_code > 0)
> > -					falling_threshold |=
> > -						threshold_code << 8 * i;
> > +				falling_threshold |= threshold_code << 8 * i;
> >  			}
> >  		}
> >  
> > @@ -217,10 +207,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
> >  				(pdata->trigger_type[i] == HW_TRIP)) {
> >  			threshold_code = temp_to_code(data,
> >  						pdata->trigger_levels[i]);
> > -			if (threshold_code < 0) {
> > -				ret = threshold_code;
> > -				goto out;
> > -			}
> >  			if (i == EXYNOS_MAX_TRIGGER_PER_REG - 1) {
> >  				/* 1-4 level to be assigned in th0 reg */
> >  				rising_threshold |= threshold_code << 8 * i;

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

