Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3CNKmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:42:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52091 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab3CNKiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 80/88] vfs: fix pipe counter breakage
Date: Thu, 14 Mar 2013 10:36:13 +0000
Message-Id: <1363257381-15900-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit a930d8790552658140d7d0d2e316af4f0d76a512 upstream.

If you open a pipe for neither read nor write, the pipe code will not
add any usage counters to the pipe, causing the 'struct pipe_inode_info"
to be potentially released early.

That doesn't normally matter, since you cannot actually use the pipe,
but the pipe release code - particularly fasync handling - still expects
the actual pipe infrastructure to all be there.  And rather than adding
NULL pointer checks, let's just disallow this case, the same way we
already do for the named pipe ("fifo") case.

This is ancient going back to pre-2.4 days, and until trinity, nobody
naver noticed.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/pipe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/pipe.c b/fs/pipe.c
index 49c1065..b342faa 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -863,6 +863,9 @@ pipe_rdwr_open(struct inode *inode, struct file *filp)
 {
 	int ret = -ENOENT;
 
+	if (!(filp->f_mode & (FMODE_READ|FMODE_WRITE)))
+		return -EINVAL;
+
 	mutex_lock(&inode->i_mutex);
 
 	if (inode->i_pipe) {
-- 
1.8.1.2

