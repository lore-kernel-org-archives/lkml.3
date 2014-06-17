Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967389AbaFQVzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:55:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54999 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965818AbaFQVxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:53:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 141/212] sysfs: make sure read buffer is zeroed
Date: Tue, 17 Jun 2014 14:43:55 -0700
Message-Id: <1403041506-13646-142-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit f5c16f29bf5e57ba4051fc7785ba7f035f798c71 upstream.

13c589d5b0ac ("sysfs: use seq_file when reading regular files")
switched sysfs from custom read implementation to seq_file to enable
later transition to kernfs.  After the change, the buffer passed to
->show() is acquired through seq_get_buf(); unfortunately, this
introduces a subtle behavior change.  Before the commit, the buffer
passed to ->show() was always zero as it was allocated using
get_zeroed_page().  Because seq_file doesn't clear buffers on
allocation and neither does seq_get_buf(), after the commit, depending
on the behavior of ->show(), we may end up exposing uninitialized data
to userland thus possibly altering userland visible behavior and
leaking information.

Fix it by explicitly clearing the buffer.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ron <ron@debian.org>
Fixes: 13c589d5b0ac ("sysfs: use seq_file when reading regular files")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/sysfs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 35e7d08..ea3e7e2 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -94,12 +94,13 @@ static int sysfs_seq_show(struct seq_file *sf, void *v)
 	char *buf;
 	ssize_t count;
 
-	/* acquire buffer and ensure that it's >= PAGE_SIZE */
+	/* acquire buffer and ensure that it's >= PAGE_SIZE and clear */
 	count = seq_get_buf(sf, &buf);
 	if (count < PAGE_SIZE) {
 		seq_commit(sf, -1);
 		return 0;
 	}
+	memset(buf, 0, PAGE_SIZE);
 
 	/*
 	 * Need @of->sd for attr and ops, its parent for kobj.  @of->mutex
-- 
1.9.1

