Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaEWGBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 02:01:49 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:48654 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaEWGBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 02:01:47 -0400
MIME-Version: 1.0
In-Reply-To: <1400491887.8467.15.camel@weser.hi.pengutronix.de>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
 <1400483458-9648-4-git-send-email-acourbot@nvidia.com> <1400491887.8467.15.camel@weser.hi.pengutronix.de>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 23 May 2014 15:01:26 +0900
Message-ID: <CAAVeFuJ_Z1Qv6uEy=i7mXJ18cdnN=O27Ad_b3tdtixA2p1qcJw@mail.gmail.com>
Subject: Re: [PATCH 3/4] drm/nouveau: hook up cache sync functions
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 6:31 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
> Am Montag, den 19.05.2014, 16:10 +0900 schrieb Alexandre Courbot:
>> From: Lucas Stach <dev@lynxeye.de>
>>
>> Signed-off-by: Lucas Stach <dev@lynxeye.de>
>> [acourbot@nvidia.com: make conditional and platform-friendly]
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  drivers/gpu/drm/nouveau/nouveau_bo.c  | 32 ++++++++++++++++++++++++++++++++
>>  drivers/gpu/drm/nouveau/nouveau_bo.h  | 20 ++++++++++++++++++++
>>  drivers/gpu/drm/nouveau/nouveau_gem.c |  8 +++++++-
>>  3 files changed, 59 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
>> index b6dc85c614be..0886f47e5244 100644
>> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
>> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
>> @@ -407,6 +407,8 @@ nouveau_bo_validate(struct nouveau_bo *nvbo, bool interruptible,
>>  {
>>       int ret;
>>
>> +     nouveau_bo_sync_for_device(nvbo);
>> +
>>       ret = ttm_bo_validate(&nvbo->bo, &nvbo->placement,
>>                             interruptible, no_wait_gpu);
>>       if (ret)
>> @@ -487,6 +489,36 @@ nouveau_bo_invalidate_caches(struct ttm_bo_device *bdev, uint32_t flags)
>>       return 0;
>>  }
>>
>> +#ifdef NOUVEAU_NEED_CACHE_SYNC
>
> I don't like this ifdef at all. I know calling this functions will add a
> little overhead to x86 where it isn't strictly required, but I think
> it's negligible.
>
> When I looked at them the dma_sync_single_for_[device|cpu] functions
> which are called here map out to just a drain of the PCI store buffer on
> x86, which should be fast enough to be done unconditionally. They won't
> so any time-consuming cache synchronization on PCI coherent arches.

If Ben agrees with it I am also perfectly fine with getting rid of this #ifdef.
