Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbbA1UU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:20:26 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:30071 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbbA1UUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:20:22 -0500
From: HuKeping <hukeping@huawei.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <matt.fleming@intel.com>,
        <cbouatmailru@gmail.com>, <ccross@android.com>,
        <keescook@chromium.org>, <tony.luck@intel.com>,
        <stable@vger.kernel.org>, <rob.herring@calxeda.com>, <cxie@redhat.com>,
        <sdu.liu@huawei.com>, <wangnan0@huawei.com>, <peifeiyue@huawei.com>
Subject: [PATCH v3 1/2] pstore/ram: avoid atomic accesses for ioremapped regions
Date: Wed, 28 Jan 2015 16:06:25 +0800
Message-ID: <1422432386-15761-2-git-send-email-hukeping@huawei.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1422432386-15761-1-git-send-email-hukeping@huawei.com>
References: <1422432386-15761-1-git-send-email-hukeping@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Commit 0405a5cec3406f19e69da07c8111a6bf1088ac29 upstream.

For persistent RAM outside of main memory, the memory may have limitations
on supported accesses. For internal RAM on highbank platform exclusive
accesses are not supported and will hang the system. So atomic_cmpxchg
cannot be used. This commit uses spinlock protection for buffer size and
start updates on ioremapped regions instead.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Anton Vorontsov <anton@enomsg.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
[hkp: Backported to 3.10: adjust context]
Signed-off-by: HuKeping <hukeping@huawei.com>

---
 fs/pstore/ram_core.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 6ff9755..bda61a7 100644
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
@@ -379,6 +426,9 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size,
 		return NULL;
 	}
 
+	buffer_start_add = buffer_start_add_locked;
+	buffer_size_add = buffer_size_add_locked;
+
 	if (memtype)
 		va = ioremap(start, size);
 	else
-- 
1.8.5.5

