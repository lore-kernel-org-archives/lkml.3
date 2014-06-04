Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbaFEAqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:46:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaFDXVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Deborah Townsend <dstownse@us.ibm.com>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.14 028/228] timer: Prevent overflow in apply_slack
Date: Wed,  4 Jun 2014 16:20:57 -0700
Message-Id: <20140604232348.986120421@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Bohac <jbohac@suse.cz>

commit 98a01e779f3c66b0b11cd7e64d531c0e41c95762 upstream.

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
Link: http://lkml.kernel.org/r/20140418152310.GA13654@midget.suse.cz
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -822,7 +822,7 @@ unsigned long apply_slack(struct timer_l
 
 	bit = find_last_bit(&mask, BITS_PER_LONG);
 
-	mask = (1 << bit) - 1;
+	mask = (1UL << bit) - 1;
 
 	expires_limit = expires_limit & ~(mask);
 


