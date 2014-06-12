Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaFLNAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:00:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46703 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaFLNAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:00:20 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: fs/stat: Reduce memory requirements for stat_open
Date: Thu, 12 Jun 2014 15:00:17 +0200
Message-Id: <1402578017-16637-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading from /proc/stat we allocate a large buffer to maximise
the chances of the results being from a single run and thus internally
consistent.  This currently is sized at 128 * num_possible_cpus() which,
in the face of kernels sized to handle large configurations (256 cpus
plus), results in the buffer being an order-4 allocation or more.
When system memory becomes fragmented these cannot be guarenteed, leading
to read failures due to allocation failures.

There seem to be two issues in play here.  Firstly the allocation is
going to be vastly over sized in the common case, as we only consume the
buffer based on the num_online_cpus().  Secondly, regardless of size we
should not be requiring allocations greater than PAGE_ALLOC_COSTLY_ORDER
as allocations above this order are significantly more likely to fail.

The following patch addesses both of these issues.  Does that make sense
generally? It seemed to stop top complaining wildly for the reporter
at least.

-Stefan

---

>From a329ad61fbd26990b294f3b35a31ec80ffab35bb Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Wed, 14 May 2014 12:58:37 +0200
Subject: [PATCH] fs/stat: Reduce memory requirements for stat_open

When reading /proc/stat the stat_open function currently sizes its
internal buffer at:

  1024 + 128 * num_possible_cpus() + 2 * num_irqs

This is to maximise the chances of the results as returned to userspace
be a single internally consistent result.  With CONFIG_NR_CPUS sized
for larger configs this buffer balloons rapidly, at 256 cpus we end
up at least 33kB which translates into an order-4 allocation (64kB).
This triggered random errors in top when reading /proc/stat due to
memory allocation failures.

In reality the buffer is only consumed in proportion to the
num_online_cpus(), so in the common case it makes much more sense to
allocate the buffer size based on that.  Secondly, regardless of size we
should not be requiring allocations greater than PAGE_ALLOC_COSTLY_ORDER
as allocations above this order are significantly more likely to fail.

As the code already bounds the buffer size based on the maximum kmem_alloc
allocation size, we are already relying on the seq_file buffering when
this is exceeded.  This will also protect us from overflowing should cpus
come online mid read.

We do not attempt to fix potential inconsistancies that this existing
use of this buffering introduces.

BugLink: http://bugs.launchpad.net/bugs/1319244
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>

---
 fs/proc/stat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 9d231e9..9498cf7 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -184,7 +184,7 @@ static int show_stat(struct seq_file *p, void *v)
 
 static int stat_open(struct inode *inode, struct file *file)
 {
-	size_t size = 1024 + 128 * num_possible_cpus();
+	size_t size = 1024 + 128 * num_online_cpus();
 	char *buf;
 	struct seq_file *m;
 	int res;
@@ -193,8 +193,8 @@ static int stat_open(struct inode *inode, struct file *file)
 	size += 2 * nr_irqs;
 
 	/* don't ask for more than the kmalloc() max size */
-	if (size > KMALLOC_MAX_SIZE)
-		size = KMALLOC_MAX_SIZE;
+	if (size > (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
+		size = PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER;
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-- 
1.7.9.5

