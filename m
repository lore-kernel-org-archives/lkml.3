Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab3B0Ayh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:54:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760272Ab3BZX6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [ 105/150] ARM: i.MX25: clk: parent per5_clk to AHB clock
Date: Tue, 26 Feb 2013 15:56:02 -0800
Message-Id: <20130226235535.010584733@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-imx25.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/mach-imx/clk-imx25.c
+++ b/arch/arm/mach-imx/clk-imx25.c
@@ -224,6 +224,9 @@ static int __init __mx25_clocks_init(uns
 
 	clk_prepare_enable(clk[emi_ahb]);
 
+	/* Clock source for gpt must be derived from AHB */
+	clk_set_parent(clk[per5_sel], clk[ahb]);
+
 	clk_register_clkdev(clk[ipg], "ipg", "imx-gpt.0");
 	clk_register_clkdev(clk[gpt_ipg_per], "per", "imx-gpt.0");
 


