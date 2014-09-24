Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaIXPVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:21:13 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:40464 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaIXPVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:21:11 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] fs: sysfs: return EGBIG on write if offset is larger than file size
Date: Wed, 24 Sep 2014 18:21:04 +0300
Message-ID: <1411572064-2871-1-git-send-email-vladimir_zapolskiy@mentor.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the user expectations common utilities like dd or sh
redirection operator > should work correctly over binary files from
sysfs. At the moment doing excessive write can not be completed:

  write(1, "\0\0\0\0\0\0\0\0", 8)         = 4
  write(1, "\0\0\0\0", 4)                 = 0
  write(1, "\0\0\0\0", 4)                 = 0
  write(1, "\0\0\0\0", 4)                 = 0
  ...

Fix the problem by returning EFBIG described in man 2 write.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index e9ef59b..589abee 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -125,7 +125,7 @@ static ssize_t sysfs_kf_bin_write(struct kernfs_open_file *of, char *buf,
 
 	if (size) {
 		if (size <= pos)
-			return 0;
+			return -EFBIG;
 		count = min_t(ssize_t, count, size - pos);
 	}
 	if (!count)
-- 
1.7.10.4

