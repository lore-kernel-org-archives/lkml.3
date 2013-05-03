Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763745Ab3ECXAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 19:00:49 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:34018 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab3ECXAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 19:00:46 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/7] Clean up write-combining MTRR addition
Date: Fri,  3 May 2013 16:00:28 -0700
Message-Id: <cover.1367621038.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fair number of drivers (mostly graphics) add write-combining MTRRs.
Most ignore errors and most add the MTRR even on PAT systems which don't
need to use MTRRs.

This series adds new functions mtrr_{add,del}_wc_if_needed and
drm_mtrr_{add,del}_wc that report errors and do nothing if PAT is
enabled.

I've only tested the radeon driver, since I don't have test hardware
easily available for the other drivers.

Benefits include:
 - Simpler code
 - No more complaints about MTRR conflict warnings on PAT systems
 - Eventual unexporting of the MTRR API?

This series eliminates about half of the mtrr_add calls in drivers/.

The series is also at:
https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=mtrr_cleanup

Andy Lutomirski (7):
  x86: Add mtrr_{add,del}_wc_if_needed
  drm (ast,cirrus,mgag200,nouveau,savage,vmwgfx): Rework
    drm_mtrr_{add,del}
  drm: Update drm_addmap and drm_mmap to use PAT WC instead of MTRRs
  drm: Use drm_mtrr_add_wc for the AGP aperture
  i915: Use drm_mtrr_{add,del}_wc
  radeon: Switch to drm_mtrr_add_wc and add a missing drm_mtrr_del_wc
  uvesafb: Clean up MTRR code

 Documentation/fb/uvesafb.txt           | 16 +++-----
 arch/x86/include/asm/mtrr.h            | 21 ++++++++++
 arch/x86/kernel/cpu/mtrr/main.c        | 53 +++++++++++++++++++++++++
 drivers/gpu/drm/ast/ast_ttm.c          | 14 ++-----
 drivers/gpu/drm/cirrus/cirrus_ttm.c    | 15 ++------
 drivers/gpu/drm/drm_bufs.c             | 11 ++----
 drivers/gpu/drm/drm_pci.c              |  8 ++--
 drivers/gpu/drm/drm_stub.c             | 10 +----
 drivers/gpu/drm/drm_vm.c               | 13 ++++---
 drivers/gpu/drm/i915/i915_dma.c        | 43 +++------------------
 drivers/gpu/drm/mgag200/mgag200_ttm.c  | 14 ++-----
 drivers/gpu/drm/nouveau/nouveau_ttm.c  | 13 ++-----
 drivers/gpu/drm/radeon/radeon_object.c |  5 ++-
 drivers/gpu/drm/savage/savage_bci.c    | 42 ++++++++------------
 drivers/gpu/drm/savage/savage_drv.h    |  5 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c    | 10 ++---
 drivers/video/uvesafb.c                | 70 +++++++++-------------------------
 include/drm/drmP.h                     | 23 +++++------
 include/video/uvesafb.h                |  1 +
 19 files changed, 169 insertions(+), 218 deletions(-)

-- 
1.8.1.4

