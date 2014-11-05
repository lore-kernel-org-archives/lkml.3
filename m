Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaKEHaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:30:55 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:12959 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaKEHay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:30:54 -0500
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <dwmw2@infradead.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] x86/iommu: fix incorrect bit operations in setting values
Date: Wed,  5 Nov 2014 15:30:19 +0800
Message-Id: <1415172619-4801-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function context_set_address_root() and set_root_value are setting new
address in a wrong way, and this patch is trying to fix this problem.

According to Intel Vt-d specs(Feb 2011, Revision 1.3), Chapter 9.1 and 9.2,
field ctp in root entry is using bits 12:63, field asr in context entry is
using bits 12:63.

To set these fields, the following functions are used:
static inline void context_set_address_root(struct context_entry *context,
        unsigned long value);
and
static inline void set_root_value(struct root_entry *root, unsigned long value)

But they are using an invalid method to set these fields, in current code, only
a '|' operator is used to set it. This will not set the asr to the expected
value if it has an old value.

For example:
Before calling this function,
	context->lo = 0x3456789012111;
	value = 0x123456789abcef12;

After we call context_set_address_root(context, value), expected result is
	context->lo == 0x123456789abce111;

But the actual result is:
	context->lo == 0x1237577f9bbde111;

So we need to clear bits 12:63 before setting the new value, this will fix
this problem.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/intel-iommu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index a27d6cb..11ac47b 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -195,6 +195,7 @@ static inline void set_root_present(struct root_entry *root)
 }
 static inline void set_root_value(struct root_entry *root, unsigned long value)
 {
+	root->val &= ~VTD_PAGE_MASK;
 	root->val |= value & VTD_PAGE_MASK;
 }
 
@@ -247,6 +248,7 @@ static inline void context_set_translation_type(struct context_entry *context,
 static inline void context_set_address_root(struct context_entry *context,
 					    unsigned long value)
 {
+	context->lo &= ~VTD_PAGE_MASK;
 	context->lo |= value & VTD_PAGE_MASK;
 }
 
-- 
2.0.0-rc0

