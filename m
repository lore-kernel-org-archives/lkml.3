Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbaJCWYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:24:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbaJCWYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Hosie <simon.hosie@arm.com>, Robin Murphy <robin.murphy@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.10 067/143] ARM: 8165/1: alignment: dont break misaligned NEON load/store
Date: Fri,  3 Oct 2014 14:34:22 -0700
Message-Id: <20141003213316.527764759@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 5ca918e5e3f9df4634077c06585c42bc6a8d699a upstream.

The alignment fixup incorrectly decodes faulting ARM VLDn/VSTn
instructions (where the optional alignment hint is given but incorrect)
as LDR/STR, leading to register corruption. Detect these and correctly
treat them as unhandled, so that userspace gets the fault it expects.

Reported-by: Simon Hosie <simon.hosie@arm.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/alignment.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -39,6 +39,7 @@
  * This code is not portable to processors with late data abort handling.
  */
 #define CODING_BITS(i)	(i & 0x0e000000)
+#define COND_BITS(i)	(i & 0xf0000000)
 
 #define LDST_I_BIT(i)	(i & (1 << 26))		/* Immediate constant	*/
 #define LDST_P_BIT(i)	(i & (1 << 24))		/* Preindex		*/
@@ -812,6 +813,8 @@ do_alignment(unsigned long addr, unsigne
 		break;
 
 	case 0x04000000:	/* ldr or str immediate */
+		if (COND_BITS(instr) == 0xf0000000) /* NEON VLDn, VSTn */
+			goto bad;
 		offset.un = OFFSET_BITS(instr);
 		handler = do_alignment_ldrstr;
 		break;


