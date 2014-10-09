Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060AbaJIFnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 01:43:39 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11468 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaJIFnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 01:43:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 08 Oct 2014 22:43:19 -0700
Message-ID: <54362066.9000504@nvidia.com>
Date: Thu, 9 Oct 2014 14:43:02 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Thierry Reding <treding@nvidia.com>
CC: <linux-samsung-soc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] drm/exynos: fix vblank handling during dpms off
References: <542B9A0E.7020206@samsung.com> <1412151287-12845-1-git-send-email-a.hajda@samsung.com> <542D13CC.5000304@samsung.com> <542D2E7C.1020904@samsung.com> <542D3C96.7000400@samsung.com>
In-Reply-To: <542D3C96.7000400@samsung.com>
X-NVConfidentiality: public
X-Originating-IP: [10.19.57.128]
X-ClientProxiedBy: DRBGMAIL104.nvidia.com (10.18.16.23) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 08:52 PM, Andrzej Hajda wrote:
> Hi,
>
> +CC possible victims
>
> On 10/02/2014 12:52 PM, Inki Dae wrote:
>> On 2014년 10월 02일 17:58, Joonyoung Shim wrote:
>>> Hi Andrzej,
>>>
>>> On 10/01/2014 05:14 PM, Andrzej Hajda wrote:
>>>> The patch disables vblanks during dpms off only if pagefilp has
>>>> not been finished. It also replaces drm_vblank_off with drm_crtc_vblank_put.
>>>> It fixes issue with page_flip ioctl not being able to acquire vblank counter.
>>> This problem isn't related with pageflip, it just causes from
>>> 7ffd7a68511c710b84db3548a1997fd2625f580a commit (drm: Always reject
>>> drm_vblank_get() after drm_vblank_off()).
>>>
>>> We need to use drm_vblank_on() as a counterpart to drm_vblank_off()
>>> after the commit .
>
> This patch should break also other drivers, it seems at least following
> drms could be affected:
> armada, sti, tegra.

Indeed we (tegra) have just been hit by this. The problem seems to come 
from the fact that we have been using drm_vblank_pre_modeset, 
drm_vblank_post_modeset and drm_vblank_off conjointly. All these 
functions depend on the value of vblank->inmodeset, and 7ffd7a68511 
increases the vblank reference counter only in drm_vblank_off, which can 
result in the acquired reference never being released.

The following seems to fix this for Tegra, by stopping using 
drm_vblank_pre/post_modeset and relying on drm_vblank_off/on instead:

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index b08df07cad47..3955d81236d0 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -739,7 +739,6 @@ static const struct drm_crtc_funcs tegra_crtc_funcs = {

  static void tegra_crtc_disable(struct drm_crtc *crtc)
  {
-       struct tegra_dc *dc = to_tegra_dc(crtc);
         struct drm_device *drm = crtc->dev;
         struct drm_plane *plane;

@@ -755,7 +754,7 @@ static void tegra_crtc_disable(struct drm_crtc *crtc)
                 }
         }

-       drm_vblank_off(drm, dc->pipe);
+       drm_crtc_vblank_off(crtc);
  }

  static bool tegra_crtc_mode_fixup(struct drm_crtc *crtc,
@@ -844,7 +843,7 @@ static int tegra_crtc_mode_set(struct drm_crtc *crtc,
         u32 value;
         int err;

-       drm_vblank_pre_modeset(crtc->dev, dc->pipe);
+       drm_crtc_vblank_off(crtc);

         err = tegra_crtc_setup_clk(crtc, mode);
         if (err) {
@@ -946,7 +945,7 @@ static void tegra_crtc_commit(struct drm_crtc *crtc)
         value = GENERAL_ACT_REQ | WIN_A_ACT_REQ;
         tegra_dc_writel(dc, value, DC_CMD_STATE_CONTROL);

-       drm_vblank_post_modeset(crtc->dev, dc->pipe);
+       drm_crtc_vblank_on(crtc);
  }

  static void tegra_crtc_load_lut(struct drm_crtc *crtc)

Thierry, does this look ok to you?

But there might be another issue, which is that calls to 
drm_vblank_get() will return -EINVAL if invoked between drm_blank_off 
and drm_blank_on. Is this really the desired behavior? Can it at least 
happen? If so, how are drivers supposed to react to this situation?
