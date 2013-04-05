Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161513Ab3DEL6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 07:58:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:52508 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161142Ab3DEL6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:58:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,414,1363158000"; 
   d="scan'208";a="289866871"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv3, RFC 02/34] block: implement add_bdi_stat()
Date: Fri,  5 Apr 2013 14:59:26 +0300
Message-Id: <1365163198-29726-3-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

We're going to add/remove a number of page cache entries at once. This
patch implements add_bdi_stat() which adjusts bdi stats by arbitrary
amount. It's required for batched page cache manipulations.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/backing-dev.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3504599..b05d961 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -167,6 +167,16 @@ static inline void __dec_bdi_stat(struct backing_dev_info *bdi,
 	__add_bdi_stat(bdi, item, -1);
 }
 
+static inline void add_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item, s64 amount)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__add_bdi_stat(bdi, item, amount);
+	local_irq_restore(flags);
+}
+
 static inline void dec_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item)
 {
-- 
1.7.10.4

