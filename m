Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3CBD0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:26:24 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45999 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab3CBDZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:25:17 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 29/31] cpumask: implement cpumask_parse()
Date: Fri,  1 Mar 2013 19:24:20 -0800
Message-Id: <1362194662-2344-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have cpulist_parse() but not cpumask_parse().  Implement it using
bitmap_parse().

bitmap_parse() is weird in that it takes @len for a string in
kernel-memory which also is inconsistent with bitmap_parselist().
Make cpumask_parse() calculate the length and don't expose the
inconsistency to cpumask users.  Maybe we can fix up bitmap_parse()
later.

This will be used to expose workqueue cpumask knobs to userland via
sysfs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
Rusty, if this looks okay to you, would it be okay for me to route it
together with the rest of workqueue changes?

Thanks.

 include/linux/cpumask.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 0325602..d08e4d2 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -591,6 +591,21 @@ static inline int cpulist_scnprintf(char *buf, int len,
 }
 
 /**
+ * cpumask_parse - extract a cpumask from from a string
+ * @buf: the buffer to extract from
+ * @dstp: the cpumask to set.
+ *
+ * Returns -errno, or 0 for success.
+ */
+static inline int cpumask_parse(const char *buf, struct cpumask *dstp)
+{
+	char *nl = strchr(buf, '\n');
+	int len = nl ? nl - buf : strlen(buf);
+
+	return bitmap_parse(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
+}
+
+/**
  * cpulist_parse - extract a cpumask from a user string of ranges
  * @buf: the buffer to extract from
  * @dstp: the cpumask to set.
-- 
1.8.1.2

