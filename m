Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaFXVxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:53:05 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54538 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaFXVxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:53:03 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: airlied@linux.ie
Cc: thellstrom@vmware.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Masaru Nomura <massa.nomura@gmail.com>
Subject: [PATCH 0/3] gpu: drm: Fix memory leak in vmwgfx_shader.c
Date: Tue, 24 Jun 2014 22:52:11 +0100
Message-Id: <1403646734-2838-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes memory leak detected by Kernel memory leak detector, 
and cleans up functions which call drm_ht_remove_item() and 
vmw_compat_shader_free() so that an unused parameter is not passed.

Part of logs from /sys/kernel/debug/kmemleak is as follows:

unreferenced object 0xffffc900086ed000 (size 32768):
  comm "plymouthd", pid 287, jiffies 4294682116 (age 5911.149s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816f7b6e>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff811b9382>] __vmalloc_node_range+0x1b2/0x2a0
    [<ffffffff811b950b>] vzalloc+0x4b/0x50
    [<ffffffffa009c7e5>] drm_ht_create+0x65/0xa0 [drm]
    [<ffffffffa011a068>] vmw_compat_shader_man_create+0x78/0xb0 [vmwgfx]
    [<ffffffffa0109ac2>] vmw_driver_open+0x62/0xa0 [vmwgfx]
    [<ffffffffa0093307>] drm_open+0x1b7/0x4c0 [drm]
    [<ffffffffa00936b5>] drm_stub_open+0xa5/0x100 [drm]
    [<ffffffff811f6c29>] chrdev_open+0xb9/0x1a0
    [<ffffffff811ef58f>] do_dentry_open+0x1ff/0x340
    [<ffffffff811ef8a1>] finish_open+0x31/0x40
    [<ffffffff812017e4>] do_last+0xa64/0x1190
    [<ffffffff81201fdd>] path_openat+0xcd/0x670
    [<ffffffff81202ddd>] do_filp_open+0x4d/0xb0
    [<ffffffff811f12fd>] do_sys_open+0x13d/0x230
    [<ffffffff811f140e>] SyS_open+0x1e/0x20
unreferenced object 0xffffc900086e4000 (size 32768):
  comm "Xorg", pid 751, jiffies 4294687683 (age 5917.505s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816f7b6e>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff811b9382>] __vmalloc_node_range+0x1b2/0x2a0
    [<ffffffff811b950b>] vzalloc+0x4b/0x50
    [<ffffffffa009c7e5>] drm_ht_create+0x65/0xa0 [drm]
    [<ffffffffa011a068>] vmw_compat_shader_man_create+0x78/0xb0 [vmwgfx]
    [<ffffffffa0109ac2>] vmw_driver_open+0x62/0xa0 [vmwgfx]
    [<ffffffffa0093307>] drm_open+0x1b7/0x4c0 [drm]
    [<ffffffffa00936b5>] drm_stub_open+0xa5/0x100 [drm]
    [<ffffffff811f6c29>] chrdev_open+0xb9/0x1a0
    [<ffffffff811ef58f>] do_dentry_open+0x1ff/0x340
    [<ffffffff811ef8a1>] finish_open+0x31/0x40
    [<ffffffff812017e4>] do_last+0xa64/0x1190
    [<ffffffff81201fdd>] path_openat+0xcd/0x670
    [<ffffffff81202ddd>] do_filp_open+0x4d/0xb0
    [<ffffffff811f12fd>] do_sys_open+0x13d/0x230
    [<ffffffff811f140e>] SyS_open+0x1e/0x20

Masaru Nomura (3):
  gpu: drm: vmwgfx: Fix memory leak by adding drm_ht_remove()
  gpu: drm: Remove unnecessary parameter from drm_ht_remove_item()
  gpu: drm: vmwgfx: Remove unnecessary parameter from
    vmw_compat_shader_free()

 drivers/gpu/drm/drm_auth.c              |  2 +-
 drivers/gpu/drm/drm_hashtab.c           |  2 +-
 drivers/gpu/drm/drm_stub.c              |  2 +-
 drivers/gpu/drm/ttm/ttm_object.c        |  8 +++-----
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |  4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c  | 16 ++++++++--------
 include/drm/drm_hashtab.h               |  2 +-
 7 files changed, 17 insertions(+), 19 deletions(-)

-- 
1.9.3

