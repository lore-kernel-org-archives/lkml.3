Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaFWBdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:33:43 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39797 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbaFWBdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:33:05 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Patrick Farrell <paf@cray.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 16/18] staging/lustre/vvp: release mmap_sem in error case
Date: Sun, 22 Jun 2014 21:32:20 -0400
Message-Id: <1403487142-4880-17-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Farrell <paf@cray.com>

The mmap_sem is downed in vvp_mmap_locks, but in case of
error from cl_io_lock_alloc_add, it is not upped.

Credit to Paul Casella at Cray for finding this.

Signed-off-by: Patrick Farrell <paf@cray.com>
Reviewed-on: http://review.whamcloud.com/10741
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-5221
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/vvp_io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index 0e0b404..04230ed 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -269,8 +269,10 @@ static int vvp_mmap_locks(const struct lu_env *env,
 			       descr->cld_mode, descr->cld_start,
 			       descr->cld_end);
 
-			if (result < 0)
+			if (result < 0) {
+				up_read(&mm->mmap_sem);
 				return result;
+			}
 
 			if (vma->vm_end - addr >= count)
 				break;
-- 
1.9.0

