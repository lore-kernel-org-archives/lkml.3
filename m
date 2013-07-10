Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab3GJXqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:46:17 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40199 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab3GJXqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:46:14 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Airlie <airlied@redhat.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 0/2] Anonymous Inode Allocations
Date: Thu, 11 Jul 2013 01:45:28 +0200
Message-Id: <1373499930-5055-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This implements anon_inodes_new() to create anonymous inodes. Patch #1
describes the changes to anon_inodes.c and why DRM could make great use of this.
Patch #2 converts DRM core to use anon_inodes_new() instead of delayed
dev_mapping initialization (but kept simple, TTM can be converted later).

The idea is to get an anonymous backing inode for DRM devices without waiting
for the first char-dev inode. We use it to unmap userspace mappings via
unmap_mapping_range() if we have to evict buffers if GTT runs short or if the FW
framebuffers are destroyed.
We need the inode only once the first user-space mapping was created, but the
delayed initialization causes an ugly code base and keeps inodes of char-devs
around just to preserve the address_space.

We actually only need the address_space, but mm core requires an corresponding
file* and FS core requires mapping->host to be set (although I am not sure
whether we can hit those paths with char-devs). So I went with the whole
anonymous inode approach.

If anyone has an idea how to use an embedded "struct address_space" inside of
"drm_device" and set "dev_mapping->host" to the shared anon_inode_inode, I'd be
happy to implement it. However, I didn't succeed and I am actually not sure that
separate "struct address_space" are actually supported. For instance, DRM core
uses code like:
  container_of(dev_mapping, struct inode, i_data)
So I didn't spent much time on that approach.

Cheers
David

David Herrmann (2):
  anon_inodes: allow external inode allocations
  DRM: use anon_inode instead of delayed inode init

 drivers/gpu/drm/drm_drv.c              |  1 -
 drivers/gpu/drm/drm_fops.c             | 24 +++--------------------
 drivers/gpu/drm/drm_stub.c             | 12 +++++++++++-
 drivers/gpu/drm/i915/i915_gem.c        |  4 ++--
 drivers/gpu/drm/nouveau/nouveau_gem.c  |  2 +-
 drivers/gpu/drm/omapdrm/omap_gem.c     |  7 ++++---
 drivers/gpu/drm/qxl/qxl_object.c       |  2 +-
 drivers/gpu/drm/qxl/qxl_ttm.c          |  2 +-
 drivers/gpu/drm/radeon/radeon_object.c |  2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c    |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c    |  2 +-
 fs/anon_inodes.c                       | 36 +++++++++++++++++++++++++++-------
 include/drm/drmP.h                     |  2 +-
 include/linux/anon_inodes.h            |  1 +
 14 files changed, 57 insertions(+), 42 deletions(-)

-- 
1.8.3.2

