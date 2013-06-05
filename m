Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325Ab3FEVur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:50:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960Ab3FEVfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ivan Bulatovic <combuster@archlinux.us>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [ 080/127] cgroup: initialize xattr before calling d_instantiate()
Date: Wed,  5 Jun 2013 14:34:07 -0700
Message-Id: <20130605213227.041292220@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit d6cbf35dac8a3dadb9103379820c96d7c85df3d9 upstream.

cgroup_create_file() calls d_instantiate(), which may decide to look
at the xattrs on the file. Smack always does this and SELinux can be
configured to do so.

But cgroup_add_file() didn't initialize xattrs before calling
cgroup_create_file(), which finally leads to dereferencing NULL
dentry->d_fsdata.

This bug has been there since cgroup xattr was introduced.

Reported-by: Ivan Bulatovic <combuster@archlinux.us>
Reported-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2747,13 +2747,14 @@ static int cgroup_add_file(struct cgroup
 		goto out;
 	}
 
+	cfe->type = (void *)cft;
+	cfe->dentry = dentry;
+	dentry->d_fsdata = cfe;
+	simple_xattrs_init(&cfe->xattrs);
+
 	mode = cgroup_file_mode(cft);
 	error = cgroup_create_file(dentry, mode | S_IFREG, cgrp->root->sb);
 	if (!error) {
-		cfe->type = (void *)cft;
-		cfe->dentry = dentry;
-		dentry->d_fsdata = cfe;
-		simple_xattrs_init(&cfe->xattrs);
 		list_add_tail(&cfe->node, &parent->files);
 		cfe = NULL;
 	}


