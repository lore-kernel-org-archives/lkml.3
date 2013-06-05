Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab3FEVls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:41:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab3FEVgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lingzhu Xiang <lxiang@redhat.com>
Subject: [ 115/127] ASoC: davinci: fix sample rotation
Date: Wed,  5 Jun 2013 14:34:42 -0700
Message-Id: <20130605213231.045127665@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 796718925159523919a589ecbd6d1811c22ef55f upstream.

McASP serial audio engine needs different rotation values on TX and RX
channels. Commit dde109fb462 ("ASoC: McASP: Fix data rotation for
playback. Enables 24bit audio playback") changed the calculation to fix
the playback format, but broke the capture stream by doing it for both
TXFMT and RXFMT.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/davinci/davinci-mcasp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -626,7 +626,8 @@ static int davinci_config_channel_size(s
 				       int word_length)
 {
 	u32 fmt;
-	u32 rotate = (word_length / 4) & 0x7;
+	u32 tx_rotate = (word_length / 4) & 0x7;
+	u32 rx_rotate = (32 - word_length) / 4;
 	u32 mask = (1ULL << word_length) - 1;
 
 	/*
@@ -647,9 +648,9 @@ static int davinci_config_channel_size(s
 					RXSSZ(fmt), RXSSZ(0x0F));
 	mcasp_mod_bits(dev->base + DAVINCI_MCASP_TXFMT_REG,
 					TXSSZ(fmt), TXSSZ(0x0F));
-	mcasp_mod_bits(dev->base + DAVINCI_MCASP_TXFMT_REG, TXROT(rotate),
+	mcasp_mod_bits(dev->base + DAVINCI_MCASP_TXFMT_REG, TXROT(tx_rotate),
 							TXROT(7));
-	mcasp_mod_bits(dev->base + DAVINCI_MCASP_RXFMT_REG, RXROT(rotate),
+	mcasp_mod_bits(dev->base + DAVINCI_MCASP_RXFMT_REG, RXROT(rx_rotate),
 							RXROT(7));
 	mcasp_set_reg(dev->base + DAVINCI_MCASP_TXMASK_REG, mask);
 	mcasp_set_reg(dev->base + DAVINCI_MCASP_RXMASK_REG, mask);


