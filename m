Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaDRPXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:23:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaDRPXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:23:12 -0400
Date: Fri, 18 Apr 2014 17:23:11 +0200
From: Jiri Bohac <jbohac@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] timer: prevent overflow in apply_slack
Message-ID: <20140418152310.GA13654@midget.suse.cz>
References: <20140417194215.GA10494@midget.suse.cz>
 <alpine.DEB.2.02.1404172344420.22697@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1404172344420.22697@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On architectures with sizeof(int) < sizeof (long), the
computation of mask inside apply_slack() can be undefined if the
computed bit is > 32.

E.g. with: expires = 0xffffe6f5 and slack = 25, we get:

expires_limit = 0x20000000e
bit = 33
mask = (1 << 33) - 1  /* undefined */

On x86, mask becomes 1 and and the slack is not applied properly.
On s390, mask is -1, expires is set to 0 and the timer fires immediately.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Suggested-by: Deborah Townsend <dstownse@us.ibm.com>

diff --git a/kernel/timer.c b/kernel/timer.c
index 87bd529..4c36c91 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -838,7 +838,7 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 
 	bit = find_last_bit(&mask, BITS_PER_LONG);
 
-	mask = (1 << bit) - 1;
+	mask = (1LL << bit) - 1;
 
 	expires_limit = expires_limit & ~(mask);
 
-- 

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

