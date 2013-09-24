Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917Ab3IXFwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 01:52:20 -0400
Received: from mailout10.t-online.de ([194.25.134.21]:40885 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3IXFwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 01:52:18 -0400
Message-ID: <52412886.5070106@t-online.de>
Date: Tue, 24 Sep 2013 07:52:06 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Imre Deak <imre.deak@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915/tv: clear adjusted_mode.flags
References: <522EDB3D.7040504@t-online.de> <1378806270-18132-1-git-send-email-daniel.vetter@ffwll.ch>
In-Reply-To: <1378806270-18132-1-git-send-email-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: V+j8IyZZoh9jx3nHSgxovpuDJ95Rk-NOdGtY6DQnGNq5NrEMtRiKwJS9BgAuM3xQva
X-TOI-MSGID: 214864f4-b7b1-4290-9230-adab818a27f2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel!

This patch is definitely needed for 3.12, but it is still missing in 3.12-rc2 ...

cu,
  Knut

On 10.09.2013 11:44, Daniel Vetter wrote:
> The native TV encoder has it's own flags to adjust sync modes and
> enabled interlaced modes which are totally irrelevant for the adjusted
> mode. This worked out nicely since the input modes used by both the
> load detect code and reported in the ->get_modes callbacks all have no
> flags set, and we also don't fill out any of them in the ->get_config
> callback.
>
> This changed with the additional sanitation done with
>
> commit 2960bc9cceecb5d556ce1c07656a6609e2f7e8b0
> Author: Imre Deak <imre.deak@intel.com>
> Date:   Tue Jul 30 13:36:32 2013 +0300
>
>      drm/i915: make user mode sync polarity setting explicit
>
> sinc now the "no flags at all" state wouldn't fit through core code
> any more. So fix this up again by explicitly clearing the flags in the
> ->compute_config callback.
>
> Aside: We have zero checking in place to make sure that the requested
> mode is indeed the right input mode we want for the selected TV mode.
> So we'll happily fall over if userspace tries to pull us.  But that's
> definitely work for a different patch series. So just add a FIXME
> comment for now.
>
> Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
> Cc: Knut Petersen <Knut_Petersen@t-online.de>
> Cc: Imre Deak <imre.deak@intel.com>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>   drivers/gpu/drm/i915/intel_tv.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
> index f2c6d79..dd6f84b 100644
> --- a/drivers/gpu/drm/i915/intel_tv.c
> +++ b/drivers/gpu/drm/i915/intel_tv.c
> @@ -916,6 +916,14 @@ intel_tv_compute_config(struct intel_encoder *encoder,
>   	DRM_DEBUG_KMS("forcing bpc to 8 for TV\n");
>   	pipe_config->pipe_bpp = 8*3;
>   
> +	/* TV has it's own notion of sync and other mode flags, so clear them. */
> +	pipe_config->adjusted_mode.flags = 0;
> +
> +	/*
> +	 * FIXME: We don't check whether the input mode is actually what we want
> +	 * or whether userspace is doing something stupid.
> +	 */
> +
>   	return true;
>   }
>   

