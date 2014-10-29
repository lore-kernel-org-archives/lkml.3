Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307AbaJ2PoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:44:20 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11976 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651AbaJ2PoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:44:16 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f956d000005ed7-6a-54510b4c5a03
Content-transfer-encoding: 8BIT
Message-id: <1414597451.21948.4.camel@AMDC1943>
Subject: Re: PM/runtime issue: Device cannot runtime resume because power
 domain is off during system resume
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 29 Oct 2014 16:44:11 +0100
In-reply-to: <CAPDyKFpy98h-BYnvhPSJy+p5=ynpXkhnjABYG4gMc+X1BCQSYA@mail.gmail.com>
References: <1413468302.5605.9.camel@AMDC1943>
 <CAPDyKFpy98h-BYnvhPSJy+p5=ynpXkhnjABYG4gMc+X1BCQSYA@mail.gmail.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t/xa7o+3IEhBqd6rCxmTdnLZHF51xw2
	i8+9Rxgt7p46ymZx5vQlVovja8Md2DwW73nJ5HHn2h42jy1X21k8Vqz+zu7xeZNcAGsUl01K
	ak5mWWqRvl0CV8aULvmCVuGKyRfnsTYw/uHrYuTkkBAwkXhxai4zhC0mceHeerYuRi4OIYGl
	jBL/bnazgyR4BQQlfky+x9LFyMHBLCAvceRSNkiYWUBdYtK8RcwQ9Z8ZJRrufmGEqNeXOHzk
	GiNIvbBAnsSJGdUgYTYBY4nNy5ewgdgiAhoSex6eZwXpZRZ4yijxYcVGJpAEi4CqxMcJb8F6
	OQWCJQ58FgAJCwmUSrS3fmEFCUsIKEs09rtNYBSYheS4WQjHzUJy3AJG5lWMoqmlyQXFSem5
	RnrFibnFpXnpesn5uZsYIQH9dQfj0mNWhxgFOBiVeHgjjgWECLEmlhVX5h5ilOBgVhLh/fwL
	KMSbklhZlVqUH19UmpNafIiRiYNTqoFRMEmf7ZvXNXtxfSEdruJU36YVB1eYJBb3ZnefO7+n
	8V72scykV9v3WV3NijrH6nZQT3LX7Dl/XrgctBJozlrEcXvCyoPGEwoPT1n+4dnHJfNMbV1N
	Vb++quyekWuvaccg91EyXsjfn7VJiT1Ziz1r18Pc+40hLL81Zn618ZEQrn78yeCiIZMSS3FG
	oqEWc1FxIgCj5fTlRgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On śro, 2014-10-29 at 14:01 +0100, Ulf Hansson wrote:
> On 16 October 2014 16:05, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > Hi,
> >
> > I encounter issues with DRM/panel driver for Exynos after resuming from
> > suspend to RAM. This is reproduced on 3.16 but I think it is applicable
> > also to mainline.
> >
> > The scenario:
> > 0. DRM DSI is in LCD power domain. Power domain is OFF before
> > suspending.
> > 1. System suspends.
> > 2. System resumes.
> > 3. DRM driver:resume().
> > 4. pm_runtime_get() for DRM DSI driver.
> > 5. This should enable LCD power domain.
> > 6. but __pm_genpd_poweron() exits early because:
> >    genpd->prepared_count = 3
> 
> I am getting to this soonish in my genpd work. Currently I am working
> on the boot issues. :-)
> 
> At a first glance, I think the genpd->prepare_count variable shouldn't
> exist at all, but I need to dig into this in more detail to be sure.
> 
> In principle I think genpd should rely _more_ on the PM core during
> system PM transitions. For example the PM core invokes a
> pm_runtime_get_noresume() (and for some reason genpd as well) at the
> ->prepare() phase. Shouldn't that be enough!?
> 
> >    genpd->suspend_power_off = 1
> >   in domain.c:183
> >
> > 7. The domain is not powered on but it is marked as active.
> > 8. The DRM driver thinks everything is OK and proceeds with resume...
> > but it fails because whole power domain is OFF.
> >
> > The question: Shouldn't the power domain be powered up EARLY?
> 
> Good question, I would like us to strive towards these goals:
> 
> For CONFIG_PM_RUNTIME, I think the PM domain should be powered up at
> the first time a runtime PM resume callbacks gets invoked.
> For !CONFIG_PM_RUNTIME, I think we should restore the state the PM
> domain had prior we went to system PM sleep.

For the first case (PM_RUNTIME) I sent a proposal:
https://lkml.org/lkml/2014/10/23/308
which seems to work for my configuration. However I did not test it
without runtime PM...

The issues I found were:
1. Runtime resume during early system suspend (triggered by poking
console).
2. Runtime resume during system resume (triggered by "normal" resuming
device).
In both case the power domain was off so runtime resume failed.

I've got a simple testing scenario and setup for reproducing these so if
you need tests I can help. 

Best regards,
Krzysztof


