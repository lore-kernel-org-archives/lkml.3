Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822AbaIEOKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:10:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791AbaIEOKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:10:11 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ak@linux.intel.com, mingo@redhat.com, whissi@whissi.de, dyoung@redhat.com,
        tglx@linutronix.de, vgoyal@redhat.com, keescook@chromium.org,
        chaowang@redhat.com, Baoquan He <bhe@redhat.com>
Subject: [PATCH 3/4] kaslr setup_data handling
Date: Fri,  5 Sep 2014 22:08:16 +0800
Message-Id: <1409926097-2101-4-git-send-email-bhe@redhat.com>
In-Reply-To: <1409926097-2101-1-git-send-email-bhe@redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <dyoung@redhat.com>

X86 will pass setup_data region while necessary, these regions could be
overwitten by kernel due to kaslr.

Thus iterate and add setup regions to mem_avoid[] in this patch.
Up to now there isn't a official data to state the maximal entries
setup data could use. So just set max mem avoid entries 32, hopefully
it will be enough. This can be increased later when people report
they are using more setup data entries.

Signed-off-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/aslr.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 975b07b..7e92fc8 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -110,8 +110,9 @@ struct mem_vector {
 	unsigned long size;
 };
 
-#define MEM_AVOID_MAX 5
+#define MEM_AVOID_MAX 32
 static struct mem_vector mem_avoid[MEM_AVOID_MAX];
+static int mem_avoid_nr;
 
 static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
 {
@@ -135,6 +136,27 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
 	return true;
 }
 
+static void mem_avoid_setup_data(void)
+{
+	struct setup_data *data;
+	u64 pa_data;
+
+	pa_data = real_mode->hdr.setup_data;
+	while (pa_data) {
+		if (mem_avoid_nr >= MEM_AVOID_MAX) {
+			debug_putstr("KASLR: too many setup_data ranges.\n");
+			return;
+		}
+		data = (struct setup_data *)pa_data;
+		if (pa_data < CONFIG_RANDOMIZE_BASE_MAX_OFFSET) {
+			mem_avoid[mem_avoid_nr].start = pa_data;
+			mem_avoid[mem_avoid_nr].size = sizeof(*data) + data->len;
+			mem_avoid_nr++;
+		}
+		pa_data = data->next;
+	}
+}
+
 static void mem_avoid_init(unsigned long input, unsigned long input_size,
 			   unsigned long output, unsigned long output_size)
 {
@@ -177,6 +199,9 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	/* Avoid stack memory. */
 	mem_avoid[4].start = (unsigned long)free_mem_end_ptr;
 	mem_avoid[4].size = BOOT_STACK_SIZE;
+	mem_avoid_nr = 5;
+
+	mem_avoid_setup_data();
 }
 
 /* Does this memory vector overlap a known avoided area? */
@@ -184,7 +209,7 @@ static bool mem_avoid_overlap(struct mem_vector *img)
 {
 	int i;
 
-	for (i = 0; i < MEM_AVOID_MAX; i++) {
+	for (i = 0; i < mem_avoid_nr; i++) {
 		if (mem_overlaps(img, &mem_avoid[i]))
 			return true;
 	}
-- 
1.8.5.3

