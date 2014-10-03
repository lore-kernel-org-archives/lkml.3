Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaJCLjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 07:39:25 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34682 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJCLjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 07:39:22 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <542E6F9D.2090005@samsung.com>
References: <1412324653-30677-1-git-send-email-a.hajda@samsung.com>
	<20141003083121.GC16117@phenom.ffwll.local>
	<542E6F9D.2090005@samsung.com>
Date: Fri, 3 Oct 2014 13:39:21 +0200
X-Google-Sender-Auth: Yb9yY8_QJktlfuQ81JssNs8Z1A0
Message-ID: <CAKMK7uGec2yV89n-RLsg+HqXoXvXBMBVZ6py3Z7puFe+KR6e7A@mail.gmail.com>
Subject: Re: [PATCH RFC 0/4] drm/core: restore suspend/resume calbacks in KMS
 drm drivers
From: Daniel Vetter <daniel@ffwll.ch>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "open list:INTEL DRM DRIVERS..." <intel-gfx@lists.freedesktop.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2014 at 11:42 AM, Andrzej Hajda <a.hajda@samsung.com> wrote:
> On 10/03/2014 10:31 AM, Daniel Vetter wrote:
>> On Fri, Oct 03, 2014 at 10:24:09AM +0200, Andrzej Hajda wrote:
>>> The main intent of this patchset is to allow use of suspend/resume drm driver
>>> callbacks in KMS drivers, as these callbacks seems to me the best place
>>> to implement suspend/resume functionality in drm driver.
>>> Implementing this functionality in master component driver PM ops is problematic
>>> as those callbacks can be called asynchronously regardless of state/existence of
>>> drm device, thus it would require additional synchronization mechanism.
>>>
>>> Callbacks re-enabling requires small changes in i915 and exynos driver.
>>> The patchset contains also fix of exynos resume callback.
>> Nack.
>>
>> Like completely and totally. The drm core has really no business doing
>> hardware stuff, which includes runtime pm, system suspend and all that
>> nonsense. It' an interface between userspace and drivers, with a big
>> library to back it all up. Everything else just repeats the old midlayer
>> mistake.
>
> Hmm, I have just tried to reuse the existing infrastructure, I did not see
> any sign "do not touch, this is a mistake". Now I see it, thanks :)

As a rule of thumb, if you see a !DRIVER_MODESET check anywhere, then
that's a clear sign that you're wandering off the light and into the
dangerous parts of what drm was like age dark ages ;-)

>> If you driver needs this, do it there. Also, the component framework is
>> probably the solution you're looking for. And if there are synchronization
>> issues with that then we need to fix those instead of reinventing yet
>> another half-assed broken wheel.
>
> But this is an issue closely connected with component framework.
> Component framework separates master component probe and drm device
> initialization. As a result PM ops which are synchronized with probe
> (via device_lock)
> are no more synchronized with drm initialization which is usually called
> from
> .bind callback.

Now I'm confused. component->bind and drm initialization is about
driver load, but all this code here is about system suspend/resume
really. So I'm rather confused what problem you actually want to fix
..

>> Aside: With David Herrmann's latest patches to de-midlayer the drm
>> init/teardown sequence the driver is in full control of when the drm data
>> structures get allocate, initialized and registered. If you convert to
>> that plus the component framework I'm pretty sure your problem is solved.
>
> I will look closer at it but as I described above it is rather matter of
> separation
> of master component and drm device initialization.
>
> My idea was to avoid creation of new synchronization mechanism and to
> reuse the
> existing ones which seems to fit perfectly to the scenario, but if there
> is big NO for it
> another solution should be found.
>
> Anyway I guess the problem exists for all drivers having component
> framework and suspend:
> exynos, msm and incoming rockchip.

It sounds like the component framework needs to be teached to work
with system suspend/resume. I guess either we need to have clever
abuse of deferred probing to make sure that the master device is
probed first and so in the correct place in the system/resume
sequence. Or the master framework needs to grow pm_ops itself so that
the state associated with the logical componentized framework can be
saved/restored.

So master pm_ops would save/restore kms state, and all the components
would just save/restore any additional (register, clock, whatever)
state that each componnent driver would need.

But I'm not really an expert here, so adding more people.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
