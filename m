Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaHaN6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 09:58:00 -0400
Received: from mout.gmx.net ([212.227.17.21]:57868 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaHaN54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 09:57:56 -0400
MIME-Version: 1.0
Message-ID: <trinity-308be27e-3d60-406a-9682-0c7f98712a4f-1409493472065@3capp-mailcom-bs04>
From: "Tibor Billes" <tbilles@gmx.com>
To: =?UTF-8?Q?=22Ville_Syrj=C3=A4l=C3=A4=22?= 
	<ville.syrjala@linux.intel.com>,
        "David Airlie" <airlied@linux.ie>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Jani Nikula" <jani.nikula@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Possible regression in 3.17-rc2 in i915 driver
Content-Type: text/plain; charset=UTF-8
Date: Sun, 31 Aug 2014 15:57:52 +0200
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: 8BIT
X-Priority: 3
X-Provags-ID: V03:K0:y6OI4rKTYEn6BneH0KMuLyjIQReHrYd4lYb6Qn59gMd
 ScHbGmuerJTIme/S2vvr89X2aidpgTwLyE9PsBS8DRkXybkMSl
 i7QPLHadf8z16dMC21zOMctsPs4fY0mapCXMV9FApgxsHzvaCy
 8UT45apmoEsHP90PLcxNFpPV9i1a5RgrE7Pp0dhfbr8UwQ1IhY
 3DoIvTsn36/m353KDOIGiLrNghDC+fQ0rN9rBnVeGR4IvmQmHK
 Tf9YjnhgBT90vSrN6vdv5PfQvC8SeNc6zAn/AdT1MU5un6x0JV
 DJHC7B3XM8VTAUNgB6UlmCOS5xy
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I tried to upgrade my kernel from 3.16 to 3.17-rc2 and I found that my laptop
was unable to boot. The boot process hangs after 2-3 seconds (according to
timestamps of log messages). The last kernel log line I usually see is the
discovery of my touchpad: "input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio2/input/input11".

I did a git bisect and it pointed me to the following commit:
commit 208bf9fdcd3575aa4a5d48b3e0295f7cdaf6fc44
Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
Date:   Mon Aug 11 13:15:35 2014 +0300
 
    drm/i915: Fix locking for intel_enable_pipe_a()
 
    intel_enable_pipe_a() gets called with all the modeset locks already
    held (by drm_modeset_lock_all()), so trying to grab the same
    locks using another drm_modeset_acquire_ctx is going to fail miserably.
     
    Move most of the drm_modeset_acquire_ctx handling (init/drop/fini)
    out from intel_{get,release}_load_detect_pipe() into the callers
    (intel_{crt,tv}_detect()). Only the actual locking and backoff
    handling is left in intel_get_load_detect_pipe(). And in
    intel_enable_pipe_a() we just share the mode_config.acquire_ctx from
    drm_modeset_lock_all() which is already holding all the relevant locks.
     
    It's perfectly legal to lock the same ww_mutex multiple times using the
    same ww_acquire_ctx. drm_modeset_lock() will convert the returned
    -EALREADY into 0, so the caller doesn't need to do antyhing special.
     
    Fixes a hang on resume on my 830.
     
    Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
    Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Cc: stable@vger.kernel.org
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>
 
I tried booting with the above commit reverted on top of 3.17-rc2 and it
booted successfully.
 
I also did a MagicSyrq-W (Display list of blocked (D state) tasks) after the
boot process stopped (using plain 3.17-rc2, without reverting the above commit)
and it showed that plymouthd was blocked with the following call trace (hand
copied):
irq_exit
common_interrupt
schedule_preemt_disabled
__mutex_lock_slowpath
mutex_lock
drm_modeset_lock
drm_getconnector
drm_mode_getcrttc
drm_ioctl
...
 
This may have something to do with the hang or it may not, I don't know but is
related to drm locking so I thought it was a good idea to mention it.
 
My laptop is an old Fujitsu-Siemens Amilo M1450g, running Linux Mint 16.
 
Let me know if I can help further debug this issue.
 
Tibor Billes
