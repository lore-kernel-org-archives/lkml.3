Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3LJTRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:17:34 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:51028 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3LJTQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:16:17 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/6] clocksource: clksrc-of: Do not drop unheld reference on device node
Date: Tue, 10 Dec 2013 20:16:09 +0100
Message-Id: <1386702972-25565-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386702972-25565-1-git-send-email-daniel.lezcano@linaro.org>
References: <52A767CB.3010501@linaro.org>
 <1386702972-25565-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>

When booting a recent kernel on ARM with OF_DYNAMIC enabled, the kernel
warns about the following:

	[    0.000000] ERROR: Bad of_node_put() on /timer@50004600
	[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc5-next-20131017-00077-gedfd827-dirty #406
	[    0.000000] [<c0015b68>] (unwind_backtrace+0x0/0xf4) from [<c00117e4>] (show_stack+0x10/0x14)
	[    0.000000] [<c00117e4>] (show_stack+0x10/0x14) from [<c055f734>] (dump_stack+0x9c/0xc8)
	[    0.000000] [<c055f734>] (dump_stack+0x9c/0xc8) from [<c03b47d4>] (of_node_release+0x90/0x9c)
	[    0.000000] [<c03b47d4>] (of_node_release+0x90/0x9c) from [<c03b5084>] (of_find_matching_node_and_match+0x78/0xb4)
	[    0.000000] [<c03b5084>] (of_find_matching_node_and_match+0x78/0xb4) from [<c07887c8>] (clocksource_of_init+0x60/0x70)
	[    0.000000] [<c07887c8>] (clocksource_of_init+0x60/0x70) from [<c076e99c>] (start_kernel+0x1f4/0x33c)
	[    0.000000] [<c076e99c>] (start_kernel+0x1f4/0x33c) from [<80008074>] (0x80008074)

This is caused by clocksource_of_init() dropping a reference on the
device node that it never took. The reference taken by the loop is
implicitly dropped on subsequent iterations. See the implementation of
and the comment on top of the of_find_matching_node_and_match()
function for reference (no pun intended).

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/clocksource/clksrc-of.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
index 35639cf4..b9ddd9e 100644
--- a/drivers/clocksource/clksrc-of.c
+++ b/drivers/clocksource/clksrc-of.c
@@ -35,6 +35,5 @@ void __init clocksource_of_init(void)
 
 		init_func = match->data;
 		init_func(np);
-		of_node_put(np);
 	}
 }
-- 
1.7.9.5

