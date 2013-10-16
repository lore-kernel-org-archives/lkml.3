Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935545Ab3JPSVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:21:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761225Ab3JPRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [ 07/69] i2c: omap: Clear ARDY bit twice
Date: Wed, 16 Oct 2013 10:44:16 -0700
Message-Id: <20131016174313.765118314@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taras Kondratiuk <taras.kondratiuk@linaro.org>

commit 4cdbf7d346e7461c3b93a26707c852e2c9db3753 upstream.

Initially commit cb527ede1bf6ff2008a025606f25344b8ed7b4ac
"i2c-omap: Double clear of ARDY status in IRQ handler"
added a workaround for undocumented errata ProDB0017052.
But then commit 1d7afc95946487945cc7f5019b41255b72224b70
"i2c: omap: ack IRQ in parts" refactored code and missed
one of ARDY clearings. So current code violates errata.
It causes often i2c bus timeouts on my Pandaboard.

This patch adds a second clearing in place.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-omap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -941,6 +941,9 @@ omap_i2c_isr_thread(int this_irq, void *
 		/*
 		 * ProDB0017052: Clear ARDY bit twice
 		 */
+		if (stat & OMAP_I2C_STAT_ARDY)
+			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_ARDY);
+
 		if (stat & (OMAP_I2C_STAT_ARDY | OMAP_I2C_STAT_NACK |
 					OMAP_I2C_STAT_AL)) {
 			omap_i2c_ack_stat(dev, (OMAP_I2C_STAT_RRDY |


