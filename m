Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaK1It1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:49:27 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:53245 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaK1It0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:49:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Stein <alexanders83@web.de>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 00/11] ARM: at91: remove !DT support for at91rm9200
Date: Fri, 28 Nov 2014 09:49:10 +0100
Message-ID: <2770184.6f6RpLLlMS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1422574.pPO36BQRH8@kongar>
References: <cover.1417103399.git.nicolas.ferre@atmel.com> <20141128002822.GM4508@piout.net> <1422574.pPO36BQRH8@kongar>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uyqHsv5cGD8iaoI/glzVOlMofj9S1kzPwDPsouOJQh/
 jbCSRbQ0lq67glPh8Q+yExMuRRNwhHhaE9tziYwaXd73W8fAdX
 Ga7tmObini4/Jc3FPqJNpst4xk/Gx5fhYjf3uGHIGp6gdhGrZn
 Irm3yH67UyCMSEA0bnSKFOJaIdLLHJSikAsKwD7nW/0rAdaBfP
 pCh7V6MyLqM3dbGZBmu2t39TNpGepwcggml7Vjic0z5gtn3Ow1
 Cvwp/pjenTTbTjsk1FRMjMa38p1DhfS1frWjQFHXgxjDvdS2MJ
 G6DNlllp/+Qryh+wbhoJ6tjq0VyD+irbPmg/8QDcXi9XKK3z84
 Uvc28e4pInXrUSaZ6tlA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2014 09:27:38 Alexander Stein wrote:
> Hi Alexandre,
> 
> On Friday 28 November 2014, 01:28:22 wrote Alexandre Belloni:
> > > >  - sound/atmel/ac97c.c (that one is still not converted to DT anyway...)
> > > 
> > > This one seems fairly straightforward to do, including a DT binding,
> > > but the result is still ugly as it supports the at32 chips that
> > > do things very differently.
> > > 
> > > The patch below gets it to compile and should be enough as a replacement
> > > once a compatible string gets added.
> > > 
> > 
> > Actually, some work was done but we never saw an other version of the
> > series. Alexander, are you still interested? Else we can take the patch
> > below.
> > 
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/246679.html

I see. Yes, the approach is similar, and there are actually multiple
independent problems:

- getting the current driver to build with multiplatform (trivial, 5 lines)
- changing the gpio handling to work with DT (simple, both of us did that)
- writing the binding (simple)
- changing the driver to ASoC (not that simple)

> Well, I tried to get a ac97c driver based on alsa soc framework as suggested 
> by Takashi. But I failed so far, I could not get my head around those 
> architecture.

Let's just start with the trivial first patch, that can probably just be merged
into 3.19, and then we can build on top of that later if anybody wants to
get ac97 working again on at91.

> When keeping my DT support on the current driver, the only thing which is open 
> that the bindings should be modifed that they are like soc-ac97link bindings.

Makes sense, if that binding works on the at91 hardware. I'm not sure
whether the pinctrl stuff or the first two gpio lines apply though.

	Arnd

8<---
ALSA: atmel: fix building the ac97 driver for at91-multiplatform

at91 will no longer export the mach/cpu.h and mach/hardware.h header files
in the future, which would break building the atmel ac97c driver.

Since the cpu_is_* check is only used to find out whether we are running
on avr32 or arm/at91, we can hardcode that check in the ARM case.

Unfortunately the driver is missing other work to be useful again on ARM,
if anyone wants to actually use it, they need to add a DT binding, and
the driver should really be converted to use the ASoC framework.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: http://www.spinics.net/lists/arm-kernel/msg382068.html

diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index b59427d5a697..4eec216b7f92 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -34,10 +34,10 @@
 #include <linux/platform_data/dma-dw.h>
 #include <linux/dma/dw.h>
 
+#ifdef CONFIG_AVR32
 #include <mach/cpu.h>
-
-#ifdef CONFIG_ARCH_AT91
-#include <mach/hardware.h>
+#else
+#define cpu_is_at32ap7000() (0)
 #endif
 
 #include "ac97c.h"

