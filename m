Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab3AYP5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:57:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169Ab3AYP5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:57:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 18/19] ARM: at91: suspend both memory controllers on at91sam9263
Date: Fri, 25 Jan 2013 15:57:29 +0000
Message-ID: <32362906.GDijhnXAWC@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-1-generic; KDE/4.9.98; x86_64; ; )
In-Reply-To: <20130125154219.GM7360@game.jcrosoft.org>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359123276-15833-19-git-send-email-arnd@arndb.de> <20130125154219.GM7360@game.jcrosoft.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:FOJfsh30e+oHGo2k/XCQnrmqJKuEJ1DOoc+91XwJHGn
 b1vjp5RvLc3WxjEUHz49iUd1JvxO2kKFnkVcBBDES4CPUGprFv
 /vcIPEXrO6pUNOTxn7Vy9kyq6pt9AMet/ak3oaQaQAgwQakKZ7
 S3op9zHxqqLe8juwvlat3ilKyMM6pnB5q86V1Nmyd636DcbqWz
 u8ldz/PdR7WdmlGTktWDbwYfOn9QOlQDiFcxMowOPZHp7nJabs
 5ne6g4fgD+yGEryq0znx4ISkpwdrB67PNXr1tPA61Lta0ENs7K
 ocO1oLg9MDf1o5/t6GmZHtRIiXlvfdaU/8xWp2KTrWm+/GfzPv
 mP1KR4v++CawdcGdEgL8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2013 16:42:19 Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 14:14 Fri 25 Jan     , Arnd Bergmann wrote:
> > For the past three years, we have had a #warning in
> > mach-at91 about the sdram_selfrefresh_enable or
> > at91sam9_standby functions possibly not working on
> > at91sam9263. In the meantime a function was added
> > to do the right thing on at91sam9g45, which looks like
> > it should also work on '9263.
> > 
> > This patch blindly removes the warning and changes the
> > at91sam9263 to use the same code at at91sam9g45, which
> > may or may not be the right solution. If it is not,
> > maybe someone could provide a better fix.
> it's not
> 
> the 9g45 use DDR Controler where the 9263 use a SDRAM controler
> 

Ah, right. What about this one then?

	Arnd
	
8<-----
Subject: [PATCH] ARM: at91: suspend both memory controllers on at91sam9263

For the past three years, we have had a #warning in
mach-at91 about the sdram_selfrefresh_enable or
at91sam9_standby functions possibly not working on
at91sam9263. In the meantime a function was added
to do the right thing on at91sam9g45, which looks like
it should also work on '9263.

This patch blindly removes the warning and changes the
at91sam9263 to use the same code at at91sam9g45, which
may or may not be the right solution. If it is not,
maybe someone could provide a better fix.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>

diff --git a/arch/arm/mach-at91/cpuidle.c b/arch/arm/mach-at91/cpuidle.c
index 0c63815..4c67946 100644
--- a/arch/arm/mach-at91/cpuidle.c
+++ b/arch/arm/mach-at91/cpuidle.c
@@ -38,6 +38,8 @@ static int at91_enter_idle(struct cpuidle_device *dev,
 		at91rm9200_standby();
 	else if (cpu_is_at91sam9g45())
 		at91sam9g45_standby();
+	else if (cpu_is_at91sam9263())
+		at91sam9263_standby();
 	else
 		at91sam9_standby();
 
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index adb6db8..b8017c1 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -267,6 +267,8 @@ static int at91_pm_enter(suspend_state_t state)
 				at91rm9200_standby();
 			else if (cpu_is_at91sam9g45())
 				at91sam9g45_standby();
+			else if (cpu_is_at91sam9263())
+				at91sam9263_standby();
 			else
 				at91sam9_standby();
 			break;
diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index 38f467c..2f5908f 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -70,13 +70,31 @@ static inline void at91sam9g45_standby(void)
 	at91_ramc_write(1, AT91_DDRSDRC_LPR, saved_lpr1);
 }
 
-#ifdef CONFIG_SOC_AT91SAM9263
-/*
- * FIXME either or both the SDRAM controllers (EB0, EB1) might be in use;
- * handle those cases both here and in the Suspend-To-RAM support.
+/* We manage both DDRAM/SDRAM controllers, we need more than one value to
+ * remember.
  */
-#warning Assuming EB1 SDRAM controller is *NOT* used
-#endif
+static inline void at91sam9263_standby(void)
+{
+	u32 lpr0, lpr1;
+	u32 saved_lpr0, saved_lpr1;
+
+	saved_lpr1 = at91_ramc_read(1, AT91_SDRAMC_LPR);
+	lpr1 = saved_lpr1 & ~AT91_SDRAMC_LPCB;
+	lpr1 |= AT91_SDRAMC_LPCB_SELF_REFRESH;
+
+	saved_lpr0 = at91_ramc_read(0, AT91_SDRAMC_LPR);
+	lpr0 = saved_lpr0 & ~AT91_SDRAMC_LPCB;
+	lpr0 |= AT91_SDRAMC_LPCB_SELF_REFRESH;
+
+	/* self-refresh mode now */
+	at91_ramc_write(0, AT91_SDRAMC_LPR, lpr0);
+	at91_ramc_write(1, AT91_SDRAMC_LPR, lpr1);
+
+	cpu_do_idle();
+
+	at91_ramc_write(0, AT91_SDRAMC_LPR, saved_lpr0);
+	at91_ramc_write(1, AT91_SDRAMC_LPR, saved_lpr1);
+}
 
 static inline void at91sam9_standby(void)
 {

