Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaJ0TDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:03:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52768 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaJ0TDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mike Snitzer <snitzer@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 076/105] dm log userspace: fix memory leak in dm_ulog_tfr_init failure path
Date: Mon, 27 Oct 2014 11:56:51 -0700
Message-Id: <1414436240-13879-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit 56ec16cb1e1ce46354de8511eef962a417c32c92 upstream.

If cn_add_callback() fails in dm_ulog_tfr_init(), it does not
deallocate prealloced memory but calls cn_del_callback().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-log-userspace-transfer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 08d9a20..c69d0b7 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -272,7 +272,7 @@ int dm_ulog_tfr_init(void)
 
 	r = cn_add_callback(&ulog_cn_id, "dmlogusr", cn_ulog_callback);
 	if (r) {
-		cn_del_callback(&ulog_cn_id);
+		kfree(prealloced_cn_msg);
 		return r;
 	}
 
-- 
1.9.1

