Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3H0BRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:17:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3H0BHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Noam Camus <noamc@ezchip.com>,
        Joern Rennecke <joern.rennecke@embecosm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 37/74] ARC: [lib] strchr breakage in Big-endian configuration
Date: Mon, 26 Aug 2013 18:08:35 -0700
Message-Id: <20130827010432.388698420@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joern Rennecke <joern.rennecke@embecosm.com>

commit b0f55f2a1a295c364be012e82dbab079a2454006 upstream.

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
Cc: Noam Camus <noamc@ezchip.com>
Signed-off-by: Joern Rennecke  <joern.rennecke@embecosm.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/lib/strchr-700.S |   10 ++++++++++
 1 file changed, 10 insertions(+)

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


