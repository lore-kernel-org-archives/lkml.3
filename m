Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3EAPCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:02:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760666Ab3EAPCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:02:19 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=PqpiappLIvcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=v-06TqOow7oA:10 a=VwQbUJbxAAAA:8 a=RmgbkJcQAAAA:8 a=yPCof4ZbAAAA:8 a=7dDkqBXu-sf8KlXSAAoA:9 a=QEXdDO2ut3YA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367420537.30667.91.camel@gandalf.local.home>
Subject: [PATCH] init: Do not warn on non-zero initcall return
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 01 May 2013 11:02:17 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f91eb62f71 "init: scream bloody murder if interrupts are enabled
too early" added three new warnings. The first two seemed reasonable,
but the third included a warning when an initcall returned non-zero.
Although, the third WARN() does include an imbalanced preempt disabled,
or irqs disable, it shouldn't warn if it only had an initcall that just
returns non-zero.

Link: http://lkml.kernel.org/r/20130501134814.GA5001@phenom.dumpdata.com

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/init/main.c b/init/main.c
index bea1287..f0106bf 100644
--- a/init/main.c
+++ b/init/main.c
@@ -678,6 +678,7 @@ int __init_or_module do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
 	int ret;
+	bool warn = false;
 
 	if (initcall_debug)
 		ret = do_one_initcall_debug(fn);
@@ -692,12 +693,17 @@ int __init_or_module do_one_initcall(initcall_t fn)
 	if (preempt_count() != count) {
 		strlcat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
 		preempt_count() = count;
+		warn = true;
 	}
 	if (irqs_disabled()) {
 		strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
 		local_irq_enable();
+		warn = true;
+	}
+	if (msgbuf[0]) {
+		pr_err("initcall %pF returned with %s\n", fn, msgbuf);
+		WARN_ON(warn);
 	}
-	WARN(msgbuf[0], "initcall %pF returned with %s\n", fn, msgbuf);
 
 	return ret;
 }


