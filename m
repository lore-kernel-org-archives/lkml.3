Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaJAU66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:58:58 -0400
Received: from mail.ispras.ru ([83.149.199.45]:36928 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaJAU64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:58:56 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, dm-devel@redhat.com,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] dm-log-userspace: fix memory leak on failure path in dm_ulog_tfr_init()
Date: Wed,  1 Oct 2014 22:58:35 +0200
Message-Id: <1412197115-32593-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If cn_add_callback() fails in dm_ulog_tfr_init(), it does not
deallocate prealloced memory but calls cn_del_callback().
It looks like a misprint.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/md/dm-log-userspace-transfer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index b428c0ae63d5..39ad9664d397 100644
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

