Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbaIIMhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:37:32 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:61771 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535AbaIIMha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:37:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: [PATCH v3 2/2] rtc: pcf8563: fix pcf8563_irq error return value
Date: Tue, 09 Sep 2014 14:37:02 +0200
Message-ID: <3249459.KnxQRYTdsz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540DCEB0.6030108@cogentembedded.com>
References: <2750370.rlMuFcoBUA@wuerfel> <540DCEB0.6030108@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Ft1yMnKVFMZ7PZXALAl4Dv1deR4WPYp9Iy9v8J4mpO+
 urd011WR6AwsANiHPhz3XAtiNTz7fL+MGW7WYoYV8ghnlh6EBE
 xLaS4J1AyZc10B0RQmGLOfAbItiiD+b0FuVsVH/7q73AWtwkft
 qtFcS6LNLxF/zQo8DLFi2R4csOAMLMDbN3tiVgX5hfurPcs+41
 ClEs1zW7HIl/EKOmYXaLI7fSJVtorlcJPeqyxFAxN1SOj3J2MA
 1SRFuMAmLvEvLJU/9upvueWP6r1tg/2aGu8KErsSpP60gfdW/6
 OEUiqOHqjvgMFuSoaEL99nsoQ1jmm4V4HRHH65yTyGjHlOWtV0
 95o1ZoPfC9neZ4l6q1YE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Sergei Shtylyov, the pcf8563_irq function
contains a bug in the error handling: an interrupt handler
is not supposed to return an errno value but an 'enum
irqreturn'.

Let's fix this by returning IRQ_NONE in case of a communication error.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 3a6f994c4da8..c2ef0a22ee94 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -168,7 +168,7 @@ static irqreturn_t pcf8563_irq(int irq, void *dev_id)
 
 	err = pcf8563_get_alarm_mode(pcf8563->client, NULL, &pending);
 	if (err)
-		return err;
+		return IRQ_NONE;
 
 	if (pending) {
 		rtc_update_irq(pcf8563->rtc, 1, RTC_IRQF | RTC_AF);

