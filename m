Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaKYKmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:42:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58668 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaKYKmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Genoud <richard.genoud@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 133/254] UBI: add missing kmem_cache_free() in process_pool_aeb error path
Date: Tue, 25 Nov 2014 10:38:03 +0000
Message-Id: <1416912004-5928-134-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Genoud <richard.genoud@gmail.com>

commit 1bf1890e86869032099b539bc83b098be12fc5a7 upstream.

I ran into this error after a ubiupdatevol, because I forgot to backport
e9110361a9a4 UBI: fix the volumes tree sorting criteria.

UBI error: process_pool_aeb: orphaned volume in fastmap pool
UBI error: ubi_scan_fastmap: Attach by fastmap failed, doing a full scan!
kmem_cache_destroy ubi_ainf_peb_slab: Slab cache still has objects
CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.18-00053-gf05cac8dbf85 #1
[<c000d298>] (unwind_backtrace) from [<c000baa8>] (show_stack+0x10/0x14)
[<c000baa8>] (show_stack) from [<c01b7a68>] (destroy_ai+0x230/0x244)
[<c01b7a68>] (destroy_ai) from [<c01b8fd4>] (ubi_attach+0x98/0x1ec)
[<c01b8fd4>] (ubi_attach) from [<c01ade90>] (ubi_attach_mtd_dev+0x2b8/0x868)
[<c01ade90>] (ubi_attach_mtd_dev) from [<c038b510>] (ubi_init+0x1dc/0x2ac)
[<c038b510>] (ubi_init) from [<c0008860>] (do_one_initcall+0x94/0x140)
[<c0008860>] (do_one_initcall) from [<c037aadc>] (kernel_init_freeable+0xe8/0x1b0)
[<c037aadc>] (kernel_init_freeable) from [<c02730ac>] (kernel_init+0x8/0xe4)
[<c02730ac>] (kernel_init) from [<c00093f0>] (ret_from_fork+0x14/0x24)
UBI: scanning is finished

Freeing the cache in the error path fixes the Slab error.

Tested on at91sam9g35 (3.14.18+fastmap backports)

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mtd/ubi/fastmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 0431b46d9fd9..c701369090fb 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -330,6 +330,7 @@ static int process_pool_aeb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		av = tmp_av;
 	else {
 		ubi_err("orphaned volume in fastmap pool!");
+		kmem_cache_free(ai->aeb_slab_cache, new_aeb);
 		return UBI_BAD_FASTMAP;
 	}
 
-- 
2.1.0

