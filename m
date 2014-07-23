Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507AbaGWULn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:11:43 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35109 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933315AbaGWULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:11:08 -0400
X-Sasl-enc: AloH3OEKzFN4+zJp6zsJ9h5KdBqB/a4S4iXwuF97ZFhM 1406146267
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 7/8] x86, microcode, intel: forbid some incorrect metadata
Date: Wed, 23 Jul 2014 17:10:50 -0300
Message-Id: <1406146251-8540-8-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that both the microcode data_size and total_size fields are a
multiple of the dword size (4 bytes).  The Intel SDM vol 3A (order code
253668-051US, June 2014) requires this to be true, and the driver code
assumes it will be true.

Add a comment to the code stating that it is best if we continue to
refrain from ensuring that total_size is a multiple of 1024 bytes.  The
reason to never add that check is non-obvious.

Refuse a microcode with a revision of zero, we reserve that for the
factory-provided microcode.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/kernel/cpu/microcode/intel_lib.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
index 95c2d19..050cd4f 100644
--- a/arch/x86/kernel/cpu/microcode/intel_lib.c
+++ b/arch/x86/kernel/cpu/microcode/intel_lib.c
@@ -61,12 +61,22 @@ int microcode_sanity_check(void *mc, int print_err)
 	total_size = get_totalsize(mc_header);
 	data_size = get_datasize(mc_header);
 
-	if (data_size + MC_HEADER_SIZE > total_size) {
+	if ((data_size % DWSIZE) || (total_size % DWSIZE) ||
+	    (data_size + MC_HEADER_SIZE > total_size)) {
 		if (print_err)
-			pr_err("error! Bad data size in microcode data file\n");
+			pr_err("error! Bad data size or total size in microcode data file\n");
 		return -EINVAL;
 	}
 
+	/*
+	 * DO NOT add a check for total_size to be a multiple of 1024.
+	 *
+	 * While there is a requirement that total_size be a multiple of 1024
+	 * (Intel SDM vol 3A, section 9.11.1, table 9-6, page 9-29), it clashes
+	 * with the "delete extended signature table" procedure described for
+	 * the Checksum[n] field in the same table 9-6, at page 9-30).
+	 */
+
 	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
 	if (ext_table_size) {
 		if ((ext_table_size < EXT_HEADER_SIZE)
@@ -84,6 +94,13 @@ int microcode_sanity_check(void *mc, int print_err)
 		ext_sigcount = ext_header->count;
 	}
 
+	/* check some of the metadata */
+	if (mc_header->rev == 0) { /* reserved for silicon microcode */
+		if (print_err)
+			pr_err("error! Restricted revision 0 in microcode data file\n");
+		return -EINVAL;
+	}
+
 	/* check extended table checksum */
 	if (ext_table_size) {
 		int ext_table_sum = 0;
-- 
1.7.10.4

