Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab3GZUFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:05:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3GZUFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:05:35 -0400
Date: Fri, 26 Jul 2013 13:04:00 -0700
From: tip-bot for Tom Rini <tipbot@zytor.com>
Message-ID: <tip-323f54ed0f3ce20e9946c961fc928ccdb80d9345@git.kernel.org>
Cc: mingo@kernel.org, rusty@rustcorp.com.au, pebolle@tiscali.nl,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        tglx@linutronix.de, rientjes@google.com, trini@ti.com,
        laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        majianpeng@gmail.com, yinghai@kernel.org, greg@kroah.com,
        wency@cn.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        kosaki.motohiro@jp.fujitsu.com
Reply-To: mingo@kernel.org, rusty@rustcorp.com.au, pebolle@tiscali.nl,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        tglx@linutronix.de, laijs@cn.fujitsu.com, rientjes@google.com,
        trini@ti.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        majianpeng@gmail.com, yinghai@kernel.org, greg@kroah.com,
        wency@cn.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <1374776770-32361-1-git-send-email-trini@ti.com>
References: <1374776770-32361-1-git-send-email-trini@ti.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] numa: Mark __node_set() as __always_inline
Git-Commit-ID: 323f54ed0f3ce20e9946c961fc928ccdb80d9345
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 26 Jul 2013 13:04:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  323f54ed0f3ce20e9946c961fc928ccdb80d9345
Gitweb:     http://git.kernel.org/tip/323f54ed0f3ce20e9946c961fc928ccdb80d9345
Author:     Tom Rini <trini@ti.com>
AuthorDate: Thu, 25 Jul 2013 14:26:10 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 25 Jul 2013 21:54:01 +0200

numa: Mark __node_set() as __always_inline

It is posible for some compilers to decide that __node_set() does
not need to be made turned into an inline function.  When the
compiler does this on an __init function calling it on
__initdata we get a section mismatch warning now.  Use
__always_inline to ensure that we will be inlined.

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
Link: http://lkml.kernel.org/r/1374776770-32361-1-git-send-email-trini@ti.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/nodemask.h | 11 ++++++++++-
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
