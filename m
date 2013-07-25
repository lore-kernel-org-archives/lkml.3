Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab3GYSwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:52:37 -0400
Received: from mail-ye0-f179.google.com ([209.85.213.179]:42857 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab3GYSwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:52:36 -0400
From: Tom Rini <trini@ti.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Jianpeng Ma <majianpeng@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <greg@kroah.com>
Subject: [PATCH v2] numa: Mark __node_set as __always_inline
Date: Thu, 25 Jul 2013 14:26:10 -0400
Message-Id: <1374776770-32361-1-git-send-email-trini@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is posible for some compilers to decide that __node_set does not need
to be made turned into an inline function.  When the compiler does this
on an __init function calling it on __initdata we get a section mismatch
warning now.  Use __always_inline to ensure that we will be inlined.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Jianpeng Ma <majianpeng@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Tom Rini <trini@ti.com>

---
Changes in v2:
- As per KOSAKI Motohiro, add a comment as well about why we need
  __always_inline to the header.
---
 include/linux/nodemask.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 4e2cbfa..58b9a02 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -98,8 +98,17 @@
 typedef struct { DECLARE_BITMAP(bits, MAX_NUMNODES); } nodemask_t;
 extern nodemask_t _unused_nodemask_arg_;
 
+/*
+ * The inline keyword gives the compiler room to decide to inline, or
+ * not inline a function as it sees best.  However, as these functions
+ * are called in both __init and non-__init functions, if they are not
+ * inlined we will end up with a section mis-match error (of the type of
+ * freeable items not being freed).  So we must use __always_inline here
+ * to fix the problem.  If other functions in the future also end up in
+ * this situation they will also need to be annotated as __always_inline
+ */
 #define node_set(node, dst) __node_set((node), &(dst))
-static inline void __node_set(int node, volatile nodemask_t *dstp)
+static __always_inline void __node_set(int node, volatile nodemask_t *dstp)
 {
 	set_bit(node, dstp->bits);
 }
-- 
1.7.9.5

