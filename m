Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaAPX1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:27:24 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:55428 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaAPX1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:27:22 -0500
Date: Thu, 16 Jan 2014 15:26:48 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Ming Lei <tom.leiming@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shaohua Li <shli@fusionio.com>, Jens Axboe <axboe@kernel.dk>,
        Fan Du <fan.du@windriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] percpu_counter: unbreak __percpu_counter_add()
Message-ID: <alpine.LSU.2.11.1401161521340.1084@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 74e72f894d56 ("lib/percpu_counter.c: fix __percpu_counter_add()")
looked very plausible, but its arithmetic was badly wrong: obvious once
you see the fix, but maddening to get there from the weird tmpfs ENOSPCs

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 lib/percpu_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.13-rc8+/lib/percpu_counter.c	2014-01-15 09:53:27.768111792 -0800
+++ linux/lib/percpu_counter.c	2014-01-16 14:58:54.156555308 -0800
@@ -82,7 +82,7 @@ void __percpu_counter_add(struct percpu_
 		unsigned long flags;
 		raw_spin_lock_irqsave(&fbc->lock, flags);
 		fbc->count += count;
-		 __this_cpu_sub(*fbc->counters, count);
+		__this_cpu_sub(*fbc->counters, count - amount);
 		raw_spin_unlock_irqrestore(&fbc->lock, flags);
 	} else {
 		this_cpu_add(*fbc->counters, amount);
