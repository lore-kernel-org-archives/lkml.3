Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab3JJPua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:50:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53036 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590Ab3JJPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 032/104] cciss: fix info leak in cciss_ioctl32_passthru()
Date: Thu, 10 Oct 2013 08:41:20 -0700
Message-Id: <1381419752-29733-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 58f09e00ae095e46ef9edfcf3a5fd9ccdfad065e upstream.

The arg64 struct has a hole after ->buf_size which isn't cleared.  Or if
any of the calls to copy_from_user() fail then that would cause an
information leak as well.

This was assigned CVE-2013-2147.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/cciss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d18b801..4b82bb4 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1184,6 +1184,7 @@ static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |=
 	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
-- 
1.8.1.2

