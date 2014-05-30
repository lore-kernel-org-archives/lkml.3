Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbaE3GwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:52:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093AbaE3GwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:52:02 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Kamil Iskra <iskra@mcs.anl.gov>, Borislav Petkov <bp@suse.de>,
        Chen Gong <gong.chen@linux.jf.intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 1/3] memory-failure: Send right signal code to correct thread
Date: Fri, 30 May 2014 02:51:08 -0400
Message-Id: <1401432670-24664-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1401432670-24664-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <53877e9c.8b2cdc0a.1604.ffffea43SMTPIN_ADDED_BROKEN@mx.google.com>
 <1401432670-24664-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

When a thread in a multi-threaded application hits a machine
check because of an uncorrectable error in memory - we want to
send the SIGBUS with si.si_code = BUS_MCEERR_AR to that thread.
Currently we fail to do that if the active thread is not the
primary thread in the process. collect_procs() just finds primary
threads and this test:
	if ((flags & MF_ACTION_REQUIRED) && t == current) {
will see that the thread we found isn't the current thread
and so send a si.si_code = BUS_MCEERR_AO to the primary
(and nothing to the active thread at this time).

We can fix this by checking whether "current" shares the same
mm with the process that collect_procs() said owned the page.
If so, we send the SIGBUS to current (with code BUS_MCEERR_AR).

Reported-by: Otto Bruggeman <otto.g.bruggeman@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Chen Gong <gong.chen@linux.jf.intel.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/memory-failure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git mmotm-2014-05-21-16-57.orig/mm/memory-failure.c mmotm-2014-05-21-16-57/mm/memory-failure.c
index e3154d99b87f..b73098ee91e6 100644
--- mmotm-2014-05-21-16-57.orig/mm/memory-failure.c
+++ mmotm-2014-05-21-16-57/mm/memory-failure.c
@@ -204,9 +204,9 @@ static int kill_proc(struct task_struct *t, unsigned long addr, int trapno,
 #endif
 	si.si_addr_lsb = page_size_order(page) + PAGE_SHIFT;
 
-	if ((flags & MF_ACTION_REQUIRED) && t == current) {
+	if ((flags & MF_ACTION_REQUIRED) && t->mm == current->mm) {
 		si.si_code = BUS_MCEERR_AR;
-		ret = force_sig_info(SIGBUS, &si, t);
+		ret = force_sig_info(SIGBUS, &si, current);
 	} else {
 		/*
 		 * Don't use force here, it's convenient if the signal
-- 
1.9.3

