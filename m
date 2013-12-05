Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3LEIef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:34:35 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42411 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3LEIed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:34:33 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-2e-52a03a96a869
Subject: [PATCH 2/2] ARM: fix framepointer check in unwind_frame
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Date: Thu, 05 Dec 2013 12:34:30 +0400
Message-id: <20131205083430.32632.11103.stgit@buzz>
In-reply-to: <20131205083424.32632.51618.stgit@buzz>
References: <20131205083424.32632.51618.stgit@buzz>
User-Agent: StGit/0.15
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xq7rTrBYEGRz9pWXxY2cvq8Wmx9dY
	LS7vmsNmcfsyr8XUGT/YLV5+PMHiwOaxZt4aRo+W5h42j81L6j36tqxi9Pi8SS6ANYrLJiU1
	J7MstUjfLoErY8KKfawF7WwVJ95vZW9gfM/SxcjJISFgInGx8QgbhC0mceHeejBbSGApo8Tx
	x6IQdgOTxJdLZSC2sICDxO3VH8BqRATyJb4e2ANmswmYSWzbd5sRxGYW8JfY2DqbGcRmEVCV
	aJ48hxXE5hUwlmj8ew1sLyfQ3hOzZgPFOYDmG0tMnCALEhYFOmHNpZNMEOWCEj8m32MBKWEW
	UJeYMiUXYrq8xOY1b5knMArMQlI1C6FqFpKqBYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNz
	NzFCwvnrDsalx6wOMQpwMCrx8DqmzA8SYk0sK67MPcQowcGsJMIba7EgSIg3JbGyKrUoP76o
	NCe1+BAjEwenVAOjUtCelNhPS/k9v53wsmGcmfqibYdQw/XPQee/iBzO+23Htnta5Q6/E4e+
	c1y9xdR8nF3ObO+ClEZfF4fjflcWXM9+3Tk5ga/u/ZqdLU2W9ndEAh9kvHlsI65ksMXJb5Pz
	7uzK269fS1xOary47o9Kz/+NUXfkA4JX1DffOlnZt9C4MOzVHeebSizFGYmGWsxFxYkAP5oH
	5UUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes corner case when (fp + 4) overflows unsigned long,
for example: fp = 0xFFFFFFFF -> fp + 4 == 3.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 arch/arm/kernel/stacktrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index 00f79e5..af4e8c8 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -31,7 +31,7 @@ int notrace unwind_frame(struct stackframe *frame)
 	high = ALIGN(low, THREAD_SIZE);
 
 	/* check current frame pointer is within bounds */
-	if (fp < (low + 12) || fp + 4 >= high)
+	if (fp < low + 12 || fp > high - 4)
 		return -EINVAL;
 
 	/* restore the registers from the stack frame */

