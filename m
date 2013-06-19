Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964984Ab3FSSmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:42:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40230 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964914Ab3FSSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:42:33 -0400
Date: Wed, 19 Jun 2013 11:42:11 -0700
From: tip-bot for Dave Jones <tipbot@zytor.com>
Message-ID: <tip-4338774cd41a6abf72aa76585ce2184cea8ff8a2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        davej@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        davej@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        bp@suse.de
In-Reply-To: <20130618160911.GA24487@redhat.com>
References: <20130618160911.GA24487@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/debug:
  Only print out DR registers if they are not power-on defaults
Git-Commit-ID: 4338774cd41a6abf72aa76585ce2184cea8ff8a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:42:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4338774cd41a6abf72aa76585ce2184cea8ff8a2
Gitweb:     http://git.kernel.org/tip/4338774cd41a6abf72aa76585ce2184cea8ff8a2
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Tue, 18 Jun 2013 12:09:11 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 14:33:59 +0200

x86/debug: Only print out DR registers if they are not power-on defaults

The DR registers are rarely useful when decoding oopses.
With screen real estate during oopses at a premium, we can save
two lines by only printing out these registers when they are set
to something other than they power-on state.

Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130618160911.GA24487@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/process_32.c | 11 ++++++++---
 arch/x86/kernel/process_64.c |  9 ++++++++-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7305f7d..f84cfd1 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -110,11 +110,16 @@ void __show_regs(struct pt_regs *regs, int all)
 	get_debugreg(d1, 1);
 	get_debugreg(d2, 2);
 	get_debugreg(d3, 3);
-	printk(KERN_DEFAULT "DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
-			d0, d1, d2, d3);
-
 	get_debugreg(d6, 6);
 	get_debugreg(d7, 7);
+
+	/* Only print out debug registers if they are in their non-default state. */
+	if ((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
+	    (d6 == DR6_RESERVED) && (d7 == 0x400))
+		return;
+
+	printk(KERN_DEFAULT "DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
+			d0, d1, d2, d3);
 	printk(KERN_DEFAULT "DR6: %08lx DR7: %08lx\n",
 			d6, d7);
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 355ae06..a8b9abc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -105,11 +105,18 @@ void __show_regs(struct pt_regs *regs, int all)
 	get_debugreg(d0, 0);
 	get_debugreg(d1, 1);
 	get_debugreg(d2, 2);
-	printk(KERN_DEFAULT "DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
 	get_debugreg(d3, 3);
 	get_debugreg(d6, 6);
 	get_debugreg(d7, 7);
+
+	/* Only print out debug registers if they are in their non-default state. */
+	if ((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
+	    (d6 == DR6_RESERVED) && (d7 == 0x400))
+		return;
+
+	printk(KERN_DEFAULT "DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
 	printk(KERN_DEFAULT "DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
+
 }
 
 void release_thread(struct task_struct *dead_task)
