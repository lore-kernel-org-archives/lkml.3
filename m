Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765875Ab3DJDI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:08:58 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:58545 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3DJDIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:08:43 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 3/3] pstore/ram: avoid atomic accesses for ioremapped regions
Date: Tue,  9 Apr 2013 22:08:17 -0500
Message-Id: <1365563297-12480-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365563297-12480-1-git-send-email-robherring2@gmail.com>
References: <1365563297-12480-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

For persistent RAM outside of main memory, the memory may have limitations
on supported accesses. For internal RAM on highbank platform exclusive
accesses are not supported and will hang the system. So atomic_cmpxchg
cannot be used. This commit uses spinlock protection for buffer size and
start updates on ioremapped regions instead.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
---
 fs/pstore/ram_core.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index e126d9f..97e640b 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -46,7 +46,7 @@ static inline size_t buffer_start(struct persistent_ram_zone *prz)
 }
 
 /* increase and wrap the start pointer, returning the old value */
-static inline size_t buffer_start_add(struct persistent_ram_zone *prz, size_t a)
+static size_t buffer_start_add_atomic(struct persistent_ram_zone *prz, size_t a)
 {
 	int old;
 	int new;
@@ -62,7 +62,7 @@ static inline size_t buffer_start_add(struct persistent_ram_zone *prz, size_t a)
 }
 
 /* increase the size counter until it hits the max size */
-static inline void buffer_size_add(struct persistent_ram_zone *prz, size_t a)
+static void buffer_size_add_atomic(struct persistent_ram_zone *prz, size_t a)
 {
 	size_t old;
 	size_t new;
@@ -78,6 +78,53 @@ static inline void buffer_size_add(struct persistent_ram_zone *prz, size_t a)
 	} while (atomic_cmpxchg(&prz->buffer->size, old, new) != old);
 }
 
+static DEFINE_RAW_SPINLOCK(buffer_lock);
+
+/* increase and wrap the start pointer, returning the old value */
+static size_t buffer_start_add_locked(struct persistent_ram_zone *prz, size_t a)
+{
+	int old;
+	int new;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&buffer_lock, flags);
+
+	old = atomic_read(&prz->buffer->start);
+	new = old + a;
+	while (unlikely(new > prz->buffer_size))
+		new -= prz->buffer_size;
+	atomic_set(&prz->buffer->start, new);
+
+	raw_spin_unlock_irqrestore(&buffer_lock, flags);
+
+	return old;
+}
+
+/* increase the size counter until it hits the max size */
+static void buffer_size_add_locked(struct persistent_ram_zone *prz, size_t a)
+{
+	size_t old;
+	size_t new;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&buffer_lock, flags);
+
+	old = atomic_read(&prz->buffer->size);
+	if (old == prz->buffer_size)
+		goto exit;
+
+	new = old + a;
+	if (new > prz->buffer_size)
+		new = prz->buffer_size;
+	atomic_set(&prz->buffer->size, new);
+
+exit:
+	raw_spin_unlock_irqrestore(&buffer_lock, flags);
+}
+
+static size_t (*buffer_start_add)(struct persistent_ram_zone *, size_t) = buffer_start_add_atomic;
+static void (*buffer_size_add)(struct persistent_ram_zone *, size_t) = buffer_size_add_atomic;
+
 static void notrace persistent_ram_encode_rs8(struct persistent_ram_zone *prz,
 	uint8_t *data, size_t len, uint8_t *ecc)
 {
@@ -364,6 +411,9 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size)
 		return NULL;
 	}
 
+	buffer_start_add = buffer_start_add_locked;
+	buffer_size_add = buffer_size_add_locked;
+
 	return ioremap_wc(start, size);
 }
 
-- 
1.7.10.4

