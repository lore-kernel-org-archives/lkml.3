Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3LTHqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:46:23 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63928 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab3LTHqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:46:21 -0500
From: Wenliang Fan <fanwlexca@gmail.com>
To: konishi.ryusuke@lab.ntt.co.jp
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenliang Fan <fanwlexca@gmail.com>
Subject: [PATCH] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Fri, 20 Dec 2013 15:46:08 +0800
Message-Id: <1387525568-30025-1-git-send-email-fanwlexca@gmail.com>
X-Mailer: git-send-email 1.8.5.rc1.28.g7061504
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The local variable 'pos' comes from userspace. If a large number was
passed, there would be an integer overflow in the following line:
	pos += n;

Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
---
 fs/nilfs2/ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b44bdb2..b2bac9a 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -90,8 +90,13 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 		total += nr;
 		if ((size_t)nr < n)
 			break;
-		if (pos == ppos)
+		if (pos == ppos) {
+			if (pos > ULONG_MAX - n) {
+				ret = -EINVAL;
+				break;
+			}
 			pos += n;
+		}
 	}
 	argv->v_nmembs = total;
 
-- 
1.8.5.rc1.28.g7061504

