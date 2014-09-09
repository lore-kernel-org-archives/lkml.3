Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbaIIMhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:37:17 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:60413 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbaIIMhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:37:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: [PATCH v3 1/2] rtc: pcf8563: fix uninitialized use warning
Date: Tue, 09 Sep 2014 14:36:30 +0200
Message-ID: <19416272.eCNUZ3hTWV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540DCEB0.6030108@cogentembedded.com>
References: <2750370.rlMuFcoBUA@wuerfel> <540DCEB0.6030108@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SF7J1OFxCT/OyuB/bk9mLH8OeM7mtmpMowzwmUhmOdp
 IkszEO1iW3YL82qbazc/HNT2bJGlPerBdnhyx0QSoLuHML7xB+
 y4ENDnVe5/vYSzScJoJ8KekzszhAn60YgyEVhQrmBW4a50tECi
 sNYBjsFspJj6Nt/AC6YdowOLBZsqntqkWkESSv2Wa1oXrTfRUQ
 Da45bwtbJJVT+Qpa5FjfuWkrLjVEibvJTLzbAaQXpW/c3Cg/3m
 69vkmv0t4XZaZEhGU568/0YtbD9g40DnLDscvhFNnmgYAV23AF
 0sLBVt9VxMGMUIR+AFTGDLaHTPnuw8cou4juzPCI3HyaQvzwye
 upRKLYqvj9BH6Ab8iDeA=
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 5a197d9dc7e7..3a6f994c4da8 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -167,7 +167,7 @@ static irqreturn_t pcf8563_irq(int irq, void *dev_id)
 	char pending;
 
 	err = pcf8563_get_alarm_mode(pcf8563->client, NULL, &pending);
-	if (err < 0)
+	if (err)
 		return err;
 
 	if (pending) {

