Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbaF3Mba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:31:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932233AbaF3MbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:22 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@suse.de>,
        Chen Gong <gong.chen@linux.jf.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 113/181] mm/memory-failure.c-failure: send right signal code to correct thread
Date: Mon, 30 Jun 2014 13:52:14 +0200
Message-Id: <11b92053aef791c7da356dcd081916ebdea92dc7.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a70ffcac741d31a406c1d2b832ae43d658e7e1cf upstream.

When a thread in a multi-threaded application hits a machine check because
of an uncorrectable error in memory - we want to send the SIGBUS with
si.si_code = BUS_MCEERR_AR to that thread.  Currently we fail to do that
if the active thread is not the primary thread in the process.
collect_procs() just finds primary threads and this test:

	if ((flags & MF_ACTION_REQUIRED) && t == current) {

will see that the thread we found isn't the current thread and so send a
si.si_code = BUS_MCEERR_AO to the primary (and nothing to the active
thread at this time).

We can fix this by checking whether "current" shares the same mm with the
process that collect_procs() said owned the page.  If so, we send the
SIGBUS to current (with code BUS_MCEERR_AR).

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Otto Bruggeman <otto.g.bruggeman@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Chen Gong <gong.chen@linux.jf.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/memory-failure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ecfbfe520342..fe4873b010eb 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -208,9 +208,9 @@ static int kill_proc(struct task_struct *t, unsigned long addr, int trapno,
 #endif
 	si.si_addr_lsb = compound_order(compound_head(page)) + PAGE_SHIFT;
 
-	if ((flags & MF_ACTION_REQUIRED) && t == current) {
+	if ((flags & MF_ACTION_REQUIRED) && t->mm == current->mm) {
 		si.si_code = BUS_MCEERR_AR;
-		ret = force_sig_info(SIGBUS, &si, t);
+		ret = force_sig_info(SIGBUS, &si, current);
 	} else {
 		/*
 		 * Don't use force here, it's convenient if the signal
-- 
2.0.0

