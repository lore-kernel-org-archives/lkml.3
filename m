Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaJBHq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:46:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:5663 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaJBHq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:46:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,637,1406617200"; 
   d="scan'208";a="582332856"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>, Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, daniel.vetter@intel.com,
        intel-gfx@lists.freedesktop.org,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: randconfig build error with next-20141001, in drivers/gpu/drm/i915
In-Reply-To: <542C46B3.2020901@infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <CA+r1ZhhmT4DrWtf6MbRQo5EqXwx+LxCqh15Vsu_d9WpftLhnxw@mail.gmail.com> <87fvf73c6g.fsf@intel.com> <542C46B3.2020901@infradead.org>
User-Agent: Notmuch/0.18.1+110~gd9ec63c (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 02 Oct 2014 10:46:52 +0300
Message-ID: <87eguq6hhv.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct 2014, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 10/01/14 10:57, Jani Nikula wrote:
>> On Wed, 01 Oct 2014, Jim Davis <jim.epost@gmail.com> wrote:
>>> Building with the attached random configuration file,
>>>
>>> warning: (VIDEO_TIMBERDALE) selects TIMB_DMA which has unmet direct
>>> dependencies (DMADEVICES && MFD_TIMBERDALE)
>>> warning: (USB_OTG_FSM && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG
>>> which has unmet direct dependencies (USB_SUPPORT && USB && PM_RUNTIME)
>>>
>>> drivers/built-in.o: In function `intel_panel_setup_backlight':
>>> (.text+0x11855d): undefined reference to `backlight_device_register'
>>> drivers/built-in.o: In function `intel_panel_destroy_backlight':
>>> (.text+0x118624): undefined reference to `backlight_device_unregister'
>>> make: *** [vmlinux] Error 1
>> 
>> It's the combination:
>> 
>>> CONFIG_DRM_I915=y
>>> CONFIG_BACKLIGHT_CLASS_DEVICE=m
>> 
>> Not sure what the Kconfig magic spell needs to be when we don't want to
>> depend on CONFIG_BACKLIGHT_CLASS_DEVICE but we'll use it if it's enabled
>> (y or m).
>
> Something like:
>
> 	depends on BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=n
>
> is what we usually use.

Oh boy this gets ugly. Trying

diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
index 4e39ab34eb1c..daa453c62aa6 100644
--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -3,6 +3,7 @@ config DRM_I915
 	depends on DRM
 	depends on X86 && PCI
 	depends on (AGP || AGP=n)
+	depends on (BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=n)
 	select INTEL_GTT
 	select AGP_INTEL if AGP
 	select INTERVAL_TREE

leads to

scripts/kconfig/conf --olddefconfig Kconfig
drivers/gpu/drm/i915/Kconfig:1:error: recursive dependency detected!
drivers/gpu/drm/i915/Kconfig:1:	symbol DRM_I915 depends on BACKLIGHT_CLASS_DEVICE
drivers/video/backlight/Kconfig:156:	symbol BACKLIGHT_CLASS_DEVICE is selected by DRM_I915

because we depend on ACPI_VIDEO when ACPI is enabled, originally done in

commit ecb4aed78dcf09e48c8c34c8c2fa7f5c69344be6
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 11:33:47 2009 -0400

    ACPI, i915: build fix

Now, trying to fix that with what seems to me like the obvious
dependency, conveying what we really want

diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
index 4e39ab34eb1c..f5a1ee37603e 100644
--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -3,6 +3,7 @@ config DRM_I915
 	depends on DRM
 	depends on X86 && PCI
 	depends on (AGP || AGP=n)
+	depends on ((ACPI && ACPI_VIDEO) || ACPI=n)
 	select INTEL_GTT
 	select AGP_INTEL if AGP
 	select INTERVAL_TREE
@@ -11,13 +12,6 @@ config DRM_I915
 	select SHMEM
 	select TMPFS
 	select DRM_KMS_HELPER
-	# i915 depends on ACPI_VIDEO when ACPI is enabled
-	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
-	select BACKLIGHT_LCD_SUPPORT if ACPI
-	select BACKLIGHT_CLASS_DEVICE if ACPI
-	select INPUT if ACPI
-	select ACPI_VIDEO if ACPI
-	select ACPI_BUTTON if ACPI
 	help
 	  Choose this option if you have a system that has "Intel Graphics
 	  Media Accelerator" or "HD Graphics" integrated graphics,

leads to more fun

scripts/kconfig/conf --olddefconfig Kconfig
drivers/video/fbdev/Kconfig:5:error: recursive dependency detected!
drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:34:	symbol DRM_KMS_FB_HELPER is selected by DRM_I915_FBDEV
drivers/gpu/drm/i915/Kconfig:40:	symbol DRM_I915_FBDEV depends on DRM_I915
drivers/gpu/drm/i915/Kconfig:1:	symbol DRM_I915 depends on ACPI_VIDEO
drivers/acpi/Kconfig:130:	symbol ACPI_VIDEO is selected by BACKLIGHT_CLASS_DEVICE
drivers/video/backlight/Kconfig:156:	symbol BACKLIGHT_CLASS_DEVICE is selected by FB_BACKLIGHT
drivers/video/fbdev/Kconfig:188:	symbol FB_BACKLIGHT is selected by PMAC_BACKLIGHT
drivers/macintosh/Kconfig:135:	symbol PMAC_BACKLIGHT depends on FB

and the rabbit hole gets deeper than I thought. I guess it always does.

At this point the question is whether "depends on ((ACPI && ACPI_VIDEO)
|| ACPI=n)" is worth pursuing and makes more sense than the "select foo
if ACPI" lines, or do we need to build hacks upon hacks to get this
fixed.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
