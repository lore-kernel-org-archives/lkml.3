Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaDWLE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:04:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:5263 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaDWLEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:04:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,911,1389772800"; 
   d="scan'208";a="526047052"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Discard BIOS framebuffers too small to accommodate chosen mode
In-Reply-To: <20140423082421.GE18465@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20140423071125.GS10722@phenom.ffwll.local> <1398239671-4135-1-git-send-email-chris@chris-wilson.co.uk> <20140423082421.GE18465@intel.com>
User-Agent: Notmuch/0.18~rc0+1~g40dc79d6ac82 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 23 Apr 2014 14:03:44 +0300
Message-ID: <87fvl4qpdb.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Ville Syrjälä <ville.syrjala@linux.intel.com> wrote:
> On Wed, Apr 23, 2014 at 08:54:31AM +0100, Chris Wilson wrote:
>> If the inherited BIOS framebuffer is smaller than the mode selected for
>> fbdev, then if we continue to use it then we cause display corruption as
>> we do not setup the panel fitter to upscale.
>> 
>> Regression from commit d978ef14456a38034f6c0e94a794129501f89200
>> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
>> Date:   Fri Mar 7 08:57:51 2014 -0800
>> 
>>     drm/i915: Wrap the preallocated BIOS framebuffer and preserve for KMS fbcon v12
>> 
>> v2: Add a debug message to track the discard of the BIOS fb.
>> v3: Ville pointed out the difference between ref/unref
>> 
>> Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
>> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=77767
>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Pushed to -fixes, thanks for the patch and review.

BR,
Jani.


>
>> ---
>>  drivers/gpu/drm/i915/intel_fbdev.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>> 
>> diff --git a/drivers/gpu/drm/i915/intel_fbdev.c b/drivers/gpu/drm/i915/intel_fbdev.c
>> index b16116db6c37..fbe7941f88c8 100644
>> --- a/drivers/gpu/drm/i915/intel_fbdev.c
>> +++ b/drivers/gpu/drm/i915/intel_fbdev.c
>> @@ -133,6 +133,16 @@ static int intelfb_create(struct drm_fb_helper *helper,
>>  
>>  	mutex_lock(&dev->struct_mutex);
>>  
>> +	if (intel_fb &&
>> +	    (sizes->fb_width > intel_fb->base.width ||
>> +	     sizes->fb_height > intel_fb->base.height)) {
>> +		DRM_DEBUG_KMS("BIOS fb too small (%dx%d), we require (%dx%d),"
>> +			      " releasing it\n",
>> +			      intel_fb->base.width, intel_fb->base.height,
>> +			      sizes->fb_width, sizes->fb_height);
>> +		drm_framebuffer_unreference(&intel_fb->base);
>> +		intel_fb = ifbdev->fb = NULL;
>> +	}
>>  	if (!intel_fb || WARN_ON(!intel_fb->obj)) {
>>  		DRM_DEBUG_KMS("no BIOS fb, allocating a new one\n");
>>  		ret = intelfb_alloc(helper, sizes);
>> -- 
>> 1.9.2
>> 
>> _______________________________________________
>> Intel-gfx mailing list
>> Intel-gfx@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
>
> -- 
> Ville Syrjälä
> Intel OTC
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Jani Nikula, Intel Open Source Technology Center
