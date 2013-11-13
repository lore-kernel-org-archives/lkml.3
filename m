Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab3KMNn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:43:56 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:36531 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3KMNnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:43:53 -0500
Date: Wed, 13 Nov 2013 14:43:50 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] x86, relocs: avoid calling qsort() with NULL pointer
Message-ID: <20131113134350.GA277@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current gcc trunk inserts a trap into arch/x86/tools/relocs:

 % arch/x86/tools/relocs --realmode arch/x86/realmode/rm/realmode.elf
[1]    31456 illegal hardware instruction  arch/x86/tools/relocs --realmode arch/x86/realmode/rm/realmode.elf

This happens because in the case of ELF_BITS==32 qsort is called with a
NULL pointer.

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index f7bab68a4b83..592abb938de7 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -976,7 +976,8 @@ static void emit_relocs(int as_text, int use_real_mode)
 	/* Order the relocations for more efficient processing */
 	sort_relocs(&relocs16);
 	sort_relocs(&relocs32);
-	sort_relocs(&relocs64);
+	if (ELF_BITS == 64)
+		sort_relocs(&relocs64);
 
 	/* Print the relocations */
 	if (as_text) {
-- 
Markus
