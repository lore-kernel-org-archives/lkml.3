Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab3LBTrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:47:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab3LBTSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.12 156/212] cgroup: fix cgroup_subsys_state leak for seq_files
Date: Mon,  2 Dec 2013 11:15:47 -0800
Message-Id: <20131202191304.947380202@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit e605b36575e896edd8161534550c9ea021b03bc0 upstream.

If a cgroup file implements either read_map() or read_seq_string(),
such file is served using seq_file by overriding file->f_op to
cgroup_seqfile_operations, which also overrides the release method to
single_release() from cgroup_file_release().

Because cgroup_file_open() didn't use to acquire any resources, this
used to be fine, but since f7d58818ba42 ("cgroup: pin
cgroup_subsys_state when opening a cgroupfs file"), cgroup_file_open()
pins the css (cgroup_subsys_state) which is put by
cgroup_file_release().  The patch forgot to update the release path
for seq_files and each open/release cycle leaks a css reference.

Fix it by updating cgroup_file_release() to also handle seq_files and
using it for seq_file release path too.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -231,6 +231,7 @@ static void cgroup_destroy_css_killed(st
 static int cgroup_destroy_locked(struct cgroup *cgrp);
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
+static int cgroup_file_release(struct inode *inode, struct file *file);
 
 /**
  * cgroup_css - obtain a cgroup's css for the specified subsystem
@@ -2471,7 +2472,7 @@ static const struct file_operations cgro
 	.read = seq_read,
 	.write = cgroup_file_write,
 	.llseek = seq_lseek,
-	.release = single_release,
+	.release = cgroup_file_release,
 };
 
 static int cgroup_file_open(struct inode *inode, struct file *file)
@@ -2532,6 +2533,8 @@ static int cgroup_file_release(struct in
 		ret = cft->release(inode, file);
 	if (css->ss)
 		css_put(css);
+	if (file->f_op == &cgroup_seqfile_operations)
+		single_release(inode, file);
 	return ret;
 }
 


