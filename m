Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbbAUDiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:38:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbbAUDiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:38:11 -0500
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        keescook@chromium.org, vgoyal@redhat.com, whissi@whissi.de,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH 6/6] extend the upper limit of kernel physical address randomization to 4G
Date: Wed, 21 Jan 2015 11:37:17 +0800
Message-Id: <1421811437-2787-7-git-send-email-bhe@redhat.com>
In-Reply-To: <1421811437-2787-1-git-send-email-bhe@redhat.com>
References: <1421811437-2787-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since now kaslr can separately do randomization of physical and virtual
address, the physical address doesn't have to be
CONFIG_RANDOMIZE_BASE_MAX_OFFSET any more. At this time the identity
mapping only covers [0, 4G], so extend the upper limit of kernel physical
address randomization to 4G.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/aslr.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 20a5f23..b112f90 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -207,14 +207,15 @@ static bool mem_avoid_overlap(struct mem_vector *img)
 	return false;
 }
 
-static unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
+#define PHYS_RANDOM_UPPER_LIMIT 0x100000000UL
+static unsigned long slots[PHYS_RANDOM_UPPER_LIMIT /
 			   CONFIG_PHYSICAL_ALIGN];
 static unsigned long slot_max;
 
 static void slots_append(unsigned long addr)
 {
 	/* Overflowing the slots list should be impossible. */
-	if (slot_max >= CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
+	if (slot_max >= PHYS_RANDOM_UPPER_LIMIT /
 			CONFIG_PHYSICAL_ALIGN)
 		return;
 
@@ -241,7 +242,7 @@ static void process_e820_entry(struct e820entry *entry,
 		return;
 
 	/* Ignore entries entirely above our maximum. */
-	if (entry->addr >= CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
+	if (entry->addr >= PHYS_RANDOM_UPPER_LIMIT)
 		return;
 
 	/* Ignore entries entirely below our minimum. */
@@ -266,8 +267,8 @@ static void process_e820_entry(struct e820entry *entry,
 	region.size -= region.start - entry->addr;
 
 	/* Reduce maximum size to fit end of image within maximum limit. */
-	if (region.start + region.size > CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
-		region.size = CONFIG_RANDOMIZE_BASE_MAX_OFFSET - region.start;
+	if (region.start + region.size  > PHYS_RANDOM_UPPER_LIMIT)
+		region.size = PHYS_RANDOM_UPPER_LIMIT - region.start;
 
 	/* Walk each aligned slot and check for avoided areas. */
 	for (img.start = region.start, img.size = image_size ;
-- 
1.9.3

