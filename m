Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaGPVGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:06:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:59928 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbaGPVFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:23 -0400
Message-Id: <20140716205057.481379409@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [patch V2 62/64] seqcount: Add raw_write_seqcount_latch()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=seqcount-add-raw-write-seqcount-latch.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

For NMI safe access to clock monotonic we use the seqcount LSB as
index of a timekeeper array. The update sequence looks like this:

      smp_wmb();      <- prior stores to a[1]
      seq++;
      smp_wmb();      <- seq increment before update of a[0]
      update(a[0]);
      smp_wmb();      <- update of a[0]	
      seq++;
      smp_wmb();      <- seq increment before update of a[1]	
      update(a[1]);

To avoid open coded barriers, provide a helper function.

[ tglx: Split out of a combo patch against the first implementation of
  	the NMI safe accessor ]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/seqlock.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: tip/include/linux/seqlock.h
===================================================================
--- tip.orig/include/linux/seqlock.h
+++ tip/include/linux/seqlock.h
@@ -236,6 +236,17 @@ static inline void raw_write_seqcount_en
 }
 
 /*
+ * raw_write_seqcount_latch - redirect readers to even/odd copy
+ * @s: pointer to seqcount_t
+ */
+static inline void raw_write_seqcount_latch(seqcount_t *s)
+{
+       smp_wmb();      /* prior stores before incrementing "sequence" */
+       s->sequence++;
+       smp_wmb();      /* increment "sequence" before following stores */
+}
+
+/*
  * Sequence counter only version assumes that callers are using their
  * own mutexing.
  */


