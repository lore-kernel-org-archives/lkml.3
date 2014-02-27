Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaB0Qav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:30:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57142 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaB0Qas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:30:48 -0500
Date: Thu, 27 Feb 2014 08:30:38 -0800
From: tip-bot for Ross Zwisler <tipbot@zytor.com>
Message-ID: <tip-2a0c772f1967565d5b71a98012e74d5a7bddc1c4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ross.zwisler@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ross.zwisler@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1393441612-19729-4-git-send-email-ross.zwisler@linux.intel.com>
References: <1393441612-19729-4-git-send-email-ross.zwisler@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Use clflushopt in drm_clflush_page
Git-Commit-ID: 2a0c772f1967565d5b71a98012e74d5a7bddc1c4
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

Commit-ID:  2a0c772f1967565d5b71a98012e74d5a7bddc1c4
Gitweb:     http://git.kernel.org/tip/2a0c772f1967565d5b71a98012e74d5a7bddc1c4
Author:     Ross Zwisler <ross.zwisler@linux.intel.com>
AuthorDate: Wed, 26 Feb 2014 12:06:51 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 27 Feb 2014 08:26:20 -0800

x86: Use clflushopt in drm_clflush_page

If clflushopt is available on the system, use it instead of clflush in
drm_clflush_page.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Link: http://lkml.kernel.org/r/1393441612-19729-4-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/gpu/drm/drm_cache.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index bb8f580..c518fb6 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -32,6 +32,12 @@
 #include <drm/drmP.h>
 
 #if defined(CONFIG_X86)
+
+/*
+ * clflushopt is an unordered instruction which needs fencing with mfence or
+ * sfence to avoid ordering issues.  For drm_clflush_page this fencing happens
+ * in the caller.
+ */
 static void
 drm_clflush_page(struct page *page)
 {
@@ -44,7 +50,7 @@ drm_clflush_page(struct page *page)
 
 	page_virtual = kmap_atomic(page);
 	for (i = 0; i < PAGE_SIZE; i += size)
-		clflush(page_virtual + i);
+		clflushopt(page_virtual + i);
 	kunmap_atomic(page_virtual);
 }
 
