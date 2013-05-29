Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935343Ab3E2W2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:28:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:15899 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935300Ab3E2W2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:28:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,766,1363158000"; 
   d="scan'208";a="248386641"
Subject: [v3][PATCH 2/4] x86: warn when NMI handlers take large amounts of time
To: a.p.zijlstra@chello.nl
Cc: mingo@redhat.com, paulus@samba.org, acme@ghostprotocols.net,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 29 May 2013 15:27:59 -0700
References: <20130529222756.25535229@viggo.jf.intel.com>
In-Reply-To: <20130529222756.25535229@viggo.jf.intel.com>
Message-Id: <20130529222759.6D8C68B2@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

I have a system which is causing all kinds of problems.  It has 8
NUMA nodes, and lots of cores that can fight over cachelines.
If things are not working _perfectly_, then NMIs can take longer
than expected.

If we get too many of them backed up to each other, we can easily
end up in a situation where we are doing nothing *but* running
NMIs.  The biggest problem, though, is that this happens
_silently_.  You might be lucky to get an hrtimer warning, but
most of the time system simply hangs.

This patch should at least give us some warning before we fall
off the cliff.  the warnings look like this:

	nmi_handle: perf_event_nmi_handler() took: 26095071 ns

The message is triggered whenever we notice the longest NMI
we've seen to date.  You can always view and reset this value
via the debugfs interface if you like.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/kernel/nmi.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/nmi.c~debug-nmi-timing arch/x86/kernel/nmi.c
--- linux.git/arch/x86/kernel/nmi.c~debug-nmi-timing	2013-05-29 15:10:19.159660273 -0700
+++ linux.git-davehans/arch/x86/kernel/nmi.c	2013-05-29 15:10:19.162660403 -0700
@@ -14,6 +14,7 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/nmi.h>
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/slab.h>
@@ -82,6 +83,15 @@ __setup("unknown_nmi_panic", setup_unkno
 
 #define nmi_to_desc(type) (&nmi_desc[type])
 
+static u64 nmi_longest_ns = 1000 * 1000 * 1000;
+static int __init nmi_warning_debugfs(void)
+{
+	debugfs_create_u64("nmi_longest_ns", 0644,
+			arch_debugfs_dir, &nmi_longest_ns);
+	return 0;
+}
+fs_initcall(nmi_warning_debugfs);
+
 static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
@@ -96,8 +106,24 @@ static int __kprobes nmi_handle(unsigned
 	 * can be latched at any given time.  Walk the whole list
 	 * to handle those situations.
 	 */
-	list_for_each_entry_rcu(a, &desc->head, list)
+	list_for_each_entry_rcu(a, &desc->head, list) {
+		u64 before, delta, whole_msecs;
+		int decimal_msecs;
+
+		before = local_clock();
 		handled += a->handler(type, regs);
+		delta = local_clock() - before;
+
+		if (delta < nmi_longest_ns)
+			continue;
+
+		nmi_longest_ns = delta;
+		whole_msecs = delta / (1000 * 1000);
+		decimal_msecs = (delta / 1000) % 1000;
+		printk_ratelimited(KERN_INFO
+			"INFO: NMI handler took too long to run: "
+			"%lld.%03d msecs\n", whole_msecs, decimal_msecs);
+	}
 
 	rcu_read_unlock();
 
_
