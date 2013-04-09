Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936772Ab3DIBzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:55:17 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60854 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933403Ab3DIBzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:55:15 -0400
Date: Mon, 8 Apr 2013 18:55:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch] fs, proc: truncate /proc/pid/comm writes to first TASK_COMM_LEN
 bytes
Message-ID: <alpine.DEB.2.02.1304081854440.22640@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a write to /proc/pid/write will return the number of bytes
successfully written.  If the actual string is greater than this, the
remainder of the string will normally be written.

This results in things such as 

	$ echo -n "abcdefghijklmnopqrs" > /proc/self/comm

to result in

	$ cat /proc/$$/comm
	pqrs

since the final four bytes were written with a second write() since
TASK_COMM_LEN == 16.  This is obviously an undesired result and not
equivalent to prctl(PR_SET_NAME).  The implementation should not need to
know the definition of TASK_COMM_LEN.

This patch truncates the string to the first TASK_COMM_LEN bytes and
returns the bytes written as the length of the string written so the
second write() is suppressed.

	$ cat /proc/$$/comm
	abcdefghijklmno

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/proc/base.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1347,11 +1347,10 @@ static ssize_t comm_write(struct file *file, const char __user *buf,
 	struct inode *inode = file_inode(file);
 	struct task_struct *p;
 	char buffer[TASK_COMM_LEN];
+	const size_t maxlen = sizeof(buffer) - 1;
 
 	memset(buffer, 0, sizeof(buffer));
-	if (count > sizeof(buffer) - 1)
-		count = sizeof(buffer) - 1;
-	if (copy_from_user(buffer, buf, count))
+	if (copy_from_user(buffer, buf, count > maxlen ? maxlen : count))
 		return -EFAULT;
 
 	p = get_proc_task(inode);
