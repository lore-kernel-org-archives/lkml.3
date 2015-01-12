Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbbALRU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:20:26 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:38807 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbbALRUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:20:23 -0500
MIME-Version: 1.0
X-Originating-IP: [130.216.30.134]
In-Reply-To: <1421012945.19708.27.camel@decadent.org.uk>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
	<1418653622-21105-31-git-send-email-luis.henriques@canonical.com>
	<1421012945.19708.27.camel@decadent.org.uk>
Date: Mon, 12 Jan 2015 18:20:22 +0100
Message-ID: <CAKMK7uFDS339qaqaNeRJ-L+XXKBaS8CgDY1CzEB7ugDmOto+Dw@mail.gmail.com>
Subject: Re: [PATCH 3.16.y-ckt 030/168] drm/i915: Handle failure to kick out a
 conflicting fb driver
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel-team@lists.ubuntu.com,
        "Nikula, Jani" <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 10:49 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Mon, 2014-12-15 at 14:24 +0000, Luis Henriques wrote:
>> 3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Chris Wilson <chris@chris-wilson.co.uk>
>>
>> commit f96de58fc7e7d3d717c7c63975c3b896c906b5e3 upstream.
>>
>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
>
> Should this also be applied to any older stable branches?
>
> i915_kick_out_firmware_fb() was introduced in 3.6 and it has always been
> possible for the alloc_apertures() call to fail.
>
> remove_conflicting_framebuffers() has returned an error code since 3.14
> (but could silently fail before then!) so this should be applicable to
> the 3.14 stable branch too.

tbh I don't know why this patch ended up in a stable kernel, at least
I didn't find anything where we (drm/i915 maintainers) marked it as
such. And there's no bugzilla references added either. Imo the patch
doesn't qualify for stable (it's not a real-world bug afaik).
-Daniel

>
> Ben.
>
>> ---
>>  drivers/gpu/drm/i915/i915_dma.c | 18 +++++++++++++-----
>>  1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
>> index d44344140627..0663fb4fa606 100644
>> --- a/drivers/gpu/drm/i915/i915_dma.c
>> +++ b/drivers/gpu/drm/i915/i915_dma.c
>> @@ -1425,15 +1425,16 @@ void i915_master_destroy(struct drm_device *dev, struct drm_master *master)
>>  }
>>
>>  #if IS_ENABLED(CONFIG_FB)
>> -static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
>> +static int i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
>>  {
>>       struct apertures_struct *ap;
>>       struct pci_dev *pdev = dev_priv->dev->pdev;
>>       bool primary;
>> +     int ret;
>>
>>       ap = alloc_apertures(1);
>>       if (!ap)
>> -             return;
>> +             return -ENOMEM;
>>
>>       ap->ranges[0].base = dev_priv->gtt.mappable_base;
>>       ap->ranges[0].size = dev_priv->gtt.mappable_end;
>> @@ -1441,13 +1442,16 @@ static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
>>       primary =
>>               pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
>>
>> -     remove_conflicting_framebuffers(ap, "inteldrmfb", primary);
>> +     ret = remove_conflicting_framebuffers(ap, "inteldrmfb", primary);
>>
>>       kfree(ap);
>> +
>> +     return ret;
>>  }
>>  #else
>> -static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
>> +static int i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
>>  {
>> +     return 0;
>>  }
>>  #endif
>>
>> @@ -1664,7 +1668,11 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
>>                       goto out_gtt;
>>               }
>>
>> -             i915_kick_out_firmware_fb(dev_priv);
>> +             ret = i915_kick_out_firmware_fb(dev_priv);
>> +             if (ret) {
>> +                     DRM_ERROR("failed to remove conflicting framebuffer drivers\n");
>> +                     goto out_gtt;
>> +             }
>>       }
>>
>>       pci_set_master(dev->pdev);
>
> --
> Ben Hutchings
> One of the nice things about standards is that there are so many of them.



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
