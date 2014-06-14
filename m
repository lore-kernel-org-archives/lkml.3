Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaFNIDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 04:03:36 -0400
Received: from ns.horizon.com ([71.41.210.147]:52385 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751911AbaFNIDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 04:03:30 -0400
Date: 14 Jun 2014 04:03:29 -0400
Message-ID: <20140614080329.29871.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140614062458.GC6447@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Want to give this patch a try on your collection of machines?

Not until I fix it to 

+#if ADD_INTERRUPT_BENCH
+static unsigned long avg_cycles;
+
+#define AVG_SHIFT 8	/* Exponential average factor k=1/256 */
+#define FIXED_1_2 (1 << (AVG_SHIFT-1))
+
+static void add_interrupt_bench(cycles_t start)
+{
+	cycles_t duration = random_get_entropy() - start;
+
+	/* Use a weighted moving average */
+	avg_cycles += ((avg_cycles + FIXED_1_2) >> AVG_SHIFT) - duration;
+}
+#else
+#define add_interrupt_bench(x)
+#endif
+

... because the way you did it was just silly.

See net/ipv4/tcp_input.c:tcp_rtt_estimator().

That also shows you how to add a mean deviation estimator, too.
I'll go do that now...
