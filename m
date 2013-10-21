Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3JUI7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:59:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39861 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754527Ab3JUIxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Li Zefan" <lizefan@huawei.com>,
        "Tejun Heo" <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.985383192@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 131/149] cgroup: fail if monitored file and
 event_control are in different cgroup
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/cgroup.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3504,6 +3504,7 @@ static int cgroup_write_event_control(st
 				      const char *buffer)
 {
 	struct cgroup_event *event = NULL;
+	struct cgroup *cgrp_cfile;
 	unsigned int efd, cfd;
 	struct file *efile = NULL;
 	struct file *cfile = NULL;
@@ -3559,6 +3560,16 @@ static int cgroup_write_event_control(st
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

