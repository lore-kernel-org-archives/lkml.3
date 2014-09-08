Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaIHRtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:49:12 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43960 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327AbaIHRrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:47:55 -0400
X-Sasl-enc: xpatMjV04xNgaxqEntjMJld+ax3jtih9Bv77zwDF4aBp 1410197888
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 5/8] x86, microcode, intel: don't check extsig entry checksum
Date: Mon,  8 Sep 2014 14:37:51 -0300
Message-Id: <1410197875-19252-6-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The contents of the extended signature entries are already covered by
the extended table checksum, and the microcode driver should not be
attempting to check their internal checksum field.

Unlike the main microcode checksum field and the extended signature
table checksum field, the checksum fields inside the extended signature
entries are not meant to be processed by a microcode update loader.  The
extended signature entry checksum field's description in the Intel SDM,
vol 3A, table 9-6, page 9-30, reads in the first paragraph:

   "Used by utility software to decompose a microcode update into
    multiple microcode updates where each of the new updates is
    constructed without the optional Extended Processor Signature
    Table."

And the Linux microcode driver is not processing them correctly anyway.
The second paragraph of the signature entry checksum field's description
in the Intel SDM, vol 3A, table 9-6, page 9-30, reads:

   "To calculate the Checksum, substitute the Primary Processor
    Signature entry and the Processor Flags entry with the corresponding
    Extended Patch entry. Delete the Extended Processor Signature Table
    entries. The Checksum is correct when the summation of all DWORDs
    that comprise the created Extended Processor Patch results in
    00000000H."

Deleting the extended signature table changes the Total Size field, and
the Intel SDM paragraph above makes it very clear that such a change must
be accounted for by the checksum.  The current extended signature entry
checksum code in the Linux microcode driver, which has been in place
since 2003, will be thrown off by this and reject a valid microcode
update.

The microcode driver is better off by doing what the Intel SDM suggests,
and staying well clear of that checksum field.  It has already checked
the whole extended signature table's checksum, anyway.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/kernel/cpu/microcode/intel_lib.c |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
index 1cc6494..9200b83 100644
--- a/arch/x86/kernel/cpu/microcode/intel_lib.c
+++ b/arch/x86/kernel/cpu/microcode/intel_lib.c
@@ -49,8 +49,7 @@ int microcode_sanity_check(void *mc, int print_err)
 	unsigned long total_size, data_size, ext_table_size;
 	struct microcode_header_intel *mc_header = mc;
 	struct extended_sigtable *ext_header = NULL;
-	int sum, orig_sum, ext_sigcount = 0, i;
-	struct extended_signature *ext_sig;
+	int orig_sum, i;
 
 	total_size = get_totalsize(mc_header);
 	data_size = get_datasize(mc_header);
@@ -81,7 +80,6 @@ int microcode_sanity_check(void *mc, int print_err)
 				pr_err("error: bad exttable size in microcode data file\n");
 			return -EFAULT;
 		}
-		ext_sigcount = ext_header->count;
 	}
 
 	/*
@@ -129,21 +127,7 @@ int microcode_sanity_check(void *mc, int print_err)
 			pr_err("error: bad microcode update checksum\n");
 		return -EINVAL;
 	}
-	if (!ext_table_size)
-		return 0;
-	/* check extended signature checksum */
-	for (i = 0; i < ext_sigcount; i++) {
-		ext_sig = (void *)ext_header + EXT_HEADER_SIZE +
-			  EXT_SIGNATURE_SIZE * i;
-		sum = orig_sum
-			- (mc_header->sig + mc_header->pf + mc_header->cksum)
-			+ (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
-		if (sum) {
-			if (print_err)
-				pr_err("error: bad extended signature checksum\n");
-			return -EINVAL;
-		}
-	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(microcode_sanity_check);
-- 
1.7.10.4

