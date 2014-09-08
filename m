Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaIHP1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:27:00 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50318 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaIHP07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:26:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2] rtc: pcf8563: fix uninitialized use warning
Date: Mon, 08 Sep 2014 17:26:26 +0200
Message-ID: <2750370.rlMuFcoBUA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ejupKWnl96YvEg4NdNd/gkmE0BW3UdJgjqW8cVZA8VR
 GpogbZ9MoTSiGH9wam/OS/mMAIWC7BRR8MiOglQQzc2kZLoHqs
 7pgj1WF4bYcpbVuGsd5cVADqtrtcUKJrsWCUDMn29jMqAsOIf3
 tA2vyalXCLsonCc9RsBCZHmCugRg1andLsnjKuLqc5uxlgnsD3
 CxfRBURSQ40wJQ9eEVsUBcEw0lpgnj0NIC/KNLZGvahevtpdH6
 p0I2w1albYXWwRgKplMPAznueJ9QQl0iWPe8EY1FbL6Lt5dIuu
 gNqEdONza21/rQ9zOHscB5D2Lt+fh1iqu+GCFWGBIbGaIdGelY
 HCLVlaUQof+sbmz+ROhk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc-4.9 found a potential condition under which the 'pending'
variable may be used uninitialized:

drivers/rtc/rtc-pcf8563.c: In function 'pcf8563_irq':
drivers/rtc/rtc-pcf8563.c:173:5: warning: 'pending' may be used uninitialized in this function [-Wmaybe-uninitialized]

This is because in the pcf8563_get_alarm_mode() function, we
check any nonzero return of pcf8563_read_block_data, but
in the irq function we only check for negative values, so
a possible positive value does not get detected if the compiler
chooses not to inline the entire call chain.

Checking for any non-zero value in the interrupt handler as well
is just as correct and lets the compiler know what we are doing,
without needing a bogus initialization.

As pointed out by Sergei Shtylyov, the same code section contains
another bug: an interrupt handler is not supposed to return
an errno value. Let's fix this as well by returning IRQ_NONE
in case of a communication error.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 5a197d9dc7e7..c2ef0a22ee94 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -167,8 +167,8 @@ static irqreturn_t pcf8563_irq(int irq, void *dev_id)
 	char pending;
 
 	err = pcf8563_get_alarm_mode(pcf8563->client, NULL, &pending);
-	if (err < 0)
-		return err;
+	if (err)
+		return IRQ_NONE;
 
 	if (pending) {
 		rtc_update_irq(pcf8563->rtc, 1, RTC_IRQF | RTC_AF);

