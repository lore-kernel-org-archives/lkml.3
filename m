Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbaFXPyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:54:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383AbaFXPyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:54:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shradha Shah <sshah@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 28/68] sfc: PIO:Restrict to 64bit arch and use 64-bit writes.
Date: Tue, 24 Jun 2014 11:50:47 -0400
Message-Id: <20140624154725.187405978@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Cooper <jcooper@solarflare.com>

[ Upstream commit daf37b556e437ec1ea1a597dcfeff338068380e1 ]

Fixes:ee45fd92c739
("sfc: Use TX PIO for sufficiently small packets")

The linux net driver uses memcpy_toio() in order to copy into
the PIO buffers.
Even on a 64bit machine this causes 32bit accesses to a write-
combined memory region.
There are hardware limitations that mean that only 64bit
naturally aligned accesses are safe in all cases.
Due to being write-combined memory region two 32bit accesses
may be coalesced to form a 64bit non 64bit aligned access.
Solution was to open-code the memory copy routines using pointers
and to only enable PIO for x86_64 machines.

Not tested on platforms other than x86_64 because this patch
disables the PIO feature on other platforms.
Compile-tested on x86 to ensure that works.

The WARN_ON_ONCE() code in the previous version of this patch
has been moved into the internal sfc debug driver as the
assertion was unnecessary in the upstream kernel code.

This bug fix applies to v3.13 and v3.14 stable branches.

Signed-off-by: Shradha Shah <sshah@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/io.h |    7 +++++++
 drivers/net/ethernet/sfc/tx.c |   22 +++++++++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/sfc/io.h
+++ b/drivers/net/ethernet/sfc/io.h
@@ -66,10 +66,17 @@
 #define EFX_USE_QWORD_IO 1
 #endif
 
+/* Hardware issue requires that only 64-bit naturally aligned writes
+ * are seen by hardware. Its not strictly necessary to restrict to
+ * x86_64 arch, but done for safety since unusual write combining behaviour
+ * can break PIO.
+ */
+#ifdef CONFIG_X86_64
 /* PIO is a win only if write-combining is possible */
 #ifdef ARCH_HAS_IOREMAP_WC
 #define EFX_USE_PIO 1
 #endif
+#endif
 
 #ifdef EFX_USE_QWORD_IO
 static inline void _efx_writeq(struct efx_nic *efx, __le64 value,
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -189,6 +189,18 @@ struct efx_short_copy_buffer {
 	u8 buf[L1_CACHE_BYTES];
 };
 
+/* Copy in explicit 64-bit writes. */
+static void efx_memcpy_64(void __iomem *dest, void *src, size_t len)
+{
+	u64 *src64 = src;
+	u64 __iomem *dest64 = dest;
+	size_t l64 = len / 8;
+	size_t i;
+
+	for (i = 0; i < l64; i++)
+		writeq(src64[i], &dest64[i]);
+}
+
 /* Copy to PIO, respecting that writes to PIO buffers must be dword aligned.
  * Advances piobuf pointer. Leaves additional data in the copy buffer.
  */
@@ -198,7 +210,7 @@ static void efx_memcpy_toio_aligned(stru
 {
 	int block_len = len & ~(sizeof(copy_buf->buf) - 1);
 
-	memcpy_toio(*piobuf, data, block_len);
+	efx_memcpy_64(*piobuf, data, block_len);
 	*piobuf += block_len;
 	len -= block_len;
 
@@ -230,7 +242,7 @@ static void efx_memcpy_toio_aligned_cb(s
 		if (copy_buf->used < sizeof(copy_buf->buf))
 			return;
 
-		memcpy_toio(*piobuf, copy_buf->buf, sizeof(copy_buf->buf));
+		efx_memcpy_64(*piobuf, copy_buf->buf, sizeof(copy_buf->buf));
 		*piobuf += sizeof(copy_buf->buf);
 		data += copy_to_buf;
 		len -= copy_to_buf;
@@ -245,7 +257,7 @@ static void efx_flush_copy_buffer(struct
 {
 	/* if there's anything in it, write the whole buffer, including junk */
 	if (copy_buf->used)
-		memcpy_toio(piobuf, copy_buf->buf, sizeof(copy_buf->buf));
+		efx_memcpy_64(piobuf, copy_buf->buf, sizeof(copy_buf->buf));
 }
 
 /* Traverse skb structure and copy fragments in to PIO buffer.
@@ -304,8 +316,8 @@ efx_enqueue_skb_pio(struct efx_tx_queue
 		 */
 		BUILD_BUG_ON(L1_CACHE_BYTES >
 			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
-		memcpy_toio(tx_queue->piobuf, skb->data,
-			    ALIGN(skb->len, L1_CACHE_BYTES));
+		efx_memcpy_64(tx_queue->piobuf, skb->data,
+			      ALIGN(skb->len, L1_CACHE_BYTES));
 	}
 
 	EFX_POPULATE_QWORD_5(buffer->option,


