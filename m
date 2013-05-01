Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3EATAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:00:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3EATAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:00:39 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=s41hujuIc48A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=Lo8YzwtBAMIA:10 a=46IcY0QsjtHZ7vWZ8_MA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367434837.30667.105.camel@gandalf.local.home>
Subject: init: Remove permanent string buffer from do_one_initcall()
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 01 May 2013 15:00:37 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  Linus, I noticed the permanent string when doing the other patch
  and thought we could use a clean up and place it on the stack.
  It's only 64 bytes, and the function is called in limited scope.
  It's just a small amount, but why keep that memory wasted.

  Feel free to add it for 3.10, or perhaps Andrew can pull it
  into -mm for 3.11. This is just a clean up anyway.
]

do_one_initcall() uses a 64 byte string buffer to save a message. This
buffer is declared static and is only used at boot up and when a module
is loaded. As 64 bytes is very small, and this function has very limited
scope, there's no reason to waste permanent memory with this string and
not just simply put it on the stack.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/init/main.c b/init/main.c
index bea1287..d1f1e31 100644
--- a/init/main.c
+++ b/init/main.c
@@ -654,8 +654,6 @@ static void __init do_ctors(void)
 bool initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
-static char msgbuf[64];
-
 static int __init_or_module do_one_initcall_debug(initcall_t fn)
 {
 	ktime_t calltime, delta, rettime;
@@ -678,6 +676,7 @@ int __init_or_module do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
 	int ret;
+	char msgbuf[64];
 
 	if (initcall_debug)
 		ret = do_one_initcall_debug(fn);


