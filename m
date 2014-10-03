Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaJCH0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 03:26:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11435 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaJCH0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 03:26:36 -0400
X-AuditID: cbfee61a-f79c06d000004e71-75-542e4fa9ce93
Date: Fri, 03 Oct 2014 09:26:29 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] thermal: step_wise: fix: Prevent from binary overflow
 when trend is dropping
Message-id: <20141003092629.01afdab7@amdc2363>
In-reply-to: <20141002211325.GA5016@developer>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1411547232-21493-2-git-send-email-l.majewski@samsung.com>
 <20141002211325.GA5016@developer>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jAd1V/nohBguusFhsnLGe1WL+lWus
	Fm8ecVtc3jWHzeJz7xFGiycP+9gc2Dx2zrrL7rF4z0smj3XT3jJ79G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8bGS/OYClYLV/y8n9LAuIy/i5GTQ0LARGJPwyQWCFtM4sK99WxdjFwcQgKL
	GCXe3pnKDuH8YpQ4ePkoO0gVi4CqxPUJV8A62AT0JD7ffcoEYosIaEmcuLQdzGYWOM8osWe/
	SRcjB4ewQLpExxpLkDAvUPnVK0sYQWxOIHvD21/MEPOXM0q8+XKAFSTBLyAp0f7vBzPERXYS
	5z5tYIdoFpT4MfkeC8R8LYnN25pYIWx5ic1r3jJPYBSchaRsFpKyWUjKFjAyr2IUTS1ILihO
	Ss811CtOzC0uzUvXS87P3cQIDvhnUjsYVzZYHGIU4GBU4uH9cEM3RIg1say4MvcQowQHs5II
	70djvRAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjCtX
	qykZz5ym4SBm0nu0zz7SfGF6+E7BaM3f53sFZjBN5N237qqjwF09zXPqC2+7tZU88rx4M7Pq
	zKMAvp8nlN/kmGRfmrbxak/ahNxDfW6rikxO/DhzWL9xSeDL981C3+bJaWWKqHFVZvF0fdqo
	eTXzH3P8gQi2nV2Kct/fWc/59mcmp9pWTyWW4oxEQy3mouJEAIMSUs10AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> Hello Lukasz,
> 
> On Wed, Sep 24, 2014 at 10:27:10AM +0200, Lukasz Majewski wrote:
> > It turns out that some boards can have instance->lower greater than
> > 0 and when thermal trend is dropping it results with next_target
> > equal to -1.
> > 
> > Since the next_target is defined as unsigned long it is interpreted
> > as 0xFFFFFFFF and larger than instance->upper.
> > As a result the next_target is set to instance->upper which ramps
> > up to maximal cooling device target when the temperature is
> > steadily decreasing.
> > 
> 
> Thanks for finding a problem and sending a fix.
> 
> Can you please explain a little more on how next_target reaches -1
> when lower is greater than 0?

During testing I've created a fan based cooling device with
"instance->lower" = 1 and "instance->upper" = 3.

On the system the ordinary cpu_cooling device is also present.

With step_wise.c it happens that at "THERMAL_TREND_DROPPING" the
cur_state = 0, so the first if condition is false (line 80) and
cur_state, which is defined as unsigned long, is decremented. This
means that next_target equals to 0xFFFFFFFF because it also is defined
as unsigned long.
Such value is apparently bigger than "instance->upper" (line 85) and
therefore the maximal cooling state is chosen. As a result, even when
the thermal trend is dropping, the cooling device increase the cooling
state to maximum.

This behavior has been discovered during my work on adapting exynos
thermal driver to reuse the of-thermal. I will send patches for this
work after the weekend.

> 
> 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> >  drivers/thermal/step_wise.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/thermal/step_wise.c
> > b/drivers/thermal/step_wise.c index 3b54c2c..fdd1f52 100644
> > --- a/drivers/thermal/step_wise.c
> > +++ b/drivers/thermal/step_wise.c
> > @@ -77,7 +77,7 @@ static unsigned long get_target_state(struct
> > thermal_instance *instance, next_target = instance->upper;
> >  		break;
> >  	case THERMAL_TREND_DROPPING:
> > -		if (cur_state == instance->lower) {
> > +		if (cur_state <= instance->lower) {
> >  			if (!throttle)
> >  				next_target = THERMAL_NO_TARGET;
> >  		} else {
> > -- 
> > 2.0.0.rc2
> > 
> 
> 
> Eduardo



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
