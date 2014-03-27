Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbaC0Ln6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:43:58 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:46393 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaC0Ln4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:43:56 -0400
X-AuditID: 85900ec0-d0927b9000001514-cc-53340eebcfd3
Subject: [PATCH] random: give up adding randomness to the entropy pool when
 block devices are busy
From: Kazuya Hisaki <kazuya.hisaki.bx@hitachi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Date: Thu, 27 Mar 2014 20:43:20 +0900
Message-ID: <20140327114320.4995.78617.stgit@kitayama.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This gives up adding randomness to the entropy pool when block devices
are busy, to avoid lock contention in I/O intensive situation.

Currently randomness is added to the entropy pool for each 4096 I/O
completion, and holds a global spinlock during its process.
Contention for the spinlock occurs In I/O intensive situation that
many cores process I/O completions, even each core processes
completion for different block device.

This just replaces spin_lock_irqsave() in mix_pool_bytes()
with spin_trylock_irqsave(), and gives up adding randomness
when trylock is failed.
And, it moves trace_mix_pool_bytes() after lock, to trace
events only where addition of randomness is executed.

Thank you,


Signed-off-by: Kazuya Hisaki <kazuya.hisaki.bx@hitachi.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
---
 drivers/char/random.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 429b75b..d2603f8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -545,8 +545,9 @@ static void mix_pool_bytes(struct entropy_store *r, const void *in,
 {
 	unsigned long flags;
 
+	if (!spin_trylock_irqsave(&r->lock, flags))
+		return;
 	trace_mix_pool_bytes(r->name, nbytes, _RET_IP_);
-	spin_lock_irqsave(&r->lock, flags);
 	_mix_pool_bytes(r, in, nbytes, out);
 	spin_unlock_irqrestore(&r->lock, flags);
 }

