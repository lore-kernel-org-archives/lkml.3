Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbaKLDTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:19:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933650AbaKLBfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:35:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 3.17 300/319] powerpc/powernv: Properly fix LPC debugfs endianness
Date: Wed, 12 Nov 2014 10:17:18 +0900
Message-Id: <20141112011042.496795059@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 325e4114043469e5f9923d902b4d30bcc2be8163 upstream.

Endian is hard, especially when I designed a stupid FW interface, and
I should know better... oh well, this is attempt #2 at fixing this
properly. This time it seems to work with all access sizes and I
can run my flashing tool (which exercises all sort of access sizes
and types to access the SPI controller in the BMC) just fine.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/opal-lpc.c |   59 ++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

--- a/arch/powerpc/platforms/powernv/opal-lpc.c
+++ b/arch/powerpc/platforms/powernv/opal-lpc.c
@@ -216,14 +216,54 @@ static ssize_t lpc_debug_read(struct fil
 				   &data, len);
 		if (rc)
 			return -ENXIO;
+
+		/*
+		 * Now there is some trickery with the data returned by OPAL
+		 * as it's the desired data right justified in a 32-bit BE
+		 * word.
+		 *
+		 * This is a very bad interface and I'm to blame for it :-(
+		 *
+		 * So we can't just apply a 32-bit swap to what comes from OPAL,
+		 * because user space expects the *bytes* to be in their proper
+		 * respective positions (ie, LPC position).
+		 *
+		 * So what we really want to do here is to shift data right
+		 * appropriately on a LE kernel.
+		 *
+		 * IE. If the LPC transaction has bytes B0, B1, B2 and B3 in that
+		 * order, we have in memory written to by OPAL at the "data"
+		 * pointer:
+		 *
+		 *               Bytes:      OPAL "data"   LE "data"
+		 *   32-bit:   B0 B1 B2 B3   B0B1B2B3      B3B2B1B0
+		 *   16-bit:   B0 B1         0000B0B1      B1B00000
+		 *    8-bit:   B0            000000B0      B0000000
+		 *
+		 * So a BE kernel will have the leftmost of the above in the MSB
+		 * and rightmost in the LSB and can just then "cast" the u32 "data"
+		 * down to the appropriate quantity and write it.
+		 *
+		 * However, an LE kernel can't. It doesn't need to swap because a
+		 * load from data followed by a store to user are going to preserve
+		 * the byte ordering which is the wire byte order which is what the
+		 * user wants, but in order to "crop" to the right size, we need to
+		 * shift right first.
+		 */
 		switch(len) {
 		case 4:
 			rc = __put_user((u32)data, (u32 __user *)ubuf);
 			break;
 		case 2:
+#ifdef __LITTLE_ENDIAN__
+			data >>= 16;
+#endif
 			rc = __put_user((u16)data, (u16 __user *)ubuf);
 			break;
 		default:
+#ifdef __LITTLE_ENDIAN__
+			data >>= 24;
+#endif
 			rc = __put_user((u8)data, (u8 __user *)ubuf);
 			break;
 		}
@@ -263,12 +303,31 @@ static ssize_t lpc_debug_write(struct fi
 			else if (todo > 1 && (pos & 1) == 0)
 				len = 2;
 		}
+
+		/*
+		 * Similarly to the read case, we have some trickery here but
+		 * it's different to handle. We need to pass the value to OPAL in
+		 * a register whose layout depends on the access size. We want
+		 * to reproduce the memory layout of the user, however we aren't
+		 * doing a load from user and a store to another memory location
+		 * which would achieve that. Here we pass the value to OPAL via
+		 * a register which is expected to contain the "BE" interpretation
+		 * of the byte sequence. IE: for a 32-bit access, byte 0 should be
+		 * in the MSB. So here we *do* need to byteswap on LE.
+		 *
+		 *           User bytes:    LE "data"  OPAL "data"
+		 *  32-bit:  B0 B1 B2 B3    B3B2B1B0   B0B1B2B3
+		 *  16-bit:  B0 B1          0000B1B0   0000B0B1
+		 *   8-bit:  B0             000000B0   000000B0
+		 */
 		switch(len) {
 		case 4:
 			rc = __get_user(data, (u32 __user *)ubuf);
+			data = cpu_to_be32(data);
 			break;
 		case 2:
 			rc = __get_user(data, (u16 __user *)ubuf);
+			data = cpu_to_be16(data);
 			break;
 		default:
 			rc = __get_user(data, (u8 __user *)ubuf);


