Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaFEOj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:39:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48685 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaFEOj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:39:56 -0400
Date: Thu, 5 Jun 2014 07:38:57 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-41ccba029e9492dd0fc1bf5c23b72c6322a6dfe9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        hughd@google.com, dvlasenk@redhat.com, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, hughd@google.com,
        acme@kernel.org, srikar@linux.vnet.ibm.com, dvlasenk@redhat.com,
        oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20140519184054.GA6750@redhat.com>
References: <20140519184054.GA6750@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Shift ->readpage check from __copy_insn(
 ) to uprobe_register()
Git-Commit-ID: 41ccba029e9492dd0fc1bf5c23b72c6322a6dfe9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41ccba029e9492dd0fc1bf5c23b72c6322a6dfe9
Gitweb:     http://git.kernel.org/tip/41ccba029e9492dd0fc1bf5c23b72c6322a6dfe9
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 19 May 2014 20:40:54 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:30:07 +0200

uprobes: Shift ->readpage check from __copy_insn() to uprobe_register()

copy_insn() fails with -EIO if ->readpage == NULL, but this error
is not propagated unless uprobe_register() path finds ->mm which
already mmaps this file. In this case (say) "perf record" does not
actually install the probe, but the user can't know about this.

Move this check into uprobe_register() so that this problem can be
detected earlier and reported to user.

Note: this is still not perfect,

	- copy_insn() and arch_uprobe_analyze_insn() should be called
	  by uprobe_register() but this is not simple, we need vm_file
	  for read_mapping_page() (although perhaps we can pass NULL),
	  and we need ->mm for is_64bit_mm() (although this logic is
	  broken anyway).

	- uprobe_register() should be called by create_trace_uprobe(),
	  not by probe_event_enable(), so that an error can be detected
	  at "perf probe -x" time. This also needs more changes in the
	  core uprobe code, uprobe register/unregister interface was
	  poorly designed from the very beginning.

Reported-by: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140519184054.GA6750@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 3b02c72..c56b13e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -536,9 +536,6 @@ static int __copy_insn(struct address_space *mapping, struct file *filp,
 			void *insn, int nbytes, loff_t offset)
 {
 	struct page *page;
-
-	if (!mapping->a_ops->readpage)
-		return -EIO;
 	/*
 	 * Ensure that the page that has the original instruction is
 	 * populated and in page-cache.
@@ -879,6 +876,9 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	if (!uc->handler && !uc->ret_handler)
 		return -EINVAL;
 
+	/* copy_insn()->read_mapping_page() needs ->readpage() */
+	if (!inode->i_mapping->a_ops->readpage)
+		return -EIO;
 	/* Racy, just to catch the obvious mistakes */
 	if (offset > i_size_read(inode))
 		return -EINVAL;
