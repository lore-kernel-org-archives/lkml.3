Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab3I2UII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:08:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3I2T1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, Tejun Heo <tj@kernel.org>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [ 11/17] cgroup: fail if monitored file and event_control are in different cgroup
Date: Sun, 29 Sep 2013 12:26:50 -0700
Message-Id: <20130929190757.915037902@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929190757.138351117@linuxfoundation.org>
References: <20130929190757.138351117@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3498,6 +3498,7 @@ static int cgroup_write_event_control(st
 				      const char *buffer)
 {
 	struct cgroup_event *event = NULL;
+	struct cgroup *cgrp_cfile;
 	unsigned int efd, cfd;
 	struct file *efile = NULL;
 	struct file *cfile = NULL;
@@ -3552,6 +3553,16 @@ static int cgroup_write_event_control(st
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


