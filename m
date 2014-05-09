Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbaEIVcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:32:03 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:36917 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaEIVb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:31:59 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/14] cgroup: implement css_tryget()
Date: Fri,  9 May 2014 17:31:31 -0400
Message-Id: <1399671091-23867-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement css_tryget() which tries to grab a cgroup_subsys_state's
reference as long as it already hasn't reached zero.  Combined with
the recent css iterator changes to include offline && !released csses
during traversal, this can be used to access csses regardless of its
online state.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/cgroup.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c8eb66e..6dd3867 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -111,6 +111,22 @@ static inline void css_get(struct cgroup_subsys_state *css)
 }
 
 /**
+ * css_tryget - try to obtain a reference on the specified css
+ * @css: target css
+ *
+ * Obtain a reference on @css unless it already has reached zero and is
+ * being released.  This function doesn't care whether @css is on or
+ * offline.  The caller naturally needs to ensure that @css is accessible
+ * but doesn't have to be holding a reference on it - IOW, RCU protected
+ * access is good enough for this function.  Returns %true if a reference
+ * count was successfully obtained; %false otherwise.
+ */
+static inline bool css_tryget(struct cgroup_subsys_state *css)
+{
+	return percpu_ref_tryget(&css->refcnt);
+}
+
+/**
  * css_tryget_online - try to obtain a reference on the specified css if online
  * @css: target css
  *
-- 
1.9.0

