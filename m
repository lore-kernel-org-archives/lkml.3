Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbbAURNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:13:53 -0500
Received: from mga14.intel.com ([192.55.52.115]:29911 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbbAURNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:13:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,442,1418112000"; 
   d="scan'208";a="640504873"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: Re: [PATCH v2] drm/i915: fix inconsistent brightness after resume
In-Reply-To: <1421089263-30398-1-git-send-email-jmmahler@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20150112184701.GA23217@hudson.localdomain> <1421089263-30398-1-git-send-email-jmmahler@gmail.com>
User-Agent: Notmuch/0.19+30~g8f95761 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 21 Jan 2015 19:04:45 +0200
Message-ID: <87h9vk5aky.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015, Jeremiah Mahler <jmmahler@gmail.com> wrote:
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
>
> Fix the bug by updating the comparison to check for the minimum
> backlight level instead of zero.  Also, expand the comparison for
> the possible case when the level is less than the minimum.
>
> Fixes: 6dda730e55f4 ("respect the VBT minimum backlight brightness")
> Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>

Pushed to drm-intel-fixes, thanks for the patch.

BR,
Jani.


> ---
>
> Notes:
>     Changes in v2:
>     
>       - Expand the comparision for the possible case when
>         the level is less than the minimum.
>
>  drivers/gpu/drm/i915/intel_panel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index 4d63839..dfb783a 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -962,7 +962,7 @@ void intel_panel_enable_backlight(struct intel_connector *connector)
>  
>  	WARN_ON(panel->backlight.max == 0);
>  
> -	if (panel->backlight.level == 0) {
> +	if (panel->backlight.level <= panel->backlight.min) {
>  		panel->backlight.level = panel->backlight.max;
>  		if (panel->backlight.device)
>  			panel->backlight.device->props.brightness =
> -- 
> 2.1.4
>

-- 
Jani Nikula, Intel Open Source Technology Center
