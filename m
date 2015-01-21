Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbbAUDh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:37:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbbAUDhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:37:53 -0500
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        keescook@chromium.org, vgoyal@redhat.com, whissi@whissi.de,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH 3/6] Introduce a function to randomize the kernel text mapping address
Date: Wed, 21 Jan 2015 11:37:14 +0800
Message-Id: <1421811437-2787-4-git-send-email-bhe@redhat.com>
In-Reply-To: <1421811437-2787-1-git-send-email-bhe@redhat.com>
References: <1421811437-2787-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kaslr extended kernel text mapping region size from 512M to 1G,
namely CONFIG_RANDOMIZE_BASE_MAX_OFFSET. This means kernel text
can be mapped to below region:

__START_KERNEL_map + LOAD_PHYSICAL_ADDR, __START_KERNEL_map + 1G]

Introduce a function find_random_virt_offset() to get random value
between LOAD_PHYSICAL_ADDR and CONFIG_RANDOMIZE_BASE_MAX_OFFSET.
This random value will be added to __START_KERNEL_map to get the
starting address which kernel text is mapped from.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/aslr.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 9a7210c..091b118 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -1,4 +1,5 @@
 #include "misc.h"
+#include "../string.h"
 
 #include <asm/msr.h>
 #include <asm/archrandom.h>
@@ -295,6 +296,27 @@ static unsigned long find_random_addr(unsigned long minimum,
 	return slots_fetch_random();
 }
 
+static unsigned long find_random_virt_offset(unsigned long size)
+{
+	struct mem_vector region, img;
+
+	memset(slots, 0, sizeof(slots));
+	slot_max = 0;
+
+	region.start = LOAD_PHYSICAL_ADDR;
+	region.size = CONFIG_RANDOMIZE_BASE_MAX_OFFSET - region.start;
+
+	for (img.start = region.start, img.size = size;
+	     mem_contains(&region, &img);
+	     img.start += CONFIG_PHYSICAL_ALIGN) {
+		if (mem_avoid_overlap(&img))
+			continue;
+		slots_append(img.start);
+	}
+
+	return slots_fetch_random();
+}
+
 unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
-- 
1.9.3

