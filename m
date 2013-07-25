Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3GYVxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:53:15 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:56597 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754001Ab3GYVxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:53:12 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 25 Jul 2013 22:52:59 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
Message-ID: <20130725215259.GB13295@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>,
	linux-next <linux-next@vger.kernel.org>
References: <CA+icZUUpnQ_=bTtK-0-qG90GjV38oeVe2E1v-KdLZQFQWH21GQ@mail.gmail.com>
 <CA+icZUXz+6MgbW952fU_da1-RfX8CSZp76gJnOwGDNsd-rdebA@mail.gmail.com>
 <CA+icZUV+D8PvEysipfg9nPXp3ON1QSA7DiFdpYFpdesFF5c0sw@mail.gmail.com>
 <20130725184504.GC11514@cantiga.alporthouse.com>
 <CA+icZUVLXxA5LPxzTjyhP5gryNUH3OY+vutoXQj6ydtCU0msbA@mail.gmail.com>
 <20130725190006.GD11514@cantiga.alporthouse.com>
 <CA+icZUW6oLE6cdnCkekz+43SrUn=vThqdfSKzz=XP-vmvB7Amw@mail.gmail.com>
 <20130725192248.GA13295@cantiga.alporthouse.com>
 <CA+icZUVE3s=6vXTLsCSmdLe_HMTOj+VD317kDeH3tF7svVW8kQ@mail.gmail.com>
 <CA+icZUU__nxcuX4RF9EBGm0nMBFaxfWpH00b2=ZsZZaxo9iscw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUU__nxcuX4RF9EBGm0nMBFaxfWpH00b2=ZsZZaxo9iscw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 10:07:02PM +0200, Sedat Dilek wrote:
> What means the bang line?
> 
> [    54.564] (II) GLX: Initialized DRI2 GL provider for screen 0
> [    54.565] bang: 1159
> [    54.565]
> Fatal server error:
> [    54.565] failed to create screen resources

That means between the kernel reporting success for
DRM_IOCTL_I915_GEM_MMAP_GTT and libdrm returning from
drm_intel_gem_bo_map_gtt(), something went wrong. This implies that the
call to mmap() failed.

I don't see how changing versions of the ddx would unmask the bug, nor
why the mmap() should suddenly start failing. Anybody have any
suggestions other than

diff --git a/src/intel_uxa.c b/src/intel_uxa.c
index 2f14173..3872258 100644
--- a/src/intel_uxa.c
+++ b/src/intel_uxa.c
@@ -1149,12 +1149,15 @@ Bool intel_uxa_create_screen_resources(ScreenPtr screen)
        PixmapPtr pixmap;
        intel_screen_private *intel = intel_get_screen_private(scrn);
        dri_bo *bo = intel->front_buffer;
+       int ret;
 
        if (!uxa_resources_init(screen))
                return FALSE;
 
-       if (drm_intel_gem_bo_map_gtt(bo))
+       if ((ret = drm_intel_gem_bo_map_gtt(bo))) {
+               ErrorF("%s:%d bang, errno=%d\n", __func__, __LINE__, -ret);
                return FALSE;
+       }
 
        pixmap = screen->GetScreenPixmap(screen);
        intel_set_pixmap_bo(pixmap, bo);

which is most likely to report EINVAL (22)?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
