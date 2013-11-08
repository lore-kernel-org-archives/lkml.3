Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab3KHCR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:17:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34579 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab3KHCQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 83/91] uml: check length in exitcode_proc_write()
Date: Thu,  7 Nov 2013 18:15:38 -0800
Message-Id: <1383876946-2396-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 201f99f170df14ba52ea4c52847779042b7a623b upstream.

We don't cap the size of buffer from the user so we could write past the
end of the array here.  Only root can write to this file.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/um/kernel/exitcode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/exitcode.c b/arch/um/kernel/exitcode.c
index 829df49..41ebbfe 100644
--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -40,9 +40,11 @@ static ssize_t exitcode_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *pos)
 {
 	char *end, buf[sizeof("nnnnn\0")];
+	size_t size;
 	int tmp;
 
-	if (copy_from_user(buf, buffer, count))
+	size = min(count, sizeof(buf));
+	if (copy_from_user(buf, buffer, size))
 		return -EFAULT;
 
 	tmp = simple_strtol(buf, &end, 0);
-- 
1.8.1.2

