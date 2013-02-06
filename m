Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362Ab3BFUKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:10:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758232Ab3BFUJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:09:15 -0500
Date: Wed, 6 Feb 2013 15:08:33 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aquini@redhat.com, eric.dumazet@gmail.com, lwoodman@redhat.com,
        knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: [PATCH -v5 6/5] x86,smp: add debugging code to track spinlock delay
 value
Message-ID: <20130206150833.34d08bd3@cuia.bos.redhat.com>
In-Reply-To: <20130206150311.19cd1e52@cuia.bos.redhat.com>
References: <20130206150311.19cd1e52@cuia.bos.redhat.com>
Organization: Red Hat, Inc
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
---
 arch/x86/kernel/smp.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index fbc5ff3..660f0ec 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -146,6 +146,8 @@ static DEFINE_PER_CPU(struct delay_entry [1 << DELAY_HASH_SHIFT], spinlock_delay
 	},
 };
 
+static DEFINE_PER_CPU(u32, maxdelay);
+
 /*
  * Wait on a congested ticket spinlock. Many spinlocks are embedded in
  * data structures; having many CPUs pounce on the cache line with the
@@ -209,6 +211,12 @@ void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
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
