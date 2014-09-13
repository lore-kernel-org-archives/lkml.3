Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaIMUse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 16:48:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:54487 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaIMUsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 16:48:32 -0400
Date: Sat, 13 Sep 2014 22:48:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] futex fix for 3.17
Message-ID: <alpine.DEB.2.10.1409132243220.23397@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest locking-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking-urgent-for-linus

A oneliner bugfix for the jinxed futex code:

- Drop has bucket lock in the error exit path. I really could slap
  myself for intruducing that bug while fixing all the other horror in
  that code three month ago ...

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      futex: Unlock hb->lock in futex_wait_requeue_pi() error path


 kernel/futex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index d3a9d946d0b7..815d7af2ffe8 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2592,6 +2592,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	 * shared futexes. We need to compare the keys:
 	 */
 	if (match_futex(&q.key, &key2)) {
+		queue_unlock(hb);
 		ret = -EINVAL;
 		goto out_put_keys;
 	}
