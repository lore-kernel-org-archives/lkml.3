Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaIOQEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:04:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbaIOQD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:03:57 -0400
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch, mb@bu3sch.de,
        mpm@selenic.com, rusty@rustcorp.com.au, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] hw_random: fix stuck in catting hwrng attributes
Date: Tue, 16 Sep 2014 00:02:28 +0800
Message-Id: <1410796949-2221-3-git-send-email-akong@redhat.com>
In-Reply-To: <1410796949-2221-1-git-send-email-akong@redhat.com>
References: <1410796949-2221-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started a QEMU (non-smp) guest with one virtio-rng device, and read
random data from /dev/hwrng by dd:

 # dd if=/dev/hwrng of=/dev/null &

In the same time, if I check hwrng attributes from sysfs by cat:

 # cat /sys/class/misc/hw_random/rng_*

The cat process always gets stuck with slow backend (5 k/s), if we
use a quick backend (1.2 M/s), the cat process will cost 1 to 2
minutes. The stuck doesn't exist for smp guest.

Reading syscall enters kernel and call rng_dev_read(), it's user
context. We used need_resched() to check if other tasks need to
be run, but it almost always return false, and re-hold the mutex
lock. The attributes accessing process always fails to hold the
lock, so the cat gets stuck.

User context doesn't allow other user contexts run on that CPU,
unless the kernel code sleeps for some reason. This is why the
need_reshed() always return false here.

This patch removed need_resched() and always schedule other tasks
then other tasks can have chance to hold the lock and execute
protected code.

Signed-off-by: Amos Kong <akong@redhat.com>
---
 drivers/char/hw_random/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index c591d7e..263a370 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -195,8 +195,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 
 		mutex_unlock(&rng_mutex);
 
-		if (need_resched())
-			schedule_timeout_interruptible(1);
+		schedule_timeout_interruptible(1);
 
 		if (signal_pending(current)) {
 			err = -ERESTARTSYS;
-- 
1.9.3

