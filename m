Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab3GRXDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:03:52 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55638 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab3GRXDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:03:51 -0400
Date: Thu, 18 Jul 2013 16:03:12 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Vikram Mulukutla <markivx@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] panic: call panic handlers before kmsg_dump
Message-ID: <20130718230312.GA22348@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the panic handlers may produce additional information (via printk)
for the kernel log, it should be reported as part of the panic output
saved by kmsg_dump(). Without this re-ordering, nothing that adds
information to a panic will show up in pstore's view when kmsg_dump
runs, and is therefore not visible to crash reporting tools that examine
pstore output.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/panic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 8018646..b6c482c 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -123,10 +123,14 @@ void panic(const char *fmt, ...)
 	 */
 	smp_send_stop();
 
-	kmsg_dump(KMSG_DUMP_PANIC);
-
+	/*
+	 * Run any panic handlers, including those that might need to
+	 * add information to the kmsg dump output.
+	 */
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
+	kmsg_dump(KMSG_DUMP_PANIC);
+
 	bust_spinlocks(0);
 
 	if (!panic_blink)
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
