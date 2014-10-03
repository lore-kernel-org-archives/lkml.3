Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbaJDA0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:26:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbaJCVnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH 3.16 182/357] ARM: edma: Fix configuration parsing for SoCs with multiple eDMA3 CC
Date: Fri,  3 Oct 2014 14:29:28 -0700
Message-Id: <20141003212938.945863492@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit 929a015b1809a30748d487f9d25b16a41434b61a upstream.

The edma_setup_from_hw() should know about the CC number when parsing the
CCCFG register - when it reads the register to be precise. The base
addresses for CCs stored in an array and we need to provide the correct id
to edma_read() in order to read the correct register.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/common/edma.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1415,14 +1415,14 @@ void edma_clear_event(unsigned channel)
 EXPORT_SYMBOL(edma_clear_event);
 
 static int edma_setup_from_hw(struct device *dev, struct edma_soc_info *pdata,
-			      struct edma *edma_cc)
+			      struct edma *edma_cc, int cc_id)
 {
 	int i;
 	u32 value, cccfg;
 	s8 (*queue_priority_map)[2];
 
 	/* Decode the eDMA3 configuration from CCCFG register */
-	cccfg = edma_read(0, EDMA_CCCFG);
+	cccfg = edma_read(cc_id, EDMA_CCCFG);
 
 	value = GET_NUM_REGN(cccfg);
 	edma_cc->num_region = BIT(value);
@@ -1436,7 +1436,8 @@ static int edma_setup_from_hw(struct dev
 	value = GET_NUM_EVQUE(cccfg);
 	edma_cc->num_tc = value + 1;
 
-	dev_dbg(dev, "eDMA3 HW configuration (cccfg: 0x%08x):\n", cccfg);
+	dev_dbg(dev, "eDMA3 CC%d HW configuration (cccfg: 0x%08x):\n", cc_id,
+		cccfg);
 	dev_dbg(dev, "num_region: %u\n", edma_cc->num_region);
 	dev_dbg(dev, "num_channel: %u\n", edma_cc->num_channels);
 	dev_dbg(dev, "num_slot: %u\n", edma_cc->num_slots);
@@ -1655,7 +1656,7 @@ static int edma_probe(struct platform_de
 			return -ENOMEM;
 
 		/* Get eDMA3 configuration from IP */
-		ret = edma_setup_from_hw(dev, info[j], edma_cc[j]);
+		ret = edma_setup_from_hw(dev, info[j], edma_cc[j], j);
 		if (ret)
 			return ret;
 


