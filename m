Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab3BRGNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:13:52 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:53167 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531Ab3BRGNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:13:50 -0500
Message-ID: <5121C68F.1000309@huawei.com>
Date: Mon, 18 Feb 2013 14:13:35 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cgroup: fail if monitored file and event_control are in different
 cgroup
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we pass fd of memory.usage_in_bytes of cgroup A to cgroup.event_control
of cgroup B, then we won't get memory usage notification from A but B!

What's worse, if A and B are in different mount hierarchy, we'll end up
accessing NULL pointer!

Disallow this kind of invalid usage.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 65c8101..a41673c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3911,6 +3911,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 				      const char *buffer)
 {
 	struct cgroup_event *event = NULL;
+	struct cgroup *cgrp_cfile;
 	unsigned int efd, cfd;
 	struct file *efile = NULL;
 	struct file *cfile = NULL;
@@ -3966,6 +3967,16 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
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
1.8.0.2
