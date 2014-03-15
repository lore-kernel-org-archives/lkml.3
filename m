Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbaCONDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 09:03:05 -0400
Received: from mx08-00178001.pphosted.com ([62.209.51.94]:51471 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755618AbaCONDC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 09:03:02 -0400
X-Greylist: delayed 1595 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Mar 2014 09:03:02 EDT
From: Youssef TRIKI <youssef.triki@st.com>
To: Chanho Min <chanho.min@lge.com>, Chris Ball <cjb@laptop.org>,
        Chris Ball <chris@printf.net>
Cc: Hankyung Yu <hankyung.yu@lge.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng <b29396@freescale.com>, Kevin Liu <kliu5@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        HyoJun Im <hyojun.im@lge.com>, Gunho Lee <gunho.lee@lge.com>,
        Youssef TRIKI <youssef.triki@st.com>
Date: Sat, 15 Mar 2014 13:35:43 +0100
Subject: RE: [PATCH RESEND] mmc:sdhci: handle busy-end interrupt during
 command
Thread-Topic: [PATCH RESEND] mmc:sdhci: handle busy-end interrupt during
 command
Thread-Index: Ac9AFxEI8/RdiTvnRRmVjapyfYq81wAM3c+Q
Message-ID: <DAE3A3C9CBA1B14593D953926111E0E10150CDA540FC@SAFEX1MAIL1.st.com>
References: <1394864572-27885-1-git-send-email-chanho.min@lge.com>
In-Reply-To: <1394864572-27885-1-git-send-email-chanho.min@lge.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-15_01:2014-03-14,2014-03-15,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

It is not specific to Toshiba devices, and happens with eMMC  devices as well as SD card which support Auto-CMD12 rather than CMD23.
This warning is seen in read operation and the cause is well explained below. Thanks Chanho Min for the patch.
And Thanks to add it to the mainline.

Regards,
Youssef. 

-----Original Message-----
From: Chanho Min [mailto:chanho.min@lge.com] 
Sent: samedi 15 mars 2014 07:23
To: Chris Ball; Chris Ball
Cc: Hankyung Yu; Shawn Guo; Dong Aisheng; Kevin Liu; linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org; HyoJun Im; Gunho Lee; Youssef TRIKI; Chanho Min
Subject: [PATCH RESEND] mmc:sdhci: handle busy-end interrupt during command

It is fully legal for a controller to start handling busy-end interrupt before it has signaled that the command has completed. So make sure we do things in the proper order, Or it results that command interrupt is ignored so it can cause unexpected operations. This is founded at some toshiba emmc with the bellow warning.

"mmc0: Got command interrupt 0x00000001 even though no command operation was in progress."

Can anyone ACK/NACK of this patch? Any comment will be appreciated.

Signed-off-by: Hankyung Yu <hankyung.yu@lge.com>
Signed-off-by: Chanho Min <chanho.min@lge.com>
Tested-by: Youssef TRIKI <youssef.triki@st.com>
---
 drivers/mmc/host/sdhci.c  |   17 +++++++++++++++--
 include/linux/mmc/sdhci.h |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c index bd8a098..21f98e7 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1016,6 +1016,7 @@ void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 	mod_timer(&host->timer, jiffies + 10 * HZ);
 
 	host->cmd = cmd;
+	host->busy_handle = 0;
 
 	sdhci_prepare_data(host, cmd);
 
@@ -2271,8 +2272,12 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
 		if (host->cmd->data)
 			DBG("Cannot wait for busy signal when also "
 				"doing a data transfer");
-		else if (!(host->quirks & SDHCI_QUIRK_NO_BUSY_IRQ))
+		else if (!(host->quirks & SDHCI_QUIRK_NO_BUSY_IRQ)
+				&& !host->busy_handle) {
+			/* Mark that command complete before busy is ended */
+			host->busy_handle = 1;
 			return;
+		}
 
 		/* The controller does not support the end-of-busy IRQ,
 		 * fall through and take the SDHCI_INT_RESPONSE */ @@ -2335,7 +2340,15 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
 		 */
 		if (host->cmd && (host->cmd->flags & MMC_RSP_BUSY)) {
 			if (intmask & SDHCI_INT_DATA_END) {
-				sdhci_finish_command(host);
+				/*
+				 * Some cards handle busy-end interrupt
+				 * before the command completed, so make
+				 * sure we do things in the proper order.
+				 */
+				if (host->busy_handle)
+					sdhci_finish_command(host);
+				else
+					host->busy_handle = 1;
 				return;
 			}
 		}
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h index 3e781b8..0118020 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -148,6 +148,7 @@ struct sdhci_host {
 	struct mmc_command *cmd;	/* Current command */
 	struct mmc_data *data;	/* Current data request */
 	unsigned int data_early:1;	/* Data finished before cmd */
+	unsigned int busy_handle:1;	/* Handling the order of Busy-end */
 
 	struct sg_mapping_iter sg_miter;	/* SG state for PIO */
 	unsigned int blocks;	/* remaining PIO blocks */
--
1.7.9.5

