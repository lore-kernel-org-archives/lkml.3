Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3EMX65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:58:57 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:45030 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab3EMX64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:58:56 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 0/9] Clean up write-combining MTRR addition
Date: Mon, 13 May 2013 16:58:39 -0700
Message-Id: <cover.1368485053.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fair number of drivers (mostly graphics) add write-combining MTRRs.
Most ignore errors and most add the MTRR even on PAT systems which don't
need to use MTRRs.

This series adds new functions arch_phys_wc_{add,del} that, on PAT-less
x86 systems with MTRRs, add MTRRs and report errors, and that do nothing
otherwise.  (Other architectures, if any, with a similar mechanism could
implement them.)

I've only tested the radeon driver, since I don't have test hardware
easily available for the other drivers.

Benefits include:
 - Simpler code
 - No more complaints about MTRR conflict warnings on PAT systems
 - Eventual unexporting of the MTRR API?

This series eliminates about half of the mtrr_add calls in drivers/.

Note: this series breaks and then fixes dritests from libdrm.  The breakage
is probably irrelevant for any practical purpose, and fixing it will
be a bit complicated due to header file breakage that's only fixed in
patch 8.

Daniel, can you check that patch 1 is still okay?

Changes from v2:
 - There's a new API phys_wc_to_mtrr_index (x86-only) to support drmGetMap
 - Minor cleanups to patche 1 and 5.
 - Patch 9 is new

Changes from v1:
 - Helpers renamed
 - Lots of bugs fixed

Andy Lutomirski (9):
  Add arch_phys_wc_{add,del} to manipulate WC MTRRs if needed
  drm (ast,cirrus,mgag200,nouveau,savage,vmwgfx): Remove
    drm_mtrr_{add,del}
  drm: Update drm_addmap and drm_mmap to use PAT WC instead of MTRRs
  drm,agpgart: Use pgprot_writecombine for AGP maps and make the MTRR
    optional
  i915: Use arch_phys_wc_{add,del}
  radeon: Switch to arch_phys_wc_add and add a missing ..._del
  uvesafb: Clean up MTRR code
  drm: Remove mtrr_add and mtrr_del fallback hack for non-MTRR systems
  drm: Don't leak phys_wc "handles" to userspace

Andy Lutomirski (9):
  Add arch_phys_wc_{add,del} to manipulate WC MTRRs if needed
  drm (ast,cirrus,mgag200,nouveau,savage,vmwgfx): Remove
    drm_mtrr_{add,del}
  drm: Update drm_addmap and drm_mmap to use PAT WC instead of MTRRs
  drm,agpgart: Use pgprot_writecombine for AGP maps and make the MTRR
    optional
  i915: Use arch_phys_wc_{add,del}
  radeon: Switch to arch_phys_wc_add and add a missing ..._del
  uvesafb: Clean up MTRR code
  drm: Remove mtrr_add and mtrr_del fallback hack for non-MTRR systems
  drm: Don't leak phys_wc "handles" to userspace

 Documentation/fb/uvesafb.txt           | 16 +++-----
 arch/x86/include/asm/io.h              |  7 ++++
 arch/x86/include/asm/mtrr.h            | 10 ++++-
 arch/x86/kernel/cpu/mtrr/main.c        | 71 ++++++++++++++++++++++++++++++++++
 drivers/char/agp/frontend.c            |  8 ++--
 drivers/gpu/drm/ast/ast_ttm.c          | 13 ++-----
 drivers/gpu/drm/cirrus/cirrus_ttm.c    | 15 ++-----
 drivers/gpu/drm/drm_bufs.c             | 26 +++++++++----
 drivers/gpu/drm/drm_ioctl.c            | 15 ++++++-
 drivers/gpu/drm/drm_pci.c              |  8 ++--
 drivers/gpu/drm/drm_stub.c             | 10 +----
 drivers/gpu/drm/drm_vm.c               | 22 +++++------
 drivers/gpu/drm/i915/i915_dma.c        | 42 ++------------------
 drivers/gpu/drm/mgag200/mgag200_ttm.c  | 14 ++-----
 drivers/gpu/drm/nouveau/nouveau_ttm.c  | 13 ++-----
 drivers/gpu/drm/radeon/radeon_object.c |  5 ++-
 drivers/gpu/drm/savage/savage_bci.c    | 43 +++++++-------------
 drivers/gpu/drm/savage/savage_drv.h    |  5 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c    | 10 ++---
 drivers/video/uvesafb.c                | 70 ++++++++-------------------------
 include/drm/drmP.h                     | 34 +---------------
 include/drm/drm_os_linux.h             | 16 --------
 include/linux/io.h                     | 25 ++++++++++++
 include/video/uvesafb.h                |  1 +
 24 files changed, 230 insertions(+), 269 deletions(-)

-- 
1.8.1.4

