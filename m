Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaI0FgA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 01:36:00 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41577 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaI0Ff5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 01:35:57 -0400
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] Return a value from printk_ratelimited
Date: Fri, 26 Sep 2014 22:36:48 -0700
Message-Id: <a4437b89bc5684ea1d6f978039bd255d1f5b26f9.1411796033.git.osandov@osandov.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <cover.1411796033.git.osandov@osandov.com>
References: <cover.1411796033.git.osandov@osandov.com>
In-Reply-To: <cover.1411796033.git.osandov@osandov.com>
References: <cover.1411796033.git.osandov@osandov.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk returns an integer; there's no reason for printk_ratelimited to swallow
it.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/printk.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index d78125f..89bb7ab 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -343,12 +343,14 @@ extern asmlinkage void dump_stack(void) __cold;
 #ifdef CONFIG_PRINTK
 #define printk_ratelimited(fmt, ...)					\
 ({									\
+	int __ret_printk_ratelimited = 0;				\
 	static DEFINE_RATELIMIT_STATE(_rs,				\
 				      DEFAULT_RATELIMIT_INTERVAL,	\
 				      DEFAULT_RATELIMIT_BURST);		\
 									\
 	if (__ratelimit(&_rs))						\
-		printk(fmt, ##__VA_ARGS__);				\
+		__ret_printk_ratelimited = printk(fmt, ##__VA_ARGS__);	\
+	__ret_printk_ratelimited;					\
 })
 #else
 #define printk_ratelimited(fmt, ...)					\
-- 
2.1.1

