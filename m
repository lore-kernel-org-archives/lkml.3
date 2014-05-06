Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaEFUmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:42:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40856 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbaEFUmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:42:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Daley <mattd@bugfuzz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 3/3] floppy: don't write kernel-only members to FDRAWCMD ioctl output
Date: Tue,  6 May 2014 13:42:20 -0700
Message-Id: <1399408940-22784-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399408940-22784-1-git-send-email-kamal@canonical.com>
References: <1399408940-22784-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Daley <mattd@bugfuzz.com>

commit 2145e15e0557a01b9195d1c7199a1b92cb9be81f upstream.

Do not leak kernel-only floppy_raw_cmd structure members to userspace.
This includes the linked-list pointer and the pointer to the allocated
DMA space.

Signed-off-by: Matthew Daley <mattd@bugfuzz.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
References: CVE-2014-1738
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/floppy.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 10fbd3f..738af94 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3053,7 +3053,10 @@ static int raw_cmd_copyout(int cmd, void __user *param,
 	int ret;
 
 	while (ptr) {
-		ret = copy_to_user(param, ptr, sizeof(*ptr));
+		struct floppy_raw_cmd cmd = *ptr;
+		cmd.next = NULL;
+		cmd.kernel_data = NULL;
+		ret = copy_to_user(param, &cmd, sizeof(cmd));
 		if (ret)
 			return -EFAULT;
 		param += sizeof(struct floppy_raw_cmd);
-- 
1.9.1

