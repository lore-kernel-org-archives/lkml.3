Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbbAQKGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:06:41 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:50787 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbbAQKGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:06:39 -0500
Date: Sat, 17 Jan 2015 02:06:35 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Matt Roper <matthew.d.roper@intel.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Ander Conselvan de Oliveira <conselvan2@gmail.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [BUG, bisect] drm/i915: mouse pointer lags and overshoots
Message-ID: <20150117100635.GA1281@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dave Airlie <airlied@redhat.com>,
	Ander Conselvan de Oliveira <conselvan2@gmail.com>,
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt, all,

Commit ea2c67bb4aff introduces a bug which causes the mouse to move in a
very unusual way, as if it has a lot of inertia.  It will lag behind and
then overshoot the expected position.

I reproduced this bug on all my machines which use the drm/i915 drivers
and it affects all forms of mouse pointers including both touchpads and
usb mice.  The patch is present in linux-next 20150116.

  commit ea2c67bb4affa84080c616920f3899f123786e56
  Author: Matt Roper <matthew.d.roper@intel.com>
  Date:   Tue Dec 23 10:41:52 2014 -0800
  
      drm/i915: Move to atomic plane helpers (v9)
      
      Switch plane handling to use the atomic plane helpers.  This means that
      rather than provide our own implementations of .update_plane() and
      .disable_plane(), we expose the lower-level check/prepare/commit/cleanup
      entrypoints and let the DRM core implement update/disable for us using
      those entrypoints.
      
      The other main change that falls out of this patch is that our
      drm_plane's will now always have a valid plane->state that contains the
      relevant plane state (initial state is allocated at plane creation).
      The base drm_plane_state pointed to holds the requested source/dest
      coordinates, and the subclassed intel_plane_state holds the adjusted
      values that our driver actually uses.
      
      v2:
       - Renamed file from intel_atomic.c to intel_atomic_plane.c (Daniel)
       - Fix a copy/paste comment mistake (Bob)
      
      v3:
       - Use prepare/cleanup functions that we've already factored out
       - Use newly refactored pre_commit/commit/post_commit to avoid sleeping
         during vblank evasion
      
      v4:
       - Rebase to latest di-nightly requires adding an 'old_state' parameter
         to atomic_update;
      
      v5:
       - Must have botched a rebase somewhere and lost some work.  Restore
         state 'dirty' flag to let begin/end code know which planes to
         run the pre_commit/post_commit hooks for.  This would have actually
         shown up as broken in the next commit rather than this one.
      
      v6:
       - Squash kerneldoc patch into this one.
       - Previous patches have now already taken care of most of the
         infrastructure that used to be in this patch.  All we're adding here
         now is some thin wrappers.
      
      v7:
       - Check return of intel_plane_duplicate_state() for allocation
         failures.
      
      v8:
       - Drop unused drm_plane_state -> intel_plane_state cast.  (Ander)
       - Squash in actual transition to plane helpers.  Significant
         refactoring earlier in the patchset has made the combined
         prep+transition much easier to swallow than it was in earlier
         iterations. (Ander)
      
      v9:
       - s/track_fbs/disabled_planes/ in the atomic crtc flags.  The only fb's
         we need to update frontbuffer tracking for are those on a plane about
         to be disabled (since the atomic helpers never call prepare_fb() when
         disabling a plane), so the new name more accurately describes what
         we're actually tracking.
      
      Testcase: igt/kms_plane
      Testcase: igt/kms_universal_plane
      Testcase: igt/kms_cursor_crc
      Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
      Reviewed-by: Ander Conselvan de Oliveira <conselvan2@gmail.com>
      Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

-- 
- Jeremiah Mahler
