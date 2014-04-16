Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaDPF6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:58:05 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:47688 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbaDPF6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:58:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACAvsv4FHqwAF6FOaMF1sQLwAfBOd6uFgsZ+VdwCHoR4qsVbVw@mail.gmail.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395650554-31925-12-git-send-email-acourbot@nvidia.com> <20140324231014.GI17218@mithrandir>
 <CACAvsv4FHqwAF6FOaMF1sQLwAfBOd6uFgsZ+VdwCHoR4qsVbVw@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 16 Apr 2014 14:57:40 +0900
Message-ID: <CAAVeFu+zySrMNUjzZ7qrB-MdqHvrGMg2WD5YmHzZ7yA5dFqyrA@mail.gmail.com>
Subject: Re: [PATCH 11/12] drm/nouveau: support GK20A in nouveau_accel_init()
To: Ben Skeggs <skeggsb@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 1:27 PM, Ben Skeggs <skeggsb@gmail.com> wrote:
> On Tue, Mar 25, 2014 at 9:10 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>> On Mon, Mar 24, 2014 at 05:42:33PM +0900, Alexandre Courbot wrote:
>>> GK20A does not embed a dedicated COPY engine and thus cannot allocate
>>> the copy channel that nouveau_accel_init() attempts to create. It also
>>> lacks any display hardware, so the creation of a software channel does
>>> not apply neither.
>>
>> Perhaps this should be two separate patches?
>>
>>> diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
>> [...]
>>> +     if (device->chipset == 0xea) {
>>> +             /* gk20a does not have CE0/CE1 */
>>
>> This would be another good candidate for a feature flag.
> There are ways to query this in a chipset-independent way.  However,
> despite reporting it as an error if no copy engines are available, the
> code should continue on without the channel happily.  Perhaps we can
> just punt the relevent error messages to a debug loglevel for now?

Do you know how to query this in a chipset-independant way? I have
failed to find any information for this.

The code does continue without any issue after reporting the error, so
indeed that check is not strictly necessary. But I was just mimicking
what follows right after:

    if (device->chipset >= 0xa3 &&
        device->chipset != 0xaa &&
        device->chipset != 0xac) {
        ret = nouveau_channel_new(drm, &drm->client, NVDRM_DEVICE,
                      NVDRM_CHAN + 1, NvDmaFB, NvDmaTT,
                      &drm->cechan);
        if (ret)
            NV_ERROR(drm, "failed to create ce channel, %d\n", ret);

        arg0 = NvDmaFB;
        arg1 = NvDmaTT;
    } else {
        arg0 = NvDmaFB;
        arg1 = NvDmaTT;
    }

So if we are trying to avoid showing this error for 0xa0 class
devices, why not for NV_E0?
