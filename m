Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbaGWULl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:11:41 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51168 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933366AbaGWULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:11:08 -0400
X-Sasl-enc: AloT2ugRwkpr/Shu5CIB7RlTdBqB/a4S4iXwuF97ZFhM 1406146267
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 8/8] x86, microcode, intel: correct extended signature checksum verification
Date: Wed, 23 Jul 2014 17:10:51 -0300
Message-Id: <1406146251-8540-9-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have been calculating the checksum for extended signatures in a way that
is very likely to be incompatible with the Intel public documention.  This
code dates back to 2003, when the support for the "new microcode format"
was added to the driver by Intel itself.

The extended signature table should be deleted when an extended signature
is "applied" to the main microcode patch if the Intel SDM is to be believed
(Intel 64 and IA32 Software Developers Manual, vol 3A, page 9-30, entry for
"Checksum[n]" in table 9-6).  Deleting the extended signature table changes
the Total Size of the microcode, and that reflects in the checksum that
should be in the extended signature entry if it is to be used unmodified to
replace the main microcode signature.

It is worth noting that deleting the extended signature table results in a
microcode patch that violates the rule that the Total Size field must be a
multiple of 1024, and it is impossible to add any padding to fix that.

This patch changes the extended signature table checksum verification
code to accept both ways of calculating the extended signature checksum
as valid.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/kernel/cpu/microcode/intel_lib.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
index 050cd4f..c75f03a 100644
--- a/arch/x86/kernel/cpu/microcode/intel_lib.c
+++ b/arch/x86/kernel/cpu/microcode/intel_lib.c
@@ -135,9 +135,21 @@ int microcode_sanity_check(void *mc, int print_err)
 		sum = orig_sum
 			- (mc_header->sig + mc_header->pf + mc_header->cksum)
 			+ (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
-		if (sum) {
+		/*
+		 * accept two possibilities for the extended signature entry
+		 * checksum: the one we've been using since 2003 (which is
+		 * likely incorrect), as well as the one described in the
+		 * Intel SDM vol 3A (order #253668-051US, June 2014), table
+		 * 9-6, entry for Checksum[n] at page 9-30.
+		 *
+		 * When one deletes the extended signature table as the Intel
+		 * SDM mandates, total_size decreases by ext_table_size, and
+		 * so does the checksum, leaving a remainder equal to
+		 * ext_table_size in sum.
+		 */
+		if (sum != 0 && sum != ext_table_size) {
 			if (print_err)
-				pr_err("aborting, bad checksum\n");
+				pr_err("aborting, bad extended signature checksum\n");
 			return -EINVAL;
 		}
 	}
-- 
1.7.10.4

