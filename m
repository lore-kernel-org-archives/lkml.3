Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3HXGf7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 02:35:59 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:39986 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3HXGf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 02:35:58 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Joern Rennecke <joern.rennecke@embecosm.com>,
        Noam Camus <noamc@ezchip.com>, <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] ARC: [lib] strchr breakage in Big-endian configuration
Date: Sat, 24 Aug 2013 12:03:06 +0530
Message-ID: <1377325986-18974-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377325986-18974-1-git-send-email-vgupta@synopsys.com>
References: <1377325986-18974-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.132]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joern Rennecke <joern.rennecke@embecosm.com>

For a search buffer, 2 byte aligned, strchr() was returning pointer
outside of buffer (buf - 1)

------------->8----------------
    // Input buffer (default 4 byte aigned)
    char *buffer = "1AA_";

    // actual search start (to mimick 2 byte alignment)
    char *current_line = &(buffer[2]);

    // Character to search for
    char c = 'A';

    char *c_pos = strchr(current_line, c);

    printf("%s\n", c_pos) --> 'AA_' as oppose to 'A_'
------------->8----------------

Reported-by: Anton Kolesov <Anton.Kolesov@synopsys.com>
Debugged-by: Anton Kolesov <Anton.Kolesov@synopsys.com>
Cc: <stable@vger.kernel.org> # [3.9 and 3.10]
Cc: Noam Camus <noamc@ezchip.com>
Signed-off-by: Joern Rennecke  <joern.rennecke@embecosm.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/lib/strchr-700.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arc/lib/strchr-700.S b/arch/arc/lib/strchr-700.S
index 99c1047..9c548c7 100644
--- a/arch/arc/lib/strchr-700.S
+++ b/arch/arc/lib/strchr-700.S
@@ -39,9 +39,18 @@ ARC_ENTRY strchr
 	ld.a	r2,[r0,4]
 	sub	r12,r6,r7
 	bic	r12,r12,r6
+#ifdef __LITTLE_ENDIAN__
 	and	r7,r12,r4
 	breq	r7,0,.Loop ; For speed, we want this branch to be unaligned.
 	b	.Lfound_char ; Likewise this one.
+#else
+	and	r12,r12,r4
+	breq	r12,0,.Loop ; For speed, we want this branch to be unaligned.
+	lsr_s	r12,r12,7
+	bic 	r2,r7,r6
+	b.d	.Lfound_char_b
+	and_s	r2,r2,r12
+#endif
 ; /* We require this code address to be unaligned for speed...  */
 .Laligned:
 	ld_s	r2,[r0]
@@ -95,6 +104,7 @@ ARC_ENTRY strchr
 	lsr	r7,r7,7
 
 	bic	r2,r7,r6
+.Lfound_char_b:
 	norm	r2,r2
 	sub_s	r0,r0,4
 	asr_s	r2,r2,3
-- 
1.8.1.2

