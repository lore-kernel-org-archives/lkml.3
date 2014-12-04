Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbaLDRpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:45:46 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:54678 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaLDRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:45:44 -0500
MIME-Version: 1.0
In-Reply-To: <1417687974-18681-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1417166995-10803-1-git-send-email-daniel.vetter@ffwll.ch>
	<1417687974-18681-1-git-send-email-daniel.vetter@ffwll.ch>
Date: Thu, 4 Dec 2014 09:45:44 -0800
Message-ID: <CALAqxLWU-jo_V6A1s0Wvr3VA0P0pkPxv-JmOFBFDZdKCM_8etQ@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: compute wait_ioctl timeout correctly
From: John Stultz <john.stultz@linaro.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Gordon <david.s.gordon@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 2:12 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> We've lost the +1 required for correct timeouts in
>
> commit 5ed0bdf21a85d78e04f89f15ccf227562177cbd9
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Jul 16 21:05:06 2014 +0000
>
>     drm: i915: Use nsec based interfaces
>
>     Use ktime_get_raw_ns() and get rid of the back and forth timespec
>     conversions.
>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>     Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>     Signed-off-by: John Stultz <john.stultz@linaro.org>
>
> So fix this up by reinstating our handrolled _timeout function. While
> at it bother with handling MAX_JIFFIES.
>
> v2: Convert to usecs (we don't care about the accuracy anyway) first
> to avoid overflow issues Dave Gordon spotted.
>
> v3: Drop the explicit MAX_JIFFY_OFFSET check, usecs_to_jiffies should
> take care of that already. It might be a bit too enthusiastic about it
> though.
>
> v4: Chris has a much nicer color, so use his implementation.
>
> This requires to export nsec_to_jiffies from time.c.
>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Dave Gordon <david.s.gordon@intel.com>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=82749
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_drv.h | 5 +++++
>  drivers/gpu/drm/i915/i915_gem.c | 3 ++-
>  kernel/time/time.c              | 1 +
>  3 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 049482f5d9ac..564a45f4a0ab 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -3097,6 +3097,11 @@ static inline unsigned long msecs_to_jiffies_timeout(const unsigned int m)
>         return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);
>  }
>
> +static inline unsigned long nsecs_to_jiffies_timeout(const u64 n)
> +{
> +        return min_t(u64, MAX_JIFFY_OFFSET, nsecs_to_jiffies64(n) + 1);
> +}
> +
>  static inline unsigned long
>  timespec_to_jiffies_timeout(const struct timespec *value)
>  {
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 9d362d320d82..04a9f26407ae 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -1226,7 +1226,8 @@ int __i915_wait_request(struct drm_i915_gem_request *req,
>         if (i915_gem_request_completed(req, true))
>                 return 0;
>
> -       timeout_expire = timeout ? jiffies + nsecs_to_jiffies((u64)*timeout) : 0;
> +       timeout_expire = timeout ?
> +               jiffies + nsecs_to_jiffies_timeout((u64)*timeout) : 0;
>
>         if (INTEL_INFO(dev)->gen >= 6 && ring->id == RCS && can_wait_boost(file_priv)) {
>                 gen6_rps_boost(dev_priv);
> diff --git a/kernel/time/time.c b/kernel/time/time.c
> index a9ae20fb0b11..8fae82ca5cbf 100644
> --- a/kernel/time/time.c
> +++ b/kernel/time/time.c
> @@ -745,6 +745,7 @@ u64 nsecs_to_jiffies64(u64 n)
>         return div_u64(n * 9, (9ull * NSEC_PER_SEC + HZ / 2) / HZ);
>  #endif
>  }
> +EXPORT_SYMBOL(nsecs_to_jiffies64);


For the sake of the fix,
Acked-by: John Stultz <john.stultz@linaro.org>

But I'll likely follow this (eventually - since its going through the
drm tree) with a cleanup patch moving nsecs_to_jiffies_timeout over to
time.c.

thanks
-john
