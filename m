Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbaEPQH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:07:59 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:50570 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437AbaEPQH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:07:57 -0400
Date: Fri, 16 May 2014 12:07:53 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org
Subject: [PATCH v2 14/14] cgroup: implement css_tryget()
Message-ID: <20140516160753.GD5379@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399671091-23867-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 141fdfadf18c10fed33624bbd414fcc0cb74d7ca Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 16 May 2014 11:40:38 -0400

Implement css_tryget() which tries to grab a cgroup_subsys_state's
reference as long as it already hasn't reached zero.  Combined with
the recent css iterator changes to include offline && !released csses
during traversal, this can be used to access csses regardless of its
online state.

v2: Take the new flag CSS_NO_REF into account.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/cgroup.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b769999..4afe544 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -113,6 +113,24 @@ static inline void css_get(struct cgroup_subsys_state *css)
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
+	if (!(css->flags & CSS_NO_REF))
+		return percpu_ref_tryget(&css->refcnt);
+	return true;
+}
+
+/**
  * css_tryget_online - try to obtain a reference on the specified css if online
  * @css: target css
  *
-- 
1.9.0

