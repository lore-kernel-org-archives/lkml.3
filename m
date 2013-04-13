Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab3DMRKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 13:10:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:51600 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab3DMRKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 13:10:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,468,1363158000"; 
   d="scan'208";a="294498081"
Date: Sat, 13 Apr 2013 18:10:40 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@linux.ie, daniel.vetter@ffwll.ch
Subject: Re: drm: i915+fb: crtc->lock recursive locking deadlock on VT switch
 [>= 3.9-rc1 regresion]
Message-ID: <20130413171040.GA24925@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Krzysztof Mazur <krzysiek@podlesie.net>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	airlied@linux.ie, daniel.vetter@ffwll.ch
References: <20130413154146.GA8136@shrek.podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413154146.GA8136@shrek.podlesie.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 05:41:46PM +0200, Krzysztof Mazur wrote:
> Hi,
> 
> the drm_fb_helper_hotplug_event() locks all crtc->mutex locks by calling
> drm_modeset_lock_all() and later calls drm_fb_helper_probe_connector_modes(),
> which in case of i915 DRM driver effectively calls
> intel_get_load_detect_pipe() that tries to lock crtc->mutex again.
> This causes a deadlock, and can be in some cases triggered by VT
> switch to framebuffer console on i915.
> 
> This bug is introduced in Linux 3.9-rc1 and still exists
> in v3.9-rc6-183-gbf81710. Linux 3.8 is ok.

In Dave's drm-fixes branch:

commit 89ced125472b8551c65526934b7f6c733a6864fa
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Apr 11 14:26:55 2013 +0000

    drm/fb-helper: Fix locking in drm_fb_helper_hotplug_event
    
    Driver's and ->fill_modes functions are allowed to grab crtc mutexes
    (for e.g. load detect). Hence we need to first only grab the general
    kms mutex, and only in a second step grab all locks to do the
    modesets.
    
    This prevents a deadlock on my gm45 in the tv load detect code called
    by drm_helper_probe_single_connector_modes.
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
