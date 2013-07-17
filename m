Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216Ab3GQXZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:25:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56290 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab3GQWup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:50:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 130/145] dm ioctl: set noio flag to avoid __vmalloc deadlock
Date: Wed, 17 Jul 2013 15:47:42 -0700
Message-Id: <1374101277-7915-131-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

Set noio flag while calling __vmalloc() because it doesn't fully respect
gfp flags to avoid a possible deadlock (see commit
502624bdad3dba45dfaacaf36b7d83e39e74b2d2).

This should be backported to stable kernels 3.8 and newer. The kernel 3.8
doesn't have memalloc_noio_save(), so we should set and restore process
flag PF_MEMALLOC instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
[ kamal: backport to 3.8 (memalloc_noio_save is available in linux-3.8.y.z) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index eee353d..4c260aa 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1585,7 +1585,10 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param, in
 		dmi = kmalloc(tmp.data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
 
 	if (!dmi) {
+		unsigned noio_flag;
+		noio_flag = memalloc_noio_save();
 		dmi = __vmalloc(tmp.data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH, PAGE_KERNEL);
+		memalloc_noio_restore(noio_flag);
 		*param_flags |= DM_PARAMS_VMALLOC;
 	}
 
-- 
1.8.1.2

