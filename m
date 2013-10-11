Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab3JKKm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:42:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58446 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719Ab3JKKmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Weng Meiling <wengmeiling.weng@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 025/100] cgroup: fail if monitored file and event_control are in different cgroup
Date: Fri, 11 Oct 2013 11:40:55 +0100
Message-Id: <1381488130-30235-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit f169007b2773f285e098cb84c74aac0154d65ff7 upstream.

If we pass fd of memory.usage_in_bytes of cgroup A to cgroup.event_control
of cgroup B, then we won't get memory usage notification from A but B!

What's worse, if A and B are in different mount hierarchy, we'll end up
accessing NULL pointer!

Disallow this kind of invalid usage.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/cgroup.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3b3fa5b..7720f52 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3712,6 +3712,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 				      const char *buffer)
 {
 	struct cgroup_event *event = NULL;
+	struct cgroup *cgrp_cfile;
 	unsigned int efd, cfd;
 	struct file *efile = NULL;
 	struct file *cfile = NULL;
@@ -3767,6 +3768,16 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 		goto fail;
 	}
 
+	/*
+	 * The file to be monitored must be in the same cgroup as
+	 * cgroup.event_control is.
+	 */
+	cgrp_cfile = __d_cgrp(cfile->f_dentry->d_parent);
+	if (cgrp_cfile != cgrp) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
 	if (!event->cft->register_event || !event->cft->unregister_event) {
 		ret = -EINVAL;
 		goto fail;
-- 
1.8.3.2

