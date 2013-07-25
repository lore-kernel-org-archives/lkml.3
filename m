Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3GYBCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:02:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47251 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab3GYBCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:02:44 -0400
Date: Thu, 25 Jul 2013 02:02:41 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm qxl fixes
Message-ID: <alpine.DEB.2.00.1307250152320.25676@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Okay as I warned, the qxl driver was running a bit free and loose with its
ttm object reservations and the new lockdep enabled reservation tracking 
shone a bright light into it, it also with the new reservations mutexes
hits a possible deadlock during boot.

the first patch is a real fix to render the console correctly as the 
driver used to just drop irq renderering as too hard, this also fixes
a sleeping while atomic warning.

the second two patches are the big ugly ones that redo how the driver 
allocates objects and reserves them and makes things all work properly,
I've tested this in a VM, and compared to the current code which hits
a lockdep warning and the sleep while atomic warning before failing.

So sorry this is coming in late, I should have tested qxl before merging 
the mutex code, but I'd rather just fix qxl with this than revert the 
reservations code at this point.

Dave.

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux qxl-fixes

for you to fetch changes up to 8002db6336dd361fc13214e9515fe5d52ff294ee:

  qxl: convert qxl driver to proper use for reservations (2013-07-24 11:58:10 +1000)

----------------------------------------------------------------
Dave Airlie (3):
      drm/qxl: add delayed fb operations
      qxl: allow creation of pre-pinned objects and use for releases.
      qxl: convert qxl driver to proper use for reservations

 drivers/gpu/drm/qxl/qxl_cmd.c     |  42 +++--
 drivers/gpu/drm/qxl/qxl_display.c |  70 ++++++---
 drivers/gpu/drm/qxl/qxl_draw.c    | 263 +++++++++++++++++++++----------
 drivers/gpu/drm/qxl/qxl_drv.h     |  76 ++++-----
 drivers/gpu/drm/qxl/qxl_fb.c      | 184 +++++++++++++++++++---
 drivers/gpu/drm/qxl/qxl_fence.c   |  10 +-
 drivers/gpu/drm/qxl/qxl_gem.c     |   2 +-
 drivers/gpu/drm/qxl/qxl_image.c   | 111 ++++++++++---
 drivers/gpu/drm/qxl/qxl_ioctl.c   | 319 +++++++++++++++++++++-----------------
 drivers/gpu/drm/qxl/qxl_object.c  |  70 ++-------
 drivers/gpu/drm/qxl/qxl_object.h  |   6 +-
 drivers/gpu/drm/qxl/qxl_release.c | 212 +++++++++++++++----------
 drivers/gpu/drm/qxl/qxl_ttm.c     |   2 +-
 13 files changed, 859 insertions(+), 508 deletions(-)
