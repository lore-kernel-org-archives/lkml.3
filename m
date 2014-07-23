Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbaGWULM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:11:12 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53238 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933321AbaGWULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:11:04 -0400
X-Sasl-enc: ddt8bU9T9IF66LJhjN3eBbJELN+wy+1WEyMQ/zImtBeR 1406146263
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 5/8] x86, microcode, intel: don't use fields from unknown format header
Date: Wed, 23 Jul 2014 17:10:48 -0300
Message-Id: <1406146251-8540-6-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must make sure the microcode has a known header format before
we attempt to access its Total Size or Data Size fields through
get_totalsize() or get_datasize().

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/kernel/cpu/microcode/intel.c       |    5 +++++
 arch/x86/kernel/cpu/microcode/intel_early.c |    3 +++
 arch/x86/kernel/cpu/microcode/intel_lib.c   |   11 ++++++-----
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index a51cb19..61d430e 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -199,6 +199,11 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 		if (get_ucode_data(&mc_header, ucode_ptr, sizeof(mc_header)))
 			break;
 
+		if (mc_header.hdrver != 1) {
+			pr_err("error! Unknown microcode update format\n");
+			break;
+		}
+
 		mc_size = get_totalsize(&mc_header);
 		if (!mc_size || mc_size > leftover) {
 			pr_err("error! Bad data in microcode data file\n");
diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index b88343f..c1bf915f 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -324,6 +324,9 @@ get_matching_model_microcode(int cpu, unsigned long start,
 	while (leftover) {
 		mc_header = (struct microcode_header_intel *)ucode_ptr;
 
+		if (mc_header->hdrver != 1)
+			break;
+
 		mc_size = get_totalsize(mc_header);
 		if (!mc_size || mc_size > leftover ||
 			microcode_sanity_check(ucode_ptr, 0) < 0)
diff --git a/arch/x86/kernel/cpu/microcode/intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
index ce69320..95c2d19 100644
--- a/arch/x86/kernel/cpu/microcode/intel_lib.c
+++ b/arch/x86/kernel/cpu/microcode/intel_lib.c
@@ -52,6 +52,12 @@ int microcode_sanity_check(void *mc, int print_err)
 	int sum, orig_sum, ext_sigcount = 0, i;
 	struct extended_signature *ext_sig;
 
+	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
+		if (print_err)
+			pr_err("error! Unknown microcode update format\n");
+		return -EINVAL;
+	}
+
 	total_size = get_totalsize(mc_header);
 	data_size = get_datasize(mc_header);
 
@@ -61,11 +67,6 @@ int microcode_sanity_check(void *mc, int print_err)
 		return -EINVAL;
 	}
 
-	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
-		if (print_err)
-			pr_err("error! Unknown microcode update format\n");
-		return -EINVAL;
-	}
 	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
 	if (ext_table_size) {
 		if ((ext_table_size < EXT_HEADER_SIZE)
-- 
1.7.10.4

