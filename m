Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab3A3BWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:22:35 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:36135 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3A3BWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:22:32 -0500
From: kpark3469@gmail.com
To: linux@arm.linux.org.uk
Cc: keun-o.park@windriver.com, dave.martin@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com
Subject: [PATCH v2] arm: fix returning wrong CALLER_ADDRx
Date: Wed, 30 Jan 2013 10:20:49 +0900
Message-Id: <1359508849-2831-1-git-send-email-kpark3469@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sahara <keun-o.park@windriver.com>

This makes return_address return correct value for ftrace feature.
unwind_frame does not update frame->lr but frame->pc for backtrace.
And, the initialization for data.addr was missing so that wrong value
returned when unwind_frame failed.

Signed-off-by: Sahara <keun-o.park@windriver.com>
Reviewed-by: Dave Martin <dave.martin@linaro.org>
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

