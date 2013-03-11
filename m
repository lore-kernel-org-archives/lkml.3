Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3CKQ2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:28:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60240 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab3CKQ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:28:19 -0400
X-IronPort-AV: E=Sophos;i="4.84,824,1355068800"; 
   d="scan'208";a="6852605"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Bottomley <JBottomley@Parallels.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org
Subject: [PATCH 3/3] async: rename and redefine async_func_ptr
Date: Tue, 12 Mar 2013 00:30:04 +0800
Message-Id: <1363019405-4331-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1363019405-4331-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363019405-4331-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 00:27:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 00:27:06,
	Serialize complete at 2013/03/12 00:27:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A function type is typically defined as
typedef ret_type (*func)(args..)

but async_func_ptr is not.  Redefine it.

Also rename async_func_ptr to async_func_t for _func_t suffix is more generic.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/sh/drivers/pci/pcie-sh7786.c |    2 +-
 include/linux/async.h             |    6 +++---
 kernel/async.c                    |   20 ++++++++++----------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/sh/drivers/pci/pcie-sh7786.c b/arch/sh/drivers/pci/pcie-sh7786.c
index c2c85f6..a162a7f 100644
--- a/arch/sh/drivers/pci/pcie-sh7786.c
+++ b/arch/sh/drivers/pci/pcie-sh7786.c
@@ -35,7 +35,7 @@ static unsigned int nr_ports;
 
 static struct sh7786_pcie_hwops {
 	int (*core_init)(void);
-	async_func_ptr *port_init_hw;
+	async_func_t port_init_hw;
 } *sh7786_pcie_hwops;
 
 static struct resource sh7786_pci0_resources[] = {
diff --git a/include/linux/async.h b/include/linux/async.h
index 8e53494..0f1226d 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -16,7 +16,7 @@
 #include <linux/list.h>
 
 typedef u64 async_cookie_t;
-typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
+typedef void (*async_func_t) (void *data, async_cookie_t cookie);
 struct async_domain {
 	struct list_head pending;
 	unsigned registered:1;
@@ -35,8 +35,8 @@ struct async_domain {
 #define ASYNC_DOMAIN_EXCLUSIVE(_name) struct async_domain _name =	\
 	{ .pending = LIST_HEAD_INIT(_name.pending), .registered = 0 }
 
-extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
-extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
+extern async_cookie_t async_schedule(async_func_t func, void *data);
+extern async_cookie_t async_schedule_domain(async_func_t func, void *data,
 					    struct async_domain *domain);
 void async_unregister_domain(struct async_domain *domain);
 extern void async_synchronize_full(void);
diff --git a/kernel/async.c b/kernel/async.c
index ef66b2f..61873c3 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -73,7 +73,7 @@ struct async_entry {
 	struct list_head	global_list;
 	struct work_struct	work;
 	async_cookie_t		cookie;
-	async_func_ptr		*func;
+	async_func_t		func;
 	void			*data;
 	struct async_domain	*domain;
 };
@@ -145,7 +145,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	wake_up(&async_done);
 }
 
-static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct async_domain *domain)
+static async_cookie_t __async_schedule(async_func_t func, void *data, struct async_domain *domain)
 {
 	struct async_entry *entry;
 	unsigned long flags;
@@ -165,13 +165,13 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct a
 		spin_unlock_irqrestore(&async_lock, flags);
 
 		/* low on memory.. run synchronously */
-		ptr(data, newcookie);
+		func(data, newcookie);
 		return newcookie;
 	}
 	INIT_LIST_HEAD(&entry->domain_list);
 	INIT_LIST_HEAD(&entry->global_list);
 	INIT_WORK(&entry->work, async_run_entry_fn);
-	entry->func = ptr;
+	entry->func = func;
 	entry->data = data;
 	entry->domain = domain;
 
@@ -198,21 +198,21 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct a
 
 /**
  * async_schedule - schedule a function for asynchronous execution
- * @ptr: function to execute asynchronously
+ * @func: function to execute asynchronously
  * @data: data pointer to pass to the function
  *
  * Returns an async_cookie_t that may be used for checkpointing later.
  * Note: This function may be called from atomic or non-atomic contexts.
  */
-async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
+async_cookie_t async_schedule(async_func_t func, void *data)
 {
-	return __async_schedule(ptr, data, &async_dfl_domain);
+	return __async_schedule(func, data, &async_dfl_domain);
 }
 EXPORT_SYMBOL_GPL(async_schedule);
 
 /**
  * async_schedule_domain - schedule a function for asynchronous execution within a certain domain
- * @ptr: function to execute asynchronously
+ * @func: function to execute asynchronously
  * @data: data pointer to pass to the function
  * @domain: the domain
  *
@@ -222,10 +222,10 @@ EXPORT_SYMBOL_GPL(async_schedule);
  * synchronization domain is specified via @domain.  Note: This function
  * may be called from atomic or non-atomic contexts.
  */
-async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
+async_cookie_t async_schedule_domain(async_func_t func, void *data,
 				     struct async_domain *domain)
 {
-	return __async_schedule(ptr, data, domain);
+	return __async_schedule(func, data, domain);
 }
 EXPORT_SYMBOL_GPL(async_schedule_domain);
 
-- 
1.7.4.4

