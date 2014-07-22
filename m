Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735AbaGVW1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:27:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44978 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709AbaGVW1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:27:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tony Luck <tony.luck@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@suse.de>,
        Chen Gong <gong.chen@linux.jf.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 057/116] mm/memory-failure.c-failure: send right signal code to correct thread
Date: Tue, 22 Jul 2014 15:21:08 -0700
Message-Id: <1406067727-19683-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/memory-failure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d3ed748..0af800c 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -208,9 +208,9 @@ static int kill_proc(struct task_struct *t, unsigned long addr, int trapno,
 #endif
 	si.si_addr_lsb = compound_trans_order(compound_head(page)) + PAGE_SHIFT;
 
-	if ((flags & MF_ACTION_REQUIRED) && t == current) {
+	if ((flags & MF_ACTION_REQUIRED) && t->mm == current->mm) {
 		si.si_code = BUS_MCEERR_AR;
-		ret = force_sig_info(SIGBUS, &si, t);
+		ret = force_sig_info(SIGBUS, &si, current);
 	} else {
 		/*
 		 * Don't use force here, it's convenient if the signal
-- 
1.9.1

