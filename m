Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbaFPJFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:05:09 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:46109 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaFPJFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:05:03 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Ian Kent <raven@themaw.net>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 1/2] proc/stat: convert to single_open_size()
Date: Mon, 16 Jun 2014 11:04:51 +0200
Message-Id: <1402909492-36486-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061609-8372-0000-0000-000000363C1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use seq_file's single_open_size() to preallocate a buffer that is large
enough to hold the whole output, instead of open coding it.
Also calculate the requested size using the number of online cpus instead
of possible cpus, since the size of the output only depends on the number
of online cpus.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/proc/stat.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 9d231e9e5f0e..bf2d03f8fd3e 100644
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
1.8.5.5

