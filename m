Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab3HMRnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:43:13 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:48539 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab3HMRnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:43:12 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v2 0/4] Anonymous Inode Allocations
Date: Tue, 13 Aug 2013 19:42:15 +0200
Message-Id: <1376415739-11685-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1373499930-5055-1-git-send-email-dh.herrmann@gmail.com>
References: <1373499930-5055-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is v2 of my anon_inodes allocation series. I would really like some
comments on #1 (and maybe #2) from VFS maintainers/developers so we can continue
with this work. Patches 1 and 2 are unchanged, I added 3 and 4 to clean up DRM
delayed initializations based on the new anon_inode.


This implements anon_inodes_new() to create anonymous inodes. Patch #1
describes the changes to anon_inodes.c and why DRM could make great use of this.
Patch #2 converts DRM core to use anon_inodes_new() instead of delayed
dev_mapping initialization. Patches #3 and #4 simplify the various driver bits
to drop unused code paths.

The idea is to get an anonymous backing inode for DRM devices without waiting
for the first char-dev inode. We use it to unmap userspace mappings via
unmap_mapping_range() if we have to evict buffers if GTT runs short or if the FW
framebuffers are destroyed.
We need the inode only once the first user-space mapping was created. But the
delayed initialization causes an ugly code base and keeps inodes of char-devs
around just to preserve the address_space.

We actually only need the address_space, but mm core requires a corresponding
file* and FS core requires mapping->host to be set (although I am not sure
whether we can hit those paths with char-devs). So I went with the whole
anonymous inode approach.

If anyone has an idea how to use an embedded "struct address_space" inside of
"drm_device" and set "dev_mapping->host" to the shared anon_inode_inode, I'd be
happy to implement it. However, I didn't succeed and I am actually not sure that
separate "struct address_space" are actually supported. For instance, DRM core
uses code like:
  container_of(dev_mapping, struct inode, i_data)
which would break in this case.

Cheers
David

David Herrmann (4):
  anon_inodes: allow external inode allocations
  DRM: use anon_inode instead of delayed inode init
  drm: init TTM dev_mapping in ttm_bo_device_init()
  drm/omap: remove useless if() in evict_entry()

 drivers/gpu/drm/ast/ast_ttm.c          |  4 +++-
 drivers/gpu/drm/cirrus/cirrus_ttm.c    |  4 +++-
 drivers/gpu/drm/drm_drv.c              |  1 -
 drivers/gpu/drm/drm_fops.c             | 24 +++--------------------
 drivers/gpu/drm/drm_stub.c             | 12 +++++++++++-
 drivers/gpu/drm/i915/i915_gem.c        |  3 ++-
 drivers/gpu/drm/mgag200/mgag200_ttm.c  |  4 +++-
 drivers/gpu/drm/nouveau/nouveau_gem.c  |  2 --
 drivers/gpu/drm/nouveau/nouveau_ttm.c  |  4 +++-
 drivers/gpu/drm/omapdrm/omap_gem.c     | 33 +++++++++++++++----------------
 drivers/gpu/drm/qxl/qxl_object.c       |  2 --
 drivers/gpu/drm/qxl/qxl_ttm.c          |  6 +++---
 drivers/gpu/drm/radeon/radeon_object.c |  1 -
 drivers/gpu/drm/radeon/radeon_ttm.c    |  5 +++--
 drivers/gpu/drm/ttm/ttm_bo.c           |  3 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c    |  5 +++--
 fs/anon_inodes.c                       | 36 +++++++++++++++++++++++++++-------
 include/drm/drmP.h                     |  2 +-
 include/drm/drm_vma_manager.h          |  6 +++---
 include/drm/ttm/ttm_bo_driver.h        |  2 ++
 include/linux/anon_inodes.h            |  1 +
 21 files changed, 91 insertions(+), 69 deletions(-)

-- 
1.8.3.4

