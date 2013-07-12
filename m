Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937Ab3GLNa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:30:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59611 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964808Ab3GLNay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:30:54 -0400
Date: Fri, 12 Jul 2013 06:30:00 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-baf64b85445546a38b44052d71782dfe7531e350@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, dave@sr71.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dave.hansen@linux.intel.com, dave@sr71.net
In-Reply-To: <20130708214404.B0B6EA66@viggo.jf.intel.com>
References: <20130708214404.B0B6EA66@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Fix incorrect use of do_div()
  in NMI warning
Git-Commit-ID: baf64b85445546a38b44052d71782dfe7531e350
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 06:30:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  baf64b85445546a38b44052d71782dfe7531e350
Gitweb:     http://git.kernel.org/tip/baf64b85445546a38b44052d71782dfe7531e350
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Mon, 8 Jul 2013 14:44:04 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Jul 2013 14:13:04 +0200

perf/x86: Fix incorrect use of do_div() in NMI warning

I completely botched understanding the calling conventions of
do_div().  I assumed that do_div() returned the result instead
of realizing that it modifies its argument and returns a
remainder.  The side-effect from this would be bogus numbers
for the "msecs" value in the warning messages:

	INFO: NMI handler (perf_event_nmi_handler) took too long to run: 0.114 msecs

Note, there was a second fix posted by Stephane Eranian for
a separate patch which I also botched:

	http://lkml.kernel.org/r/20130704223010.GA30625@quad

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20130708214404.B0B6EA66@viggo.jf.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/nmi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 0920212..ba77ebc 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -111,7 +111,7 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 	 */
 	list_for_each_entry_rcu(a, &desc->head, list) {
 		u64 before, delta, whole_msecs;
-		int decimal_msecs, thishandled;
+		int remainder_ns, decimal_msecs, thishandled;
 
 		before = local_clock();
 		thishandled = a->handler(type, regs);
@@ -123,8 +123,9 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 			continue;
 
 		nmi_longest_ns = delta;
-		whole_msecs = do_div(delta, (1000 * 1000));
-		decimal_msecs = do_div(delta, 1000) % 1000;
+		whole_msecs = delta;
+		remainder_ns = do_div(whole_msecs, (1000 * 1000));
+		decimal_msecs = remainder_ns / 1000;
 		printk_ratelimited(KERN_INFO
 			"INFO: NMI handler (%ps) took too long to run: "
 			"%lld.%03d msecs\n", a->handler, whole_msecs,
