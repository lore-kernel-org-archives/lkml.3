Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935033AbaGXJ7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:59:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55100 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaGXJsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ian Kent <raven@themaw.net>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 079/128] /proc/stat: convert to single_open_size()
Date: Thu, 24 Jul 2014 10:45:28 +0100
Message-Id: <1406195177-8656-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit f74373a5cc7a0155d232c4e999648c7a95435bb2 upstream.

These two patches are supposed to "fix" failed order-4 memory
allocations which have been observed when reading /proc/stat.  The
problem has been observed on s390 as well as on x86.

To address the problem change the seq_file memory allocations to
fallback to use vmalloc, so that allocations also work if memory is
fragmented.

This approach seems to be simpler and less intrusive than changing
/proc/stat to use an interator.  Also it "fixes" other users as well,
which use seq_file's single_open() interface.

This patch (of 2):

Use seq_file's single_open_size() to preallocate a buffer that is large
enough to hold the whole output, instead of open coding it.  Also
calculate the requested size using the number of online cpus instead of
possible cpus, since the size of the output only depends on the number
of online cpus.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Ian Kent <raven@themaw.net>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Thorsten Diehl <thorsten.diehl@de.ibm.com>
Cc: Andrea Righi <andrea@betterlinux.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/proc/stat.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 1cf86c0e8689..ccc657e5ace1 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -184,29 +184,11 @@ static int show_stat(struct seq_file *p, void *v)
 
 static int stat_open(struct inode *inode, struct file *file)
 {
-	size_t size = 1024 + 128 * num_possible_cpus();
-	char *buf;
-	struct seq_file *m;
-	int res;
+	size_t size = 1024 + 128 * num_online_cpus();
 
 	/* minimum size to display an interrupt count : 2 bytes */
 	size += 2 * nr_irqs;
-
-	/* don't ask for more than the kmalloc() max size */
-	if (size > KMALLOC_MAX_SIZE)
-		size = KMALLOC_MAX_SIZE;
-	buf = kmalloc(size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	res = single_open(file, show_stat, NULL);
-	if (!res) {
-		m = file->private_data;
-		m->buf = buf;
-		m->size = ksize(buf);
-	} else
-		kfree(buf);
-	return res;
+	return single_open_size(file, show_stat, NULL, size);
 }
 
 static const struct file_operations proc_stat_operations = {
-- 
1.9.1

