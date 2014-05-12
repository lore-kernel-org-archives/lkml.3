Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaELBuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:50:37 -0400
Received: from 1wt.eu ([62.212.114.60]:34762 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbaELBn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:58 -0400
Message-Id: <20140512003206.223456550@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 133/143] uml: check length in exitcode_proc_write()
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 201f99f170df14ba52ea4c52847779042b7a623b upstream

We don't cap the size of buffer from the user so we could write past the
end of the array here.  Only root can write to this file.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/um/kernel/exitcode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/exitcode.c b/arch/um/kernel/exitcode.c
index 6540d2c..ce057af 100644
--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -42,9 +42,11 @@ static int write_proc_exitcode(struct file *file, const char __user *buffer,
 			       unsigned long count, void *data)
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
1.7.12.2.21.g234cd45.dirty



