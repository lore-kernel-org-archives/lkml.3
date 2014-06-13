Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaFMUDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:03:39 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51592 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaFMUDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:03:38 -0400
Date: Fri, 13 Jun 2014 23:03:38 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: faster /proc/$PID lookup
Message-ID: <20140613200338.GA2149@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use first character as a hint for /proc/$PID lookup.

Currently it takes one spinlock and search through dozens of
misc proc entries which can not match /proc/$PID.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/root.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -199,10 +199,17 @@ static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
 
 static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentry, unsigned int flags)
 {
-	if (!proc_lookup(dir, dentry, flags))
-		return NULL;
-	
-	return proc_pid_lookup(dir, dentry, flags);
+	const char c = dentry->d_name.name[0];
+	struct dentry *rv;
+
+	if ('0' <= c && c <= '9') {
+		rv = proc_pid_lookup(dir, dentry, flags);
+		if (rv)
+			rv = proc_lookup(dir, dentry, flags);
+	} else {
+		rv = proc_lookup(dir, dentry, flags);
+	}
+	return rv;
 }
 
 static int proc_root_readdir(struct file *file, struct dir_context *ctx)
