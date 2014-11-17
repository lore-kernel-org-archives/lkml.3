Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaKQU5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:57:40 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:33849 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaKQU5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:57:38 -0500
Date: Mon, 17 Nov 2014 15:57:34 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3 cgroup/for-3.19] cgroup: add
 cgroup_subsys->css_e_css_changed()
Message-ID: <20141117205734.GB23126@htj.dyndns.org>
References: <20141117205652.GA23126@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117205652.GA23126@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new cgroup_subsys operatoin ->css_e_css_changed().  This is
invoked if any of the effective csses seen from the css's cgroup may
have changed.  This will be used to implement cgroup writeback
support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -615,6 +615,7 @@ struct cgroup_subsys {
 	void (*css_released)(struct cgroup_subsys_state *css);
 	void (*css_free)(struct cgroup_subsys_state *css);
 	void (*css_reset)(struct cgroup_subsys_state *css);
+	void (*css_e_css_changed)(struct cgroup_subsys_state *css);
 
 	int (*can_attach)(struct cgroup_subsys_state *css,
 			  struct cgroup_taskset *tset);
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2836,6 +2836,24 @@ static ssize_t cgroup_subtree_control_wr
 		}
 	}
 
+	/*
+	 * The effective csses of all the descendants (excluding @cgrp) may
+	 * have changed.  Subsystems can optionally subscribe to this event
+	 * by implementing ->css_e_css_changed() which is invoked if any of
+	 * the effective csses seen from the css's cgroup may have changed.
+	 */
+	for_each_subsys(ss, ssid) {
+		struct cgroup_subsys_state *this_css = cgroup_css(cgrp, ss);
+		struct cgroup_subsys_state *css;
+
+		if (!ss->css_e_css_changed || !this_css)
+			continue;
+
+		css_for_each_descendant_pre(css, this_css)
+			if (css != this_css)
+				ss->css_e_css_changed(css);
+	}
+
 	kernfs_activate(cgrp->kn);
 	ret = 0;
 out_unlock:
