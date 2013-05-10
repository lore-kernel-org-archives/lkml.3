Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab3EJVS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:18:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28393 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3EJVS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:18:26 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=lCtUp-edVtwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ASeoVxjNus4A:10 a=fftbd8lyitm2-44GTeUA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130510211825.504050840@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 17:12:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is enabled
References: <20130510211225.594959788@goodmis.org>
Content-Disposition: inline; filename=no-hz-full-prevents-lockup-detector.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to test the nohz_full code, I was not able to get it to work.
Finally I enabled the tick_stop tracepoint and it showed:

 tick_stop:            success=no msg=perf events running

I talked to Frederic Weisbecker about this and he informed me that
perf is used by the lockup detector. I checked the code, and sure
enough it is.

As perf is always running when LOCKUP_DETECTOR is enabled, which
will always disable nohz_full from working, instead of confusing
users, disable LOCKUP_DETECTOR when NO_HZ_FULL is enabled.

When perf is changed such that it does not prevent nohz_full from
working, then we can and should remove this constraint.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 566cf2b..1364d09 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -174,6 +174,8 @@ config DEBUG_SHIRQ
 config LOCKUP_DETECTOR
 	bool "Detect Hard and Soft Lockups"
 	depends on DEBUG_KERNEL && !S390
+	# Lockup detector currently prevents NO_HZ_FULL from working
+	depends on !NO_HZ_FULL
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
 	  hard and soft lockups.

