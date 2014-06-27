Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaF0Tvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:51:42 -0400
Received: from mx02.posteo.de ([89.146.194.165]:42537 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750980AbaF0Tvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:51:40 -0400
Message-ID: <53ADCB24.9030206@posteo.de>
Date: Fri, 27 Jun 2014 21:51:00 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black instead
 of native resolution
References: <53A6E72A.9090000@posteo.de>		 <744357E9AAD1214791ACBA4B0B90926301379B97@SHSMSX101.ccr.corp.intel.com>		 <53A81BF7.3030207@posteo.de> <1403529246.4686.6.camel@rzhang1-toshiba>	 <53A83DC7.1010606@posteo.de> <1403882067.16305.124.camel@rzhang1-toshiba> <53ADB359.4010401@posteo.de>
In-Reply-To: <53ADB359.4010401@posteo.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-06-27 20:09, schrieb Martin Kepplinger:
> Am 2014-06-27 17:14, schrieb Zhang Rui:
>> On Mon, 2014-06-23 at 16:46 +0200, Martin Kepplinger wrote:
>>> Am 2014-06-23 15:14, schrieb Zhang Rui:
>>>> On Mon, 2014-06-23 at 14:22 +0200, Martin Kepplinger wrote:
>>>>> Am 2014-06-23 03:10, schrieb Zhang, Rui:
>>>>>>
>>>>>>
>>>>>>> -----Original Message-----
>>>>>>> From: Martin Kepplinger [mailto:martink@posteo.de]
>>>>>>> Sent: Sunday, June 22, 2014 10:25 PM
>>>>>>> To: Zhang, Rui
>>>>>>> Cc: rjw@rjwysocki.net; lenb@kernel.org; linux-acpi@vger.kernel.org;
>>>>>>> linux-kernel@vger.kernel.org
>>>>>>> Subject: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black
>>>>>>> instead of native resolution
>>>>>>> Importance: High
>>>>>>>
>>>>>>> Since 3.16-rc1 my laptop's just goes black while booting, instead of
>>>>>>> switching to native screen resolution and showing me the starting
>>>>>>> system there. It's an Acer TravelMate B113 with i915 driver and
>>>>>>> acer_wmi. It stays black and is unusable.
>>>>>>>
>>>> This looks like a duplicate of
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=78601
>>>>
>>>> thanks,
>>>> rui
>>> I'm not sure about that. I have no problem with v3.15 and the screen
>>> goes black way before a display manager is started. It's right after the
>>> kernel loaded and usually the screen is set to native resolution.
>>>
>>> Bisect told me aaeb2554337217dfa4eac2fcc90da7be540b9a73 as the first bad
>>> one. Although, checking that out and running it, works good. not sure if
>>> that makes sense.
>>>
>> could you please check if the comment in
>> https://bugzilla.kernel.org/show_bug.cgi?id=78601#c5 solves your problem
>> or not?
>>
>> thanks,
>> rui
> 
> thanks for checking. This does not change anything though. I tested the
> following on top of v3.16-rc2 and linus's tree as of today, almost -rc3.
> 
> ---
>  drivers/gpu/drm/i915/intel_fbdev.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_fbdev.c
> b/drivers/gpu/drm/i915/intel_fbdev.c
> index 088fe93..1e2f9ae 100644
> --- a/drivers/gpu/drm/i915/intel_fbdev.c
> +++ b/drivers/gpu/drm/i915/intel_fbdev.c
> @@ -453,7 +453,6 @@ out:
>  }
> 
>  static struct drm_fb_helper_funcs intel_fb_helper_funcs = {
> -       .initial_config = intel_fb_initial_config,
>         .gamma_set = intel_crtc_fb_gamma_set,
>         .gamma_get = intel_crtc_fb_gamma_get,
>         .fb_probe = intelfb_create,
> 

I also tested the following patch from
http://lists.freedesktop.org/archives/intel-gfx/2014-June/047981.html
now, with no results. No change in my case :(

diff --git a/drivers/gpu/drm/i915/intel_display.c
b/drivers/gpu/drm/i915/intel_display.c
index efd3cf5..5aee08e 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -11087,6 +11087,22 @@ const char *intel_output_name(int output)
        return names[output];
 }

+static bool intel_crt_present(struct drm_device *dev)
+{
+       struct drm_i915_private *dev_priv = dev->dev_private;
+
+       if (IS_ULT(dev))
+               return false;
+
+       if (IS_CHERRYVIEW(dev))
+               return false;
+
+       if (IS_VALLEYVIEW(dev) && !dev_priv->vbt.int_crt_support)
+               return false;
+
+       return true;
+}
+
 static void intel_setup_outputs(struct drm_device *dev)
 {
        struct drm_i915_private *dev_priv = dev->dev_private;
@@ -11095,7 +11111,7 @@ static void intel_setup_outputs(struct
drm_device *dev)

        intel_lvds_init(dev);

-       if (!IS_ULT(dev) && !IS_CHERRYVIEW(dev) &&
dev_priv->vbt.int_crt_support)
+       if (intel_crt_present(dev))
                intel_crt_init(dev);

        if (HAS_DDI(dev)) {
-- 
1.7.10.4
