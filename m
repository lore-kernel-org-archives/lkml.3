Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbaLBQfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:35:41 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:53996 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932483AbaLBQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:35:34 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Tue, 2 Dec 2014 16:35:06 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: compute wait_ioctl timeout
 correctly
Message-ID: <20141202163506.GG18921@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	John Stultz <john.stultz@linaro.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1417533733-2289-1-git-send-email-daniel.vetter@ffwll.ch>
 <1417534582-2977-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417534582-2977-1-git-send-email-daniel.vetter@ffwll.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 04:36:22PM +0100, Daniel Vetter wrote:
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
> Cc: Dave Gordon <david.s.gordon@intel.com>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=82749
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_drv.h | 8 ++++++++
>  drivers/gpu/drm/i915/i915_gem.c | 3 ++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 049482f5d9ac..4ea14a8c31f7 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -3097,6 +3097,14 @@ static inline unsigned long msecs_to_jiffies_timeout(const unsigned int m)
>  	return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);
>  }
>  
> +static inline unsigned long nsecs_to_jiffies_timeout(const u64 m)
> +{
> +	u64 usecs = div_u64(m + 999, 1000);
> +	unsigned long j = usecs_to_jiffies(usecs);
> +
> +	return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);

Or more concisely and review friendly:

static inline unsigned long nsecs_to_jiffies_timeout(const u64 n)
{
	return min_t(u64, MAX_JIFFY_OFFSET, nsecs_to_jiffies64(n) + 1);
}
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
