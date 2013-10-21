Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab3JUWdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:33:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55780 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3JUWdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:33:52 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [RFC v2 0/6] DRM revoke support
Date: Tue, 22 Oct 2013 00:33:22 +0200
Message-Id: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is the 2nd revision of reliable unplug support for DRM. As revoke support
for the generic VFS layer is still not even close to being merged, this fixes
the generic DRM layer to handle unplugged devices gracefully.

This series fixes the DRM core to track any running f_ops. During device
unplugging (which is the same as revoke()) we mark a device as unplugged so no
new f_ops are started. Then we wait for running f_ops to finish and then close
all open files (and leave just dummies behind). Now we can unregister the device
without waiting for userspace to call close() on all fds.

Any comments are welcome. Drivers which provide their own f_ops need to be
fixed, other than that this is already working. Tested with udl locally. Running
applications get poll(HUP) or SIGBUS for mmaps depending on what they're doing
if they access the device after unplugging.

Thanks
David

David Herrmann (6):
  percpu_rw_semaphore: export symbols for modules
  percpu_rw_semaphore: add percpu_down_read_trylock()
  drm: split drm_release()
  drm: make dev->unplugged reliable
  drm: make drm_dev_unregister() immediate
  drm: zap mmaps for dead devices

 drivers/gpu/drm/Kconfig             |   1 +
 drivers/gpu/drm/drm_drv.c           |   5 +-
 drivers/gpu/drm/drm_fops.c          | 111 ++++++++++++++-------
 drivers/gpu/drm/drm_gem.c           |  10 +-
 drivers/gpu/drm/drm_stub.c          | 192 ++++++++++++++++++++++++++++++------
 drivers/gpu/drm/drm_vm.c            |   3 +-
 drivers/gpu/drm/udl/udl_connector.c |   2 +-
 drivers/gpu/drm/udl/udl_drv.c       |   2 +-
 drivers/gpu/drm/udl/udl_fb.c        |   4 +-
 include/drm/drmP.h                  |  27 +++--
 include/linux/percpu-rwsem.h        |   1 +
 lib/Makefile                        |   2 +-
 lib/percpu-rwsem.c                  |  27 +++++
 13 files changed, 296 insertions(+), 91 deletions(-)

-- 
1.8.4.1

