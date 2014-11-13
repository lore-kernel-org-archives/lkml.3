Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbaKMSJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:09:41 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57389 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933491AbaKMSJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:09:39 -0500
From: Furquan Shaikh <furquan@google.com>
To: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, olofj@google.com, adurbin@google.com,
        Furquan Shaikh <furquan@google.com>
Subject: [PATCH] pstore: Use memcpy_toio instead of memcpy
Date: Thu, 13 Nov 2014 10:09:18 -0800
Message-Id: <1415902158-18769-1-git-send-email-furquan@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

persistent_ram_update uses vmap / iomap based on whether the buffer is in memory
region or reserved region. However, both map it as non-cacheable memory. For
armv8 specifically, non-cacheable mapping requests use a memory type that has to
be accessed aligned to the request size. memcpy() doesn't guarantee that.

Signed-off-by: Furquan Shaikh <furquan@google.com>
---
 fs/pstore/ram_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 9d7b9a8..cfbc5e4 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -299,7 +299,7 @@ static void notrace persistent_ram_update(struct persistent_ram_zone *prz,
 	const void *s, unsigned int start, unsigned int count)
 {
 	struct persistent_ram_buffer *buffer = prz->buffer;
-	memcpy(buffer->data + start, s, count);
+	memcpy_toio(buffer->data + start, s, count);
 	persistent_ram_update_ecc(prz, start, count);
 }
 
-- 
2.1.0.rc2.206.gedb03e5

