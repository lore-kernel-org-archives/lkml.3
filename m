Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3IJVCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:02:25 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60354 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3IJVCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:02:23 -0400
X-Originating-IP: 83.160.107.163
Date: Tue, 10 Sep 2013 23:02:18 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mfd: ti_am335x_tscadc: Fix idle timeout value
Message-ID: <20130910210218.GB30481@raspi>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old timeout value was based on the assumption that the minimum values are
used for the open and sample delay and no averaging is done. In fact the ADC
and touchscreen driver both use an open delay of 152 cycles and averaging over
16 samples. This patch adjusts the timeout value accordingly

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
---
 include/linux/mfd/ti_am335x_tscadc.h | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index db1791b..9e6a775 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -126,13 +126,18 @@
 #define TOTAL_CHANNELS		8
 
 /*
-* ADC runs at 3MHz, and it takes
-* 15 cycles to latch one data output.
-* Hence the idle time for ADC to
-* process one sample data would be
-* around 5 micro seconds.
-*/
-#define IDLE_TIMEOUT 5 /* microsec */
+ * time in us for processing a single channel, calculated as follows:
+ *
+ * num cycles = open delay + (sample delay + conv time) * averaging
+ *
+ * num cycles: 152 + (1 + 13) * 16 = 376
+ *
+ * clock frequency: 26MHz / 8 = 3.25MHz
+ * clock period: 1 / 3.25MHz = 308ns
+ *
+ * processing time: 376 * 308ns = 116us
+ */
+#define IDLE_TIMEOUT 116 /* microsec */
 
 #define TSCADC_CELLS		2
 
-- 
1.8.4.rc3

