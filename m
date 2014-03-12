Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaCLNY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:24:58 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41110 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbaCLNYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:24:50 -0400
Date: Wed, 12 Mar 2014 21:24:44 +0800
From: Liu Shuo <shuox.liu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: [PATCH 1/2] pstore: fix buffer overflow while write offset equal to
 buffer size
Message-ID: <20140312132441.GA29079@shuo-gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-Mailer: Mutt 1.5.x/OS X 10.7.x
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu ShuoX <shuox.liu@intel.com>

In case new offset is equal to prz->buffer_size, it won't wrap at this
time and will return old(overflow) value next time.

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 fs/pstore/ram_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index de272d4..ff7e3d4 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -54,7 +54,7 @@ static size_t buffer_start_add_atomic(struct persistent_ram_zone *prz, size_t a)
 	do {
 		old = atomic_read(&prz->buffer->start);
 		new = old + a;
-		while (unlikely(new > prz->buffer_size))
+		while (unlikely(new >= prz->buffer_size))
 			new -= prz->buffer_size;
 	} while (atomic_cmpxchg(&prz->buffer->start, old, new) != old);
 
@@ -91,7 +91,7 @@ static size_t buffer_start_add_locked(struct persistent_ram_zone *prz, size_t a)
 
 	old = atomic_read(&prz->buffer->start);
 	new = old + a;
-	while (unlikely(new > prz->buffer_size))
+	while (unlikely(new >= prz->buffer_size))
 		new -= prz->buffer_size;
 	atomic_set(&prz->buffer->start, new);
 
-- 
1.8.3.2



