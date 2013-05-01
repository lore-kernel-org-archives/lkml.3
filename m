Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3EARf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:35:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3EARfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:35:53 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=WwcAzZA5hS8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KhOJMQ402eIA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=J-W6DWN7uNKZNbKHLuAA:9 a=QEXdDO2ut3YA:10 a=jbrJJM5MRmoA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367429751.30667.99.camel@gandalf.local.home>
Subject: [PATCH v2] init: Do not warn on non-zero initcall return
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 01 May 2013 13:35:51 -0400
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

In fact, according to Linus, it shouldn't print at all. As it only
prints with initcall_debug set, and that already shows enough
information to fix things.

Link: http://lkml.kernel.org/r/CA+55aFzaBC5SFi7=F2mfm+KWY5qTsBmOqgbbs8E+LUS8JK-sBg@mail.gmail.com

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/init/main.c b/init/main.c
index bea1287..ceed17a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -686,11 +686,8 @@ int __init_or_module do_one_initcall(initcall_t fn)
 
 	msgbuf[0] = 0;
 
-	if (ret && ret != -ENODEV && initcall_debug)
-		sprintf(msgbuf, "error code %d ", ret);
-
 	if (preempt_count() != count) {
-		strlcat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
+		sprintf(msgbuf, "preemption imbalance ");
 		preempt_count() = count;
 	}
 	if (irqs_disabled()) {


