Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaGKNpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:45:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:56312 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbaGKNpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:45:19 -0400
Message-Id: <20140711133709.765391794@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:45:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch 53/55] seqcount: Provide raw_read_seqcount()
References: <20140711133623.530368377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=seqcount-add-raw-read-seqcount.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

raw_read_seqcount opens a read critical section of the given seqcount
without any lockdep checking and without checking or masking the
LSB. Calling code is responsible for handling that.

Preparatory patch to provide NMI safe clock monotonic[_raw] accessor
functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/seqlock.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: tip/include/linux/seqlock.h
===================================================================
--- tip.orig/include/linux/seqlock.h
+++ tip/include/linux/seqlock.h
@@ -117,6 +117,22 @@ repeat:
 }
 
 /**
+ * raw_read_seqcount - Read the raw seqcount
+ * @s: pointer to seqcount_t
+ * Returns: count to be passed to read_seqcount_retry
+ *
+ * raw_read_seqcount opens a read critical section of the given
+ * seqcount without any lockdep checking and without checking or
+ * masking the LSB. Calling code is responsible for handling that.
+ */
+static inline unsigned raw_read_seqcount(const seqcount_t *s)
+{
+	unsigned ret = ACCESS_ONCE(s->sequence);
+	smp_rmb();
+	return ret;
+}
+
+/**
  * raw_read_seqcount_begin - start seq-read critical section w/o lockdep
  * @s: pointer to seqcount_t
  * Returns: count to be passed to read_seqcount_retry


