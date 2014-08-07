Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbaHGDqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 23:46:32 -0400
Received: from mail-yk0-f196.google.com ([209.85.160.196]:41665 "EHLO
	mail-yk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783AbaHGDqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 23:46:30 -0400
From: Nick Krause <xerofoiify@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@fr.ibm.com>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] powerpc: Fix warnings about right shift count
Date: Thu,  7 Aug 2014 05:46:38 +0200
Message-Id: <1407383199-7919-1-git-send-email-xerofoiify@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warnings like the following using upper_32_bits(), discussed after mail with
someone on kernelnewbies

arch/powerpc/boot/addnote.c:183:3: warning: right shift count >= width of type
arch/powerpc/boot/addnote.c:188:3: warning: right shift count >= width of type
arch/powerpc/boot/addnote.c:206:3: warning: right shift count >= width of type
arch/powerpc/boot/addnote.c:211:3: warning: right shift count >= width of type

Signed-off-by: Nick Krause <xerofoify@gmail.com>
---
 arch/powerpc/boot/addnote.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/addnote.c b/arch/powerpc/boot/addnote.c
index 9d9f6f3..4611c12 100644
--- a/arch/powerpc/boot/addnote.c
+++ b/arch/powerpc/boot/addnote.c
@@ -72,7 +72,7 @@ static int e_class = ELFCLASS32;
 #define PUT_16BE(off, v)(buf[off] = ((v) >> 8) & 0xff, \
 			 buf[(off) + 1] = (v) & 0xff)
 #define PUT_32BE(off, v)(PUT_16BE((off), (v) >> 16L), PUT_16BE((off) + 2, (v)))
-#define PUT_64BE(off, v)((PUT_32BE((off), (v) >> 32L), \
+#define PUT_64BE(off, v)((PUT_32BE((off), upper_32_bits(v)), \
 			  PUT_32BE((off) + 4, (v))))
 
 #define GET_16LE(off)	((buf[off]) + (buf[(off)+1] << 8))
@@ -82,7 +82,8 @@ static int e_class = ELFCLASS32;
 #define PUT_16LE(off, v) (buf[off] = (v) & 0xff, \
 			  buf[(off) + 1] = ((v) >> 8) & 0xff)
 #define PUT_32LE(off, v) (PUT_16LE((off), (v)), PUT_16LE((off) + 2, (v) >> 16L))
-#define PUT_64LE(off, v) (PUT_32LE((off), (v)), PUT_32LE((off) + 4, (v) >> 32L))
+#define PUT_64LE(off, v) (PUT_32LE((off), (v)), PUT_32LE((off) + 4, \
+						upper_32_bits(v)))
 
 #define GET_16(off)	(e_data == ELFDATA2MSB ? GET_16BE(off) : GET_16LE(off))
 #define GET_32(off)	(e_data == ELFDATA2MSB ? GET_32BE(off) : GET_32LE(off))
-- 
2.0.1

