Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935971Ab3DIUDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:03:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765118Ab3DIUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:03:08 -0400
Date: Tue, 9 Apr 2013 13:03:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [patch] fs, proc: truncate /proc/pid/comm writes to first
 TASK_COMM_LEN bytes
Message-Id: <20130409130306.4e24a5dd1773c99eaf356db8@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1304081854440.22640@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1304081854440.22640@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> cc: John Stultz <johnstul@us.ibm.com>

I don't know if that address still works.

On Mon, 8 Apr 2013 18:55:13 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> Currently, a write to /proc/pid/write will return the number of bytes
> successfully written.  If the actual string is greater than this, the
> remainder of the string will normally be written.

The paragraph is a bit of a head-scratcher.  I did some subediting.

> This results in things such as 
> 
> 	$ echo -n "abcdefghijklmnopqrs" > /proc/self/comm
> 
> to result in
> 
> 	$ cat /proc/$$/comm
> 	pqrs

hah, that's pretty sad.

> since the final four bytes were written with a second write() since
> TASK_COMM_LEN == 16.  This is obviously an undesired result and not
> equivalent to prctl(PR_SET_NAME).  The implementation should not need to
> know the definition of TASK_COMM_LEN.
> 
> This patch truncates the string to the first TASK_COMM_LEN bytes and
> returns the bytes written as the length of the string written so the
> second write() is suppressed.
> 
> 	$ cat /proc/$$/comm
> 	abcdefghijklmno

From: David Rientjes <rientjes@google.com>
Subject: fs, proc: truncate /proc/pid/comm writes to first TASK_COMM_LEN bytes

Currently, a write to a procfs file will return the number of bytes
successfully written.  If the actual string is longer than this, the
remainder of the string will not be be written and userspace will complete
the operation by issuing additional write()s.

Hence

	$ echo -n "abcdefghijklmnopqrs" > /proc/self/comm

results in

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
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes
+++ a/fs/proc/base.c
@@ -1347,11 +1347,10 @@ static ssize_t comm_write(struct file *f
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
_

