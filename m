Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843AbaD3Lsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:48:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48854 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758496AbaD3Lsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:48:53 -0400
Date: Wed, 30 Apr 2014 04:48:31 -0700
From: tip-bot for Jiri Bohac <tipbot@zytor.com>
Message-ID: <tip-98a01e779f3c66b0b11cd7e64d531c0e41c95762@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, dstownse@us.ibm.com, hpa@zytor.com,
        mingo@kernel.org, jbohac@suse.cz, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, dstownse@us.ibm.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, jbohac@suse.cz
In-Reply-To: <20140418152310.GA13654@midget.suse.cz>
References: <20140418152310.GA13654@midget.suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timer: Prevent overflow in apply_slack
Git-Commit-ID: 98a01e779f3c66b0b11cd7e64d531c0e41c95762
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98a01e779f3c66b0b11cd7e64d531c0e41c95762
Gitweb:     http://git.kernel.org/tip/98a01e779f3c66b0b11cd7e64d531c0e41c95762
Author:     Jiri Bohac <jbohac@suse.cz>
AuthorDate: Fri, 18 Apr 2014 17:23:11 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 30 Apr 2014 13:46:17 +0200

timer: Prevent overflow in apply_slack

On architectures with sizeof(int) < sizeof (long), the
computation of mask inside apply_slack() can be undefined if the
computed bit is > 32.

E.g. with: expires = 0xffffe6f5 and slack = 25, we get:

expires_limit = 0x20000000e
bit = 33
mask = (1 << 33) - 1  /* undefined */

On x86, mask becomes 1 and and the slack is not applied properly.
On s390, mask is -1, expires is set to 0 and the timer fires immediately.

Use 1UL << bit to solve that issue.

Suggested-by: Deborah Townsend <dstownse@us.ibm.com>
Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20140418152310.GA13654@midget.suse.cz
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 87bd529..3bb01a3 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -838,7 +838,7 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 
 	bit = find_last_bit(&mask, BITS_PER_LONG);
 
-	mask = (1 << bit) - 1;
+	mask = (1UL << bit) - 1;
 
 	expires_limit = expires_limit & ~(mask);
 
