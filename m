Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaJ2InI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:43:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31723 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbaJ2InF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:43:05 -0400
Date: Wed, 29 Oct 2014 11:42:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] hangcheck-timer: cleanup casting in hangcheck_init()
Message-ID: <20141029084250.GA8939@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit addition "(hangcheck_margin + hangcheck_tick)" could
potentially overflow.  It triggers a static checker warning to have an
overflowed addition followed by a no-op cast.  I have moved the cast so
that the addition can't overflow.

Also I removed the unneeded cast on the following line since both
"hangcheck_tsc_margin" and "TIMER_FREQ" are already 64 bit types.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/char/hangcheck-timer.c b/drivers/char/hangcheck-timer.c
index ebc4c73..a7c5c59 100644
--- a/drivers/char/hangcheck-timer.c
+++ b/drivers/char/hangcheck-timer.c
@@ -168,8 +168,8 @@ static int __init hangcheck_init(void)
 	printk("Hangcheck: starting hangcheck timer %s (tick is %d seconds, margin is %d seconds).\n",
 	       VERSION_STR, hangcheck_tick, hangcheck_margin);
 	hangcheck_tsc_margin =
-		(unsigned long long)(hangcheck_margin + hangcheck_tick);
-	hangcheck_tsc_margin *= (unsigned long long)TIMER_FREQ;
+		(unsigned long long)hangcheck_margin + hangcheck_tick;
+	hangcheck_tsc_margin *= TIMER_FREQ;
 
 	hangcheck_tsc = ktime_get_ns();
 	mod_timer(&hangcheck_ticktock, jiffies + (hangcheck_tick*HZ));
