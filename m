Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab3AKHSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 02:18:53 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:49995 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab3AKHSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 02:18:52 -0500
From: Keun-O Park <kpark3469@gmail.com>
To: rostedt@goodmis.org
Cc: fweisbec@gmail.com, mingo@redhat.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sahara <keun-o.park@windriver.com>
Subject: [PATCH] arm: fix returning wrong CALLER_ADDRx
Date: Fri, 11 Jan 2013 16:18:10 +0900
Message-Id: <1357888690-24012-1-git-send-email-kpark3469@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sahara <keun-o.park@windriver.com>

This makes return_address return correct value for ftrace feature.
unwind_frame does not update frame->lr but frame->pc for backtrace.
And, the initialization for data.addr was missing so that wrong value
returned when unwind_frame failed.

Signed-off-by: sahara <keun-o.park@windriver.com>
---
 arch/arm/kernel/return_address.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
index 8085417..fafedd8 100644
--- a/arch/arm/kernel/return_address.c
+++ b/arch/arm/kernel/return_address.c
@@ -26,7 +26,7 @@ static int save_return_addr(struct stackframe *frame, void *d)
 	struct return_address_data *data = d;
 
 	if (!data->level) {
-		data->addr = (void *)frame->lr;
+		data->addr = (void *)frame->pc;
 
 		return 1;
 	} else {
@@ -41,7 +41,8 @@ void *return_address(unsigned int level)
 	struct stackframe frame;
 	register unsigned long current_sp asm ("sp");
 
-	data.level = level + 1;
+	data.level = level + 2;
+	data.addr = NULL;
 
 	frame.fp = (unsigned long)__builtin_frame_address(0);
 	frame.sp = current_sp;
-- 
1.7.1

