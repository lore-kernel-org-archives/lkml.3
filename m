Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbbALKad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:30:33 -0500
Received: from mga03.intel.com ([134.134.136.65]:14044 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbbALKac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:30:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,743,1413270000"; 
   d="scan'208";a="660423568"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: Re: [PATCH] drm/i915: fix inconsistent brightness after resume
In-Reply-To: <1420925135-1589-1-git-send-email-jmmahler@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <87fvbkz7nd.fsf@intel.com> <1420925135-1589-1-git-send-email-jmmahler@gmail.com>
User-Agent: Notmuch/0.19~rc1+1~g08b4944 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 12 Jan 2015 12:31:09 +0200
Message-ID: <877fwsxpci.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2015, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> Commit 6dda730e55f4 introduced a bug which resulted in inconsistent
> brightness levels on different machines. If a suspended was entered
> with the screen off some machines would resume with the screen
> at minimum brightness and others at maximum brightness.
>
> The following commands can be used to produce this behavior.
>
>   xset dpms force off
>   sleep 1
>   sudo systemctl suspend
>   (resume ...)
>
> The root cause of this problem is a comparison which checks to see if
> the backlight level is zero when the panel is enabled.  If it is zero,
> it is set to the maximum level.  Unfortunately, not all machines have a
> minimum level of zero. On those machines the level is left at the
> minimum instead of begin set to the maximum.

Good catch!

I think part of the problem is that the userspace sets brightness to
minimum before suspend, but apparently does not restore it after
resume. The dmesg would confirm this. But I guess it doesn't matter,
since we're pretty much stuck with having to do this anyway.

> Fix the bug by updating the comparison to check for the minimum
> backlight level instead of zero.
>
> Fixes: 6dda730e55f4 ("respect the VBT minimum backlight brightness")
> Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
> ---
>  drivers/gpu/drm/i915/intel_panel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index 4d63839..4ef4d66 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -962,7 +962,7 @@ void intel_panel_enable_backlight(struct intel_connector *connector)
>  
>  	WARN_ON(panel->backlight.max == 0);
>  
> -	if (panel->backlight.level == 0) {
> +	if (panel->backlight.level == panel->backlight.min) {

Perhaps <= instead of == would be safest?


BR,
Jani.

>  		panel->backlight.level = panel->backlight.max;
>  		if (panel->backlight.device)
>  			panel->backlight.device->props.brightness =
> -- 
> 2.1.4
>

-- 
Jani Nikula, Intel Open Source Technology Center
