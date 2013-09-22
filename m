Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3IVUky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:40:54 -0400
Received: from imap.thunk.org ([74.207.234.97]:35979 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab3IVUjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:39:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: hpa@zytor.com, joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC 06/12] random: optimize spinlock use in add_device_randomness()
Date: Sun, 22 Sep 2013 16:38:52 -0400
Message-Id: <1379882338-7209-7-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1379882338-7209-1-git-send-email-tytso@mit.edu>
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point taking the spinlock twice for each call to mix_pool_bytes();
better to take it once for each pool where we add entropy.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 391b05a..9564144 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -711,10 +711,15 @@ void add_device_randomness(const void *buf, unsigned int size)
 	unsigned long flags;
 
 	trace_add_device_randomness(size, _RET_IP_);
-	mix_pool_bytes(&input_pool, buf, size, NULL);
-	mix_pool_bytes(&input_pool, &time, sizeof(time), NULL);
-	mix_pool_bytes(&nonblocking_pool, buf, size, NULL);
-	mix_pool_bytes(&nonblocking_pool, &time, sizeof(time), NULL);
+	spin_lock_irqsave(&input_pool.lock, flags);
+	_mix_pool_bytes(&input_pool, buf, size, NULL);
+	_mix_pool_bytes(&input_pool, &time, sizeof(time), NULL);
+	spin_unlock_irqrestore(&input_pool.lock, flags);
+
+	spin_lock_irqsave(&nonblocking_pool.lock, flags);
+	_mix_pool_bytes(&nonblocking_pool, buf, size, NULL);
+	_mix_pool_bytes(&nonblocking_pool, &time, sizeof(time), NULL);
+	spin_unlock_irqrestore(&nonblocking_pool.lock, flags);
 }
 EXPORT_SYMBOL(add_device_randomness);
 
-- 
1.7.12.rc0.22.gcdd159b

