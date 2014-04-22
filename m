Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaDVCbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 22:31:39 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6035 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaDVCbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 22:31:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Apr 2014 19:23:19 -0700
Message-ID: <5355D485.6030301@nvidia.com>
Date: Tue, 22 Apr 2014 11:31:33 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ilia Mirkin <imirkin@alum.mit.edu>
CC: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [Nouveau] [PATCH v2 09/10] drm/nouveau: support GK20A in nouveau_accel_init()
References: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>	<1398060142-7937-10-git-send-email-acourbot@nvidia.com> <CAKb7Uvg4kOfsE0gd4zLcwjShc4eVgVKA7zQM2r1aeatOybm8NQ@mail.gmail.com>
In-Reply-To: <CAKb7Uvg4kOfsE0gd4zLcwjShc4eVgVKA7zQM2r1aeatOybm8NQ@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 03:07 AM, Ilia Mirkin wrote:
> On Mon, Apr 21, 2014 at 2:02 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Skip the creation of a software channel for GK20A as software methods
>> are not yet supported.
>
> How is GK20A different from a nvc0+ card that lacks PDISPLAY (like all
> the 3D Controller ones, and I guess even some that come up as VGA
> controller in PCI but don't have any outputs in their VBIOS)? i.e.
> what's wrong with just doing the same thing that GK1xx does? Note that
> there are sw methods that don't deal with display as well.

Well, as it turns out... I have tried reverting this patch and enabling 
nvc0_software_oclass for GK20A and things worked like a charm. 0_o

This is definitely different from when I first drafted this patch 
series, where a software class could not be used on GK20A due to hard 
dependencies on display. But it seems like today's code can accommodate 
much better with that situation.

That's great - this will allow us to get rid of this ungraceful patch. 
Thanks for making me check it again.

Probably a v3 will be necessary to enable the software class in patch 10 
(and fix the byte/word typo in patch 7). I will just wait a bit to see 
if this v2 gets more comments before sending it.

>
>    -ilia
>
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>   drivers/gpu/drm/nouveau/nouveau_drm.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
>> index ddd83756b9a2..5b46148ffd32 100644
>> --- a/drivers/gpu/drm/nouveau/nouveau_drm.c
>> +++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
>> @@ -208,6 +208,10 @@ nouveau_accel_init(struct nouveau_drm *drm)
>>                  return;
>>          }
>>
>> +       /* Need to figure out how to handle sw for gk20a */
>> +       if (device->chipset == 0xea)
>> +               goto skip_sw_init;
>> +
>>          ret = nouveau_object_new(nv_object(drm), NVDRM_CHAN, NVDRM_NVSW,
>>                                   nouveau_abi16_swclass(drm), NULL, 0, &object);
>>          if (ret == 0) {
>> @@ -234,6 +238,7 @@ nouveau_accel_init(struct nouveau_drm *drm)
>>                  return;
>>          }
>>
>> +skip_sw_init:
>>          if (device->card_type < NV_C0) {
>>                  ret = nouveau_gpuobj_new(drm->device, NULL, 32, 0, 0,
>>                                          &drm->notify);
>> --
>> 1.9.2
>>
>> _______________________________________________
>> Nouveau mailing list
>> Nouveau@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/nouveau

