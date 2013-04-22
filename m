Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3DVOoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:44:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51529 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790Ab3DVOaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Jan Kara" <jack@suse.cz>, "Wu Fengguang" <fengguang.wu@intel.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.281029506@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [54/75] writeback: fix dirtied pages accounting on redirty
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 2f800fbd777b792de54187088df19a7df0251254 upstream.

De-account the accumulative dirty counters on page redirty.

Page redirties (very common in ext4) will introduce mismatch between
counters (a) and (b)

a) NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied
b) NR_WRITTEN, BDI_WRITTEN

This will introduce systematic errors in balanced_rate and result in
dirty page position errors (ie. the dirty pages are no longer balanced
around the global/bdi setpoints).

Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/writeback.h |    2 ++
 mm/page-writeback.c       |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -195,6 +195,8 @@ void writeback_set_ratelimit(void);
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
 
+void account_page_redirty(struct page *page);
+
 /* pdflush.c */
 extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
 				   read-only. */
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1801,6 +1801,24 @@ int __set_page_dirty_nobuffers(struct pa
 EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 
 /*
+ * Call this whenever redirtying a page, to de-account the dirty counters
+ * (NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied), so that they match the written
+ * counters (NR_WRITTEN, BDI_WRITTEN) in long term. The mismatches will lead to
+ * systematic errors in balanced_dirty_ratelimit and the dirty pages position
+ * control.
+ */
+void account_page_redirty(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+	if (mapping && mapping_cap_account_dirty(mapping)) {
+		current->nr_dirtied--;
+		dec_zone_page_state(page, NR_DIRTIED);
+		dec_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
+	}
+}
+EXPORT_SYMBOL(account_page_redirty);
+
+/*
  * When a writepage implementation decides that it doesn't want to write this
  * page for some reason, it should redirty the locked page via
  * redirty_page_for_writepage() and it should then unlock the page and return 0
@@ -1808,6 +1826,7 @@ EXPORT_SYMBOL(__set_page_dirty_nobuffers
 int redirty_page_for_writepage(struct writeback_control *wbc, struct page *page)
 {
 	wbc->pages_skipped++;
+	account_page_redirty(page);
 	return __set_page_dirty_nobuffers(page);
 }
 EXPORT_SYMBOL(redirty_page_for_writepage);

