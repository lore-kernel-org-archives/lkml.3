Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbbA1F5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:57:39 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:17793 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027AbbA1F5i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 00:57:38 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'airlied@linux.ie'" <airlied@linux.ie>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 28 Jan 2015 13:57:34 +0800
Subject: [PATCH] agp:change agp_free_page_array to use kvfree
Thread-Topic: [PATCH] agp:change agp_free_page_array to use kvfree
Thread-Index: AdA6v08bfUmqlEuhS8eTCl3daARqJw==
Message-ID: <35FD53F367049845BC99AC72306C23D1044A02027DFE@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mcafeedlp-tag-0: {224703BC-758A-11E4-982F-0DF611A26A07}
x-mcafeedlp-tagged: True
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change agp_free_page_array to use kvfree function,
remove the duplicated code.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 drivers/char/agp/agp.h     |  5 ++++-
 drivers/char/agp/generic.c | 11 -----------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index b709749..4eb1c77 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -219,7 +219,10 @@ struct agp_bridge_data *agp_generic_find_bridge(struct pci_dev *pdev);
 /* generic functions for user-populated AGP memory types */
 struct agp_memory *agp_generic_alloc_user(size_t page_count, int type);
 void agp_alloc_page_array(size_t size, struct agp_memory *mem);
-void agp_free_page_array(struct agp_memory *mem);
+static inline void agp_free_page_array(struct agp_memory *mem)
+{
+	kvfree(mem->pages);
+}
 
 
 /* generic routines for agp>=3 */
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 0fbccce..f002fa5 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -98,17 +98,6 @@ void agp_alloc_page_array(size_t size, struct agp_memory *mem)
 }
 EXPORT_SYMBOL(agp_alloc_page_array);
 
-void agp_free_page_array(struct agp_memory *mem)
-{
-	if (is_vmalloc_addr(mem->pages)) {
-		vfree(mem->pages);
-	} else {
-		kfree(mem->pages);
-	}
-}
-EXPORT_SYMBOL(agp_free_page_array);
-
-
 static struct agp_memory *agp_create_user_memory(unsigned long num_agp_pages)
 {
 	struct agp_memory *new;
-- 
2.2.2
