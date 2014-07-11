Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaGKCke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:40:34 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11055 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaGKCkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:40:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 Jul 2014 19:29:36 -0700
Message-ID: <53BF4E9B.7090606@nvidia.com>
Date: Fri, 11 Jul 2014 11:40:27 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        <nouveau@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [Nouveau] [PATCH v4 4/6] drm/nouveau: synchronize BOs when required
References: <1404807961-30530-1-git-send-email-acourbot@nvidia.com> <1404807961-30530-5-git-send-email-acourbot@nvidia.com> <20140710130449.GG17271@phenom.ffwll.local>
In-Reply-To: <20140710130449.GG17271@phenom.ffwll.local>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 10:04 PM, Daniel Vetter wrote:
> On Tue, Jul 08, 2014 at 05:25:59PM +0900, Alexandre Courbot wrote:
>> On architectures for which access to GPU memory is non-coherent,
>> caches need to be flushed and invalidated explicitly when BO control
>> changes between CPU and GPU.
>>
>> This patch adds buffer synchronization functions which invokes the
>> correct API (PCI or DMA) to ensure synchronization is effective.
>>
>> Based on the TTM DMA cache helper patches by Lucas Stach.
>>
>> Signed-off-by: Lucas Stach <dev@lynxeye.de>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>   drivers/gpu/drm/nouveau/nouveau_bo.c  | 56 +++++++++++++++++++++++++++++++++++
>>   drivers/gpu/drm/nouveau/nouveau_bo.h  |  2 ++
>>   drivers/gpu/drm/nouveau/nouveau_gem.c | 12 ++++++++
>>   3 files changed, 70 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
>> index 67e9e8e2e2ec..47e4e8886769 100644
>> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
>> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
>> @@ -402,6 +402,60 @@ nouveau_bo_unmap(struct nouveau_bo *nvbo)
>>   		ttm_bo_kunmap(&nvbo->kmap);
>>   }
>>
>> +void
>> +nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
>> +{
>> +	struct nouveau_drm *drm = nouveau_bdev(nvbo->bo.bdev);
>> +	struct nouveau_device *device = nouveau_dev(drm->dev);
>> +	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
>> +	int i;
>> +
>> +	if (!ttm_dma)
>> +		return;
>> +
>> +	if (nv_device_is_cpu_coherent(device) || nvbo->force_coherent)
>> +		return;
>
> Is the is_cpu_coherent check really required? On coherent platforms the
> sync_for_foo should be a noop. It's the dma api's job to encapsulate this
> knowledge so that drivers can be blissfully ignorant. The explicit
> is_coherent check makes this a bit leaky. And same comment that underlying
> the bus-specifics dma-mapping functions are identical.

I think you are right, the is_cpu_coherent check should not be needed 
here. I still think we should have separate paths for the PCI/DMA cases 
though, unless you can point me to a source that clearly states that the 
PCI API is deprecated and that DMA should be used instead.
