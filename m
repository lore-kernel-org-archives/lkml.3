Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaJCJnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:43:01 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29208 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaJCJm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:42:58 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-91-542e6fa0a764
Message-id: <542E6F9D.2090005@samsung.com>
Date: Fri, 03 Oct 2014 11:42:53 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "open list:INTEL DRM DRIVERS..." <intel-gfx@lists.freedesktop.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH RFC 0/4] drm/core: restore suspend/resume calbacks in KMS
 drm drivers
References: <1412324653-30677-1-git-send-email-a.hajda@samsung.com>
 <20141003083121.GC16117@phenom.ffwll.local>
In-reply-to: <20141003083121.GC16117@phenom.ffwll.local>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xy7oL8vVCDFYfFLNYfmYds8WVr+/Z
	LGZP2Mxk0bvgKpvF2aY37BaXd81hs5hxfh+Txdojd9ktZkx+yebA6bF4z0smj/vdx5k8+ras
	YvT4vEkugCWKyyYlNSezLLVI3y6BK6P/zhyWgvUiFcdnr2BvYNwj0MXIySEhYCIx+dI5Fghb
	TOLCvfVsXYxcHEICSxklVv9ewgzhfGKU+PJgK1gVr4CWxPKfd9lAbBYBVYld5y+A2WwCmhJ/
	N98Es0UFIiRO3t3DDlEvKPFj8j0WkEEiApeZJU7euw40lYNDWCBa4sRcY5AaIYFCiS1/esDC
	nAIWEu0X5EFMZgE9ifsXtUAqmAXkJTavecs8gZF/FpKhsxCqZiGpWsDIvIpRNLU0uaA4KT3X
	SK84Mbe4NC9dLzk/dxMjJKS/7mBceszqEKMAB6MSD++HG7ohQqyJZcWVuYcYJTiYlUR4T8fp
	hQjxpiRWVqUW5ccXleakFh9iZOLglGpgDBRv5Jz5q61E+dg0R5/V/szVr1c9OhJSsdZ0u0zN
	wYJrYbbWMx5+dD34/83544yHD+y3cr63dSXPlN3sq5geMwsdsbfUmlp/ReFpXkTiYbWZ7D++
	sh8/kf35koxe/SKF/284DTidzuYqPZVZ3ryZv+RxwTtFw7ADr2c6z56n/V6TedWlOy3c2Uos
	xRmJhlrMRcWJANAxg0tHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2014 10:31 AM, Daniel Vetter wrote:
> On Fri, Oct 03, 2014 at 10:24:09AM +0200, Andrzej Hajda wrote:
>> The main intent of this patchset is to allow use of suspend/resume drm driver
>> callbacks in KMS drivers, as these callbacks seems to me the best place
>> to implement suspend/resume functionality in drm driver.
>> Implementing this functionality in master component driver PM ops is problematic
>> as those callbacks can be called asynchronously regardless of state/existence of
>> drm device, thus it would require additional synchronization mechanism.
>>
>> Callbacks re-enabling requires small changes in i915 and exynos driver.
>> The patchset contains also fix of exynos resume callback.
> Nack.
>
> Like completely and totally. The drm core has really no business doing
> hardware stuff, which includes runtime pm, system suspend and all that
> nonsense. It' an interface between userspace and drivers, with a big
> library to back it all up. Everything else just repeats the old midlayer
> mistake.

Hmm, I have just tried to reuse the existing infrastructure, I did not see
any sign "do not touch, this is a mistake". Now I see it, thanks :)

>
> If you driver needs this, do it there. Also, the component framework is
> probably the solution you're looking for. And if there are synchronization
> issues with that then we need to fix those instead of reinventing yet
> another half-assed broken wheel.

But this is an issue closely connected with component framework.
Component framework separates master component probe and drm device
initialization. As a result PM ops which are synchronized with probe
(via device_lock)
are no more synchronized with drm initialization which is usually called
from
.bind callback.

>
> Aside: With David Herrmann's latest patches to de-midlayer the drm
> init/teardown sequence the driver is in full control of when the drm data
> structures get allocate, initialized and registered. If you convert to
> that plus the component framework I'm pretty sure your problem is solved.

I will look closer at it but as I described above it is rather matter of
separation
of master component and drm device initialization.

My idea was to avoid creation of new synchronization mechanism and to
reuse the
existing ones which seems to fit perfectly to the scenario, but if there
is big NO for it
another solution should be found.

Anyway I guess the problem exists for all drivers having component
framework and suspend:
exynos, msm and incoming rockchip.


Regards
Andrzej

>
> Thanks, Daniel

