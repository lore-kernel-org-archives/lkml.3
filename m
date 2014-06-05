Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaFEE5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:57:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaFEEUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 085/214] VFS: make vfs_fstat() use f[get|put]_light()
Date: Wed,  4 Jun 2014 21:17:28 -0700
Message-Id: <20140605041651.016653955@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit e994defb7b6813ba6fa7a2a36e86d2455ad1dc35 upstream.

Use the *_light() versions that properly avoid doing the file user count
updates when they are unnecessary.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[xr: Backported to 3.4: adjust function name]
Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/stat.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/stat.c
+++ b/fs/stat.c
@@ -57,12 +57,13 @@ EXPORT_SYMBOL(vfs_getattr);
 
 int vfs_fstat(unsigned int fd, struct kstat *stat)
 {
-	struct file *f = fget_raw(fd);
+	int fput_needed;
+	struct file *f = fget_light(fd, &fput_needed);
 	int error = -EBADF;
 
 	if (f) {
 		error = vfs_getattr(f->f_path.mnt, f->f_path.dentry, stat);
-		fput(f);
+		fput_light(f, fput_needed);
 	}
 	return error;
 }


