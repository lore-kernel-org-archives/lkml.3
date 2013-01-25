Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab3AYTVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 14:21:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757340Ab3AYTUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 14:20:36 -0500
Date: Fri, 25 Jan 2013 14:20:03 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: [DEBUG PATCH -v4 6/5] x86,smp: add debugging code to track spinlock
 delay value
Message-ID: <20130125142003.6583325c@annuminas.surriel.com>
In-Reply-To: <20130125140553.060b8ced@annuminas.surriel.com>
References: <20130125140553.060b8ced@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86,smp: add debugging code to track spinlock delay value

From: Eric Dumazet <eric.dumazet@gmail.com>

This code prints out the maximum spinlock delay value and the
backtrace that pushed it that far.

On systems with serial consoles, the act of printing can cause
the spinlock delay value to explode. It can still be useful as
a debugging tool, but is probably too verbose to merge upstream
in this form.

Not-signed-off-by: Rik van Riel <riel@redhat.com>
Not-signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>


diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 8908dfc..f973fc9 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -165,6 +165,8 @@ static DEFINE_PER_CPU(struct delay_entry [1 << DELAY_HASH_SHIFT], spinlock_delay
 	},
 };
 
+static DEFINE_PER_CPU(u32, maxdelay);
+
 void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 {
 	__ticket_t head = inc.head, ticket = inc.tail;
@@ -210,6 +212,12 @@ void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 	}
 	ent->hash = hash;
 	ent->delay = delay;
+
+	if (__this_cpu_read(maxdelay) * 4 < delay * 3) {
+		pr_err("cpu %d lock %p delay %d\n", smp_processor_id(), lock, delay>>DELAY_SHIFT);
+		__this_cpu_write(maxdelay, delay);
+		WARN_ON(1);
+	}
 }
 
 /*

