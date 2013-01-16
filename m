Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab3APQvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:51:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36068 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab3APQDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:03 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 088/222] regmap: debugfs: Avoid overflows for very small reads
Date: Wed, 16 Jan 2013 13:54:48 -0200
Message-Id: <1358351822-7675-89-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit db04328c167ff8e7c57f4a3532214aeada3a82fd upstream.

If count is less than the size of a register then we may hit integer
wraparound when trying to move backwards to check if we're still in
the buffer. Instead move the position forwards to check if it's still
in the buffer, we are unlikely to be able to allocate a buffer
sufficiently big to overflow here.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
[ herton: on 3.5, code is in regmap_map_read_file, and size in tot_len ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/base/regmap/regmap-debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index bb1ff17..c394041 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -90,7 +90,7 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 		/* If we're in the region the user is trying to read */
 		if (p >= *ppos) {
 			/* ...but not beyond it */
-			if (buf_pos >= count - 1 - tot_len)
+			if (buf_pos + 1 + tot_len >= count)
 				break;
 
 			/* Format the register */
-- 
1.7.9.5

