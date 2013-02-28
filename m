Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222Ab3B1PSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:18:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41982 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab3B1Oqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 029/139] ARM: i.MX25: clk: parent per5_clk to AHB clock
Date: Thu, 28 Feb 2013 14:42:59 +0000
Message-Id: <1362062689-2567-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Trumtrar <s.trumtrar@pengutronix.de>

commit 4b526ca5f627188425184a22ed46c91baa602d43 upstream.

The mxc-timer on the imx25 needs to be derived from the AHB clock.
If a bootloader reparents this clock to the ipg_clk_highfreq, which according
to the datasheet is a valid operation, the system can/will produce lockups/
freezes after some time [1].

This can be forced with code like
	while(1)
                syscall(SYS_clock_gettime, CLOCK_REALTIME, &tp);

This was already fixed with the commit
	"i.MX25 GPT clock fix: ensure correct the clock source" [2],
for 3.1-rc2, but was lost, when i.MX was converted to the common clock framework
("ARM i.MX25: implement clocks using common clock framework") [3]

[1]: http://lists.arm.linux.org.uk/lurker/message/20130129.161230.229bda17.en.html
[2]: 2012d9ca2a1381ae3e733330a7f0d1d2f1988bba
[3]: 6bbaec5676e4f475b0d78743cbd4c70a8804ce14

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-imx/clk-imx25.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-imx/clk-imx25.c b/arch/arm/mach-imx/clk-imx25.c
index 4431a62..ec376d3 100644
--- a/arch/arm/mach-imx/clk-imx25.c
+++ b/arch/arm/mach-imx/clk-imx25.c
@@ -241,6 +241,9 @@ int __init mx25_clocks_init(void)
 	clk_register_clkdev(clk[sdma_ahb], "ahb", "imx35-sdma");
 	clk_register_clkdev(clk[iim_ipg], "iim", NULL);
 
+	/* Clock source for gpt must be derived from AHB */
+	clk_set_parent(clk[per5_sel], clk[ahb]);
+
 	mxc_timer_init(MX25_IO_ADDRESS(MX25_GPT1_BASE_ADDR), 54);
 	return 0;
 }
-- 
1.8.1.2

