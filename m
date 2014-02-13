Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaBMCCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 21:02:08 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11369 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbaBMCCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 21:02:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 12 Feb 2014 17:59:29 -0800
Message-ID: <52FC2798.8030901@nvidia.com>
Date: Thu, 13 Feb 2014 11:02:00 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Emil Velikov <emil.l.velikov@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
CC: "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [Nouveau] [PATCH v2] drm/nouveau: support for platform devices
References: <CAAVeFuJaD1C7yPRGm3+hByLDuSiBhftehcbwFfrbLaYsAwRcZQ@mail.gmail.com> <1392183495-11481-1-git-send-email-acourbot@nvidia.com> <52FB82AC.1010405@gmail.com>
In-Reply-To: <52FB82AC.1010405@gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emil,

On 02/12/2014 11:18 PM, Emil Velikov wrote:
> On 12/02/14 05:38, Alexandre Courbot wrote:
>> Upcoming mobile Kepler GPUs (such as GK20A) use the platform bus instead
>> of PCI to which Nouveau is tightly dependent. This patch allows Nouveau
>> to handle platform devices by:
>>
>> - abstracting PCI-dependent functions that were typically used for
>>    resource querying and page mapping,
>> - introducing a nv_device_is_pci() function that allows to make
>>    PCI-dependent code conditional,
>> - providing a nouveau_drm_platform_probe() function that takes a GPU
>>    platform device to be probed.
>>
>> Core code as well as engine/subdev drivers are updated wherever possible
>> to make use of these functions. Some older drivers are too dependent on
>> PCI to be properly updated, but all newer code on which future chips may
>> depend should at least be runnable with platform devices.
>>
> Hi Alexandre
>
> I've tried really hard to find something wrong with this patch but it
> seems that you have it polished very nicely.

Great!

> There is one quite minor nit in-line, but I'm not fussed either way.
>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>> Changes since v1:
>> - Refactored nouveau_device_create_() to take an additional bus type
>>    argument instead of having two versions of it that duplicate code.
>> - Fixed a typo when substituting pci_resource_* with nv_device_resource_*
>> - Check whether devices are PCI in relevant functions instead of
>>    nouveau_drm_load().
>>
>>   drivers/gpu/drm/nouveau/core/engine/device/base.c  | 83 ++++++++++++++++++++--
>>   drivers/gpu/drm/nouveau/core/engine/falcon.c       |  6 +-
>>   drivers/gpu/drm/nouveau/core/engine/fifo/base.c    |  2 +-
>>   drivers/gpu/drm/nouveau/core/engine/graph/nv20.c   |  2 +-
>>   drivers/gpu/drm/nouveau/core/engine/graph/nv40.c   |  2 +-
>>   drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |  4 +-
>>   drivers/gpu/drm/nouveau/core/engine/xtensa.c       |  2 +-
>>   drivers/gpu/drm/nouveau/core/include/core/device.h | 30 ++++++++
>>   .../gpu/drm/nouveau/core/include/engine/device.h   | 17 +++--
>>   drivers/gpu/drm/nouveau/core/include/subdev/mc.h   |  1 +
>>   drivers/gpu/drm/nouveau/core/os.h                  |  1 +
>>   drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |  4 +-
>>   drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c     |  4 +-
>>   drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     | 15 ++--
>>   .../gpu/drm/nouveau/core/subdev/devinit/fbmem.h    |  8 ++-
>>   drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c |  2 +-
>>   drivers/gpu/drm/nouveau/core/subdev/devinit/nv05.c |  2 +-
>>   drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c |  2 +-
>>   drivers/gpu/drm/nouveau/core/subdev/devinit/nv20.c |  2 +-
>>   drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c      |  9 +--
>>   drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |  9 +--
>>   drivers/gpu/drm/nouveau/core/subdev/i2c/base.c     |  2 +-
>>   drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c |  7 +-
>>   drivers/gpu/drm/nouveau/core/subdev/mc/base.c      | 39 ++++++----
>>   drivers/gpu/drm/nouveau/core/subdev/mxm/base.c     |  2 +-
>>   drivers/gpu/drm/nouveau/nouveau_abi16.c            | 13 +++-
>>   drivers/gpu/drm/nouveau/nouveau_agp.c              |  2 +-
>>   drivers/gpu/drm/nouveau/nouveau_bios.c             |  4 ++
>>   drivers/gpu/drm/nouveau/nouveau_bo.c               | 22 +++---
>>   drivers/gpu/drm/nouveau/nouveau_chan.c             |  2 +-
>>   drivers/gpu/drm/nouveau/nouveau_display.c          |  3 +-
>>   drivers/gpu/drm/nouveau/nouveau_drm.c              | 59 ++++++++++++---
>>   drivers/gpu/drm/nouveau/nouveau_sysfs.c            |  8 ++-
>>   drivers/gpu/drm/nouveau/nouveau_ttm.c              | 31 ++++----
>>   drivers/gpu/drm/nouveau/nouveau_vga.c              |  5 ++
>>   35 files changed, 297 insertions(+), 109 deletions(-)
>>
> [snip]
>> diff --git a/drivers/gpu/drm/nouveau/core/subdev/mc/base.c b/drivers/gpu/drm/nouveau/core/subdev/mc/base.c
>> index b4b9943773bc..572190c8363b 100644
>> --- a/drivers/gpu/drm/nouveau/core/subdev/mc/base.c
>> +++ b/drivers/gpu/drm/nouveau/core/subdev/mc/base.c
>> @@ -93,8 +93,8 @@ _nouveau_mc_dtor(struct nouveau_object *object)
>>   {
>>   	struct nouveau_device *device = nv_device(object);
>>   	struct nouveau_mc *pmc = (void *)object;
>> -	free_irq(device->pdev->irq, pmc);
>> -	if (pmc->use_msi)
>> +	free_irq(pmc->irq, pmc);
>> +	if (nv_device_is_pci(device) && pmc->use_msi)
> You should be able to keep the conditional as is.
>
>>   		pci_disable_msi(device->pdev);
>>   	nouveau_subdev_destroy(&pmc->base);
>>   }
>> @@ -114,22 +114,25 @@ nouveau_mc_create_(struct nouveau_object *parent, struct nouveau_object *engine,
>>   	if (ret)
>>   		return ret;
>>
>> -	switch (device->pdev->device & 0x0ff0) {
>> -	case 0x00f0:
>> -	case 0x02e0:
>> -		/* BR02? NFI how these would be handled yet exactly */
>> -		break;
>> -	default:
>> -		switch (device->chipset) {
>> -		case 0xaa: break; /* reported broken, nv also disable it */
>> -		default:
>> -			pmc->use_msi = true;
>> +	if (nv_device_is_pci(device))
>> +		switch (device->pdev->device & 0x0ff0) {
>> +		case 0x00f0:
>> +		case 0x02e0:
>> +			/* BR02? NFI how these would be handled yet exactly */
>>   			break;
>> +		default:
>> +			switch (device->chipset) {
>> +			case 0xaa:
>> +				/* reported broken, nv also disable it */
>> +				break;
>> +			default:
>> +				pmc->use_msi = true;
>> +				break;
>>   		}
>>   	}
>>
>>   	pmc->use_msi = nouveau_boolopt(device->cfgopt, "NvMSI", pmc->use_msi);
> As you explicitly disable msi on platform devices you can move the
> option parsing within the if (nv_device_is_pci()) block.

Yes, that's correct. Actually I think it would also make sense to move 
the next paragraph under the "if (nv_device_is_pci())" block as well, 
since it also deals with MSI.

>
> This way you can drop the change in the following conditional and the
> similar one in _nouveau_mc_dtor.
>
>> -	if (pmc->use_msi && oclass->msi_rearm) {
>> +	if (nv_device_is_pci(device) && pmc->use_msi && oclass->msi_rearm) {

Will do that, rebase and post a v3.

>
>
> Many thanks, and again, welcome to nouveau :-)

Thanks for the review and the welcome! :)

Alex.

