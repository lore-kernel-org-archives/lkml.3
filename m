Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaKCIhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:37:05 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:65058 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaKCIgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:36:51 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-bd-54573e9f0d71
Message-id: <1415003805.4241.6.camel@AMDC1943>
Subject: Re: [PATCH v8 3/5] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 03 Nov 2014 09:36:45 +0100
In-reply-to: <20141101010113.GA3831@n2100.arm.linux.org.uk>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
 <1413795888-18559-4-git-send-email-k.kozlowski@samsung.com>
 <1479283.dvHduzBoyf@vostro.rjw.lan>
 <20141101005514.GY27405@n2100.arm.linux.org.uk>
 <20141101010113.GA3831@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4Nd35duEhBj96ZS02zljPavHkQDuj
	xfSpFxgtVk/9y2pxtukNu8WSyfNZLWZN2ctksbBtCYvF5V1z2Cw+9x5htLh9mddi7ZG77Bbv
	XkZY3D11lM3izOlLrBYTfl9gszi+NtziZd9+Fgchj5bmHjaPxXteMnncubYHyOqbzOqx5M0h
	Vo8tV9tZPGbf/cHo0bdlFaPHitXf2T0+b5Lz2Pv5N0sAdxSXTUpqTmZZapG+XQJXxvsfjcwF
	O4QrbrYUNTD28XUxcnBICJhIfDti1MXICWSKSVy4t56ti5GLQ0hgKaNE57RlrBDOZ0aJP2v3
	MYJU8QroSTRtv8QKYgsLZEp0/vkJZrMJGEtsXr6EDcQWETCVuPboGTNIM7NAI6vE+YMdYEUs
	AqoS558eZgGxOQWsJVZMmsQEYgsJ9DFJnNsnD2IzC6hLTJq3iBniOmWJxn43iL2CEj8m32OB
	KJGX2LzmLfMERoFZSDpmISmbhaRsASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQOPy6
	g3HpMatDjAIcjEo8vBMuh4UIsSaWFVfmHmKU4GBWEuHt0QkPEeJNSaysSi3Kjy8qzUktPsTI
	xMEp1cAoE3T/VclH5ZWCu4M0Pp76z+O4y6Dvzh4bGYupD89kPd5UsGvVFR63J5UnlRrO3DpW
	s3hFfepO1oXbxWe914/K6n/1fItK+d7mhPbfZkt+CoQKbvkQeFNm773jUceDH2yccHnyq+VV
	PYp8cl7bz9f/fGrdPkFhqtRNT9aYo6vPx0U/2cfAeEYrRImlOCPRUIu5qDgRAIbrDwmhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sob, 2014-11-01 at 01:01 +0000, Russell King - ARM Linux wrote:
> On Sat, Nov 01, 2014 at 12:55:14AM +0000, Russell King - ARM Linux wrote:
> > On Sat, Nov 01, 2014 at 01:45:47AM +0100, Rafael J. Wysocki wrote:
> > > On Monday, October 20, 2014 11:04:46 AM Krzysztof Kozlowski wrote:
> > > > @@ -198,8 +217,10 @@ static int amba_probe(struct device *dev)
> > > >  		pm_runtime_enable(dev);
> > > >  
> > > >  		ret = pcdrv->probe(pcdev, id);
> > > > -		if (ret == 0)
> > > > +		if (ret == 0) {
> > > > +			pcdev->irq_safe = pm_runtime_is_irq_safe(dev);
> > > 
> > > This looks racy.
> > > 
> > > Is it guaranteed that runtime PM callbacks won't be run for the device
> > > after pcdrv->probe() has returned and before setting pcdev->irq_safe?
> > > If not, inconsistent behavior may ensue.
> > 
> > You are absolutely correct.  So that knocks that idea on its head.
> 
> Actually, I think we shouldn't give up hope here.  Currently, we do this:
> 
>                 pm_runtime_get_noresume(dev);
>                 pm_runtime_set_active(dev);
>                 pm_runtime_enable(dev);
> 
>                 ret = pcdrv->probe(pcdev, id);
> 
> What we could do is:
> 
> 		pm_runtime_get_noresume(dev);
>                 pm_runtime_get_noresume(dev);
>                 pm_runtime_set_active(dev);
>                 pm_runtime_enable(dev);
> 
>                 ret = pcdrv->probe(pcdev, id);
> 		if (ret == 0) {
> 			pcdev->irq_safe = pm_runtime_is_irq_safe(dev);
> 			pm_runtime_put(dev);
> 			break;
> 		}
> 
>                 pm_runtime_disable(dev);
>                 pm_runtime_set_suspended(dev);
>                 pm_runtime_put_noidle(dev);
>                 pm_runtime_put_noidle(dev);
> 
> which would ensure that we hold a usecount until after the probe function
> has returned.  Would that work?
> 
> I'll give you that it's pretty horrid.

> Would another possible solution be to remember the irq-safeness in the
> suspend handler, and use that in the resume handler?  Resume should
> /always/ undo what the suspend handler previously did wrt clk API stuff.

I think the second solution could be more readable. The WARN_ON wouldn't
be needed. However this won't solve the two dual nature of runtime
callbacks.

I wondered also about removing runtime PM callbacks from amba/bus.c
completely and moving this to child drivers. This way runtime PM would
be obvious in each driver case.

Best regards,
Krzysztof


