Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab3FSDAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 23:00:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:19253 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab3FSDAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 23:00:06 -0400
X-Spam-Score: -100.8
Message-ID: <51C11E83.8030902@asianux.com>
Date: Wed, 19 Jun 2013 10:59:15 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of spin_lock
 + local_irq_save, especially when CONFIG_LOCKDEP not defined
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When CONFIG_LOCKDEP is not defined, spin_lock_irqsave() is not equal to
spin_lock() + local_irq_save().

In __mod_timer(), After call spin_lock_irqsave() with 'base->lock' in
lock_timer_base(), it may use spin_lock() with the 'new_base->lock'.

It may let original call do_raw_spin_lock_flags() with 'base->lock',
but new  call LOCK_CONTENDED() with 'new_base->lock'.

In fact, we need both of them call do_raw_spin_lock_flags(), so use
spin_lock_irqsave() instead of spin_lock() + local_irq_save().


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/timer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index aa8b964..2550a62 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -754,9 +754,9 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 		if (likely(base->running_timer != timer)) {
 			/* See the comment in lock_timer_base() */
 			timer_set_base(timer, NULL);
-			spin_unlock(&base->lock);
+			spin_unlock_irqrestore(&base->lock, flags);
 			base = new_base;
-			spin_lock(&base->lock);
+			spin_lock_irqsave(&base->lock, flags);
 			timer_set_base(timer, base);
 		}
 	}
-- 
1.7.7.6
