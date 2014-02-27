Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaB0Bit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:38:49 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:65367 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaB0Bis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:38:48 -0500
MIME-Version: 1.0
In-Reply-To: <874n3n8u6u.fsf@intel.com>
References: <CA+5PVA4zC1+TPWWdANnm7RuBDduwNetdTknfzSkVTpFcPSGZww@mail.gmail.com>
	<CA+5PVA6Td43Zzd8L59_mE7E5hFuVSxhAwd+tczs_BSHXNOx5yw@mail.gmail.com>
	<20140223155059.GA11167@zod>
	<874n3n8u6u.fsf@intel.com>
Date: Wed, 26 Feb 2014 20:38:48 -0500
X-Google-Sender-Auth: 3lm-2OYwhzKkHZTxSxvq9GN51-0
Message-ID: <CA+5PVA5RPHPVhpjAdhVaow-2qDQMxiUEDMM5mtAkckAMxRZ=Kg@mail.gmail.com>
Subject: Re: 3.13 i915 brightness settings broken when going from docked -> undocked
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 3:36 AM, Jani Nikula <jani.nikula@intel.com> wrote:
> On Sun, 23 Feb 2014, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> Backport of upstream commit c91c9f328
>>
>> ---
>>  drivers/gpu/drm/i915/i915_drv.h       |  1 +
>>  drivers/gpu/drm/i915/intel_opregion.c | 31 ++++++-------------------------
>>  drivers/gpu/drm/i915/intel_panel.c    |  4 ++++
>>  3 files changed, 11 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
>> index 221ac62..d6d4349 100644
>> --- a/drivers/gpu/drm/i915/i915_drv.h
>> +++ b/drivers/gpu/drm/i915/i915_drv.h
>> @@ -1371,6 +1371,7 @@ typedef struct drm_i915_private {
>>
>>       /* backlight */
>>       struct {
>> +             bool present;
>>               int level;
>>               bool enabled;
>>               spinlock_t lock; /* bl registers and the above bl fields */
>> diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
>> index 6d69a9b..b2a51ae 100644
>> --- a/drivers/gpu/drm/i915/intel_opregion.c
>> +++ b/drivers/gpu/drm/i915/intel_opregion.c
>> @@ -414,38 +414,19 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
>>               return ASLC_BACKLIGHT_FAILED;
>>
>>       mutex_lock(&dev->mode_config.mutex);
>> -     /*
>> -      * Could match the OpRegion connector here instead, but we'd also need
>> -      * to verify the connector could handle a backlight call.
>> -      */
>> -     list_for_each_entry(encoder, &dev->mode_config.encoder_list, head)
>> -             if (encoder->crtc == crtc) {
>> -                     found = true;
>> -                     break;
>> -             }
>> -
>> -     if (!found) {
>> -             ret = ASLC_BACKLIGHT_FAILED;
>> -             goto out;
>> -     }
>>
>> -     list_for_each_entry(connector, &dev->mode_config.connector_list, head)
>> -             if (connector->encoder == encoder)
>> -                     intel_connector = to_intel_connector(connector);
>> -
>> -     if (!intel_connector) {
>> -             ret = ASLC_BACKLIGHT_FAILED;
>> -             goto out;
>> +     DRM_DEBUG_KMS("updating opregion backlight %d/255\n", bclp);
>> +     list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
>> +             intel_connector = to_intel_connector(connector);
>> +             if (dev_priv->backlight.present)
>> +                     intel_panel_set_backlight(intel_connector, bclp, 255);
>>       }
>
> This is not correct because in v3.13 dev_priv->backlight is still driver
> global, not per connector. This means that if you have at least one
> connector with backlight control, the backlight is attempted to change
> on all connectors. In your case, I'm not sure if it leads to anything
> more than extra adjusting of the same backlight.

Well, empirically it leads to the backlight actually changing after
undocking my machine whereas without it, it doesn't.  So maybe by
changing it globally, it is hitting the connector that does have
backlight control.

Anyway, I'm not arguing my patch is correct.  Just that it does do
_something_ to make the backlight work :).

> If you move the 'bool present' field to intel_connector or intel_panel,
> I think this is all right.

That sounds like more of an invasive change.  I could poke at it, but
I'm not sure it would be suitable for e.g. 3.13.y stable.  Thoughts on
that?  Admittedly it is a somewhat minor problem, so if it's not
easily stable material, I don't think anyone is going to lose sleep
over it.

josh
