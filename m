Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab3ANSWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:22:11 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:36430 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524Ab3ANSWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:22:10 -0500
Date: Mon, 14 Jan 2013 10:22:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, chavey@google.com, fengguang.wu@intel.com,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] writeback: mark sysctl vm.block_dump for removal
Message-ID: <20130114182203.GE27942@mtj.dyndns.org>
References: <1357938397-5413-1-git-send-email-tj@kernel.org>
 <20130114140227.GB2441@kernel.dk>
 <20130114174318.GD27942@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130114174318.GD27942@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vm.block_dump is nasty in that it dumps IO traces directly to printk.
It isn't scalable and can easily lead to looping behavior - IO
generating kernel message which in turn genreates log IO, ad
infinitum.

Now that proper tracepoints are in place, vm.block_dump isn't
necessary.  Generate a warning if used so that it can be removed down
the road.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/writeback.h |    3 +++
 kernel/sysctl.c           |    2 +-
 mm/page-writeback.c       |   14 ++++++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index b82a83a..678ee6d 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -143,6 +143,9 @@ extern int dirty_ratio_handler(struct ctl_table *table, int write,
 extern int dirty_bytes_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
+extern int block_dump_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
 
 struct ctl_table;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c88878d..9e7f7b5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1288,7 +1288,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &block_dump,
 		.maxlen		= sizeof(block_dump),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= block_dump_handler,
 		.extra1		= &zero,
 	},
 	{
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 6f42712..5548bef 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -390,6 +390,20 @@ int dirty_bytes_handler(struct ctl_table *table, int write,
 	return ret;
 }
 
+int block_dump_handler(struct ctl_table *table, int write,
+		       void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	static bool warned = false;
+	int ret;
+
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (!warned && block_dump) {
+		pr_warning("sysctl: vm.block_dump is scheduled for removal. Please use tracepoints instead.\n");
+		warned = true;
+	}
+	return ret;
+}
+
 static unsigned long wp_next_time(unsigned long cur_time)
 {
 	cur_time += VM_COMPLETIONS_PERIOD_LEN;
