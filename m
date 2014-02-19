Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaBSTxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:53:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:63589 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaBSTxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:53:36 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Dipankar Sarma <dipankar@in.ibm.com>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH v2] rcu: ensure kernel/rcu/rcu.h can be sourced/used stand-alone
Date: Wed, 19 Feb 2014 14:33:27 -0500
Message-ID: <1392838407-29704-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <Message-ID: <20140219185850.GA23050@linux.vnet.ibm.com>
References: <Message-ID: <20140219185850.GA23050@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kbuild test bot uncovered an implicit dependence on the
trace header being present before rcu.h in ia64 allmodconfig
that looks like this:

In file included from kernel/ksysfs.c:22:0:
kernel/rcu/rcu.h: In function '__rcu_reclaim':
kernel/rcu/rcu.h:107:3: error: implicit declaration of function 'trace_rcu_invoke_kfree_callback' [-Werror=implicit-function-declaration]
kernel/rcu/rcu.h:112:3: error: implicit declaration of function 'trace_rcu_invoke_callback' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

Looking at other rcu.h users, we can find that they all
were sourcing the trace header in advance of rcu.h itself,
as seen in the context of this diff.  There were also some
inconsistencies as to whether it was or wasn't sourced based
on the parent tracing Kconfig.

Rather than "fix" it at each use site, and have inconsistent
use based on whether "#ifdef CONFIG_RCU_TRACE" was used or not,
lets just source the trace header just once, in the actual consumer
of it, which is rcu.h itself.  We include it unconditionally, as
build testing shows us that is a hard requirement for some files.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[v2: move the #include <trace/events/rcu.h> outside of the scope
 of #ifdef CONFIG_RCU_TRACE so it is unconditionally included.]

 kernel/rcu/rcu.h    | 1 +
 kernel/rcu/srcu.c   | 2 --
 kernel/rcu/tiny.c   | 4 ----
 kernel/rcu/tree.c   | 2 --
 kernel/rcu/update.c | 1 -
 5 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 1bd787fddcb2..3d2a037332b2 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -23,6 +23,7 @@
 #ifndef __LINUX_RCU_H
 #define __LINUX_RCU_H
 
+#include <trace/events/rcu.h>
 #ifdef CONFIG_RCU_TRACE
 #define RCU_TRACE(stmt) stmt
 #else /* #ifdef CONFIG_RCU_TRACE */
diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index 5db7e9272d37..8e66b05bfd82 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -36,8 +36,6 @@
 #include <linux/delay.h>
 #include <linux/srcu.h>
 
-#include <trace/events/rcu.h>
-
 #include "rcu.h"
 
 /*
diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index 53b95bbf4abb..d9efcc13008c 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -37,10 +37,6 @@
 #include <linux/prefetch.h>
 #include <linux/ftrace_event.h>
 
-#ifdef CONFIG_RCU_TRACE
-#include <trace/events/rcu.h>
-#endif /* #else #ifdef CONFIG_RCU_TRACE */
-
 #include "rcu.h"
 
 /* Forward declarations for tiny_plugin.h. */
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index c7a00dbe768b..351faba48b91 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -58,8 +58,6 @@
 #include <linux/suspend.h>
 
 #include "tree.h"
-#include <trace/events/rcu.h>
-
 #include "rcu.h"
 
 MODULE_ALIAS("rcutree");
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index fd0d5b5b8e7c..4c0a9b0af469 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -49,7 +49,6 @@
 #include <linux/module.h>
 
 #define CREATE_TRACE_POINTS
-#include <trace/events/rcu.h>
 
 #include "rcu.h"
 
-- 
1.8.5.2

