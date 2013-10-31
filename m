Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3JaKTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:19:31 -0400
Received: from 15.mo4.mail-out.ovh.net ([91.121.62.11]:43395 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752357Ab3JaKT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:19:28 -0400
Date: Thu, 31 Oct 2013 11:13:50 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: boris brezillon <b.brezillon@overkiz.com>, linux-watchdog@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Yang Wenyou <wenyou.yang@atmel.com>, Wim Van Sebroeck <wim@iguana.be>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] watchdog: at91sam9_wdt: various fixes
Message-ID: <20131031101350.GB28304@ns203013.ovh.net>
References: <20131029075028.GF19704@spo001.leaseweb.com>
 <1383043053-3520-1-git-send-email-b.brezillon@overkiz.com>
 <20131029154519.GB9266@roeck-us.net>
 <526FE0DA.1020308@overkiz.com>
 <20131029164323.GF9266@roeck-us.net>
 <526FEEE7.7030708@overkiz.com>
 <20131029212738.GA16739@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029212738.GA16739@roeck-us.net>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 3236399284294626063
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:27 Tue 29 Oct     , Guenter Roeck wrote:
> On Tue, Oct 29, 2013 at 06:22:47PM +0100, boris brezillon wrote:
> > On 29/10/2013 17:43, Guenter Roeck wrote:
> > >On Tue, Oct 29, 2013 at 05:22:50PM +0100, boris brezillon wrote:
> > >>On 29/10/2013 16:45, Guenter Roeck wrote:
> > >>>On Tue, Oct 29, 2013 at 11:37:33AM +0100, Boris BREZILLON wrote:
> > >>>>Fix the secs_to_ticks macro in case 0 is passed as an argument.
> > >>>>
> > >>>>Rework the heartbeat calculation to increase the security margin of the
> > >>>>watchdog reset timer.
> > >>>>
> > >>>>Use the min_heartbeat value instead of the calculated heartbeat value for
> > >>>>the first watchdog reset.
> > >>>>
> > >>>>Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> > >>>Hi Boris,
> > >>>
> > >>>can you possibly split the three changes into separate patches ?
> > >>Sure. My first idea was to split this in 3 patches, but, as the
> > >>buggy at91 watchdog series was
> > >>already applied to linux-watchdog-next, I thought it would be faster
> > >>to only provide one
> > >>patch to fix all the issues at once.
> > >>
> > >>>The first is a no-brainer. Gives my opinion of my code review capabilities
> > >>>a slight damper ;-).
> > >>>
> > >>>For the other two problems, it might make sense to describe
> > >>>the problems you are trying to solve.
> > >>>
> > >>>Couple of comments inline.
> > >>>
> > >>>Thanks,
> > >>>Guenter
> > >>>
> > >>>
> > >>>>---
> > >>>>  drivers/watchdog/at91sam9_wdt.c |   35 ++++++++++++++++++++++++-----------
> > >>>>  1 file changed, 24 insertions(+), 11 deletions(-)
> > >>>>
> > >>>>diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
> > >>>>index 9bd089e..f1b59f1 100644
> > >>>>--- a/drivers/watchdog/at91sam9_wdt.c
> > >>>>+++ b/drivers/watchdog/at91sam9_wdt.c
> > >>>>@@ -51,7 +51,7 @@
> > >>>>  #define ticks_to_hz_rounddown(t)	((((t) + 1) * HZ) >> 8)
> > >>>>  #define ticks_to_hz_roundup(t)		(((((t) + 1) * HZ) + 255) >> 8)
> > >>>>  #define ticks_to_secs(t)		(((t) + 1) >> 8)
> > >>>>-#define secs_to_ticks(s)		(((s) << 8) - 1)
> > >>>>+#define secs_to_ticks(s)		(s ? (((s) << 8) - 1) : 0)
> > >>>	(s)
> > >>>
> > >>>>  #define WDT_MR_RESET	0x3FFF2FFF
> > >>>>@@ -61,6 +61,11 @@
> > >>>>  /* Watchdog max delta/value in secs */
> > >>>>  #define WDT_COUNTER_MAX_SECS	ticks_to_secs(WDT_COUNTER_MAX_TICKS)
> > >>>>+/* Watchdog heartbeat shift used for security margin:
> > >>>>+ * we'll try to rshift the heartbeat value with this value to secure
> > >>>>+ * the watchdog reset. */
> > >>>>+#define WDT_HEARTBEAT_SHIFT	2
> > >>>>+
> > >>>>  /* Hardware timeout in seconds */
> > >>>>  #define WDT_HW_TIMEOUT 2
> > >>>>@@ -158,7 +163,9 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
> > >>>>  	int err;
> > >>>>  	u32 mask = wdt->mr_mask;
> > >>>>  	unsigned long min_heartbeat = 1;
> > >>>>+	unsigned long max_heartbeat;
> > >>>>  	struct device *dev = &pdev->dev;
> > >>>>+	int shift;
> > >>>>  	tmp = wdt_read(wdt, AT91_WDT_MR);
> > >>>>  	if ((tmp & mask) != (wdt->mr & mask)) {
> > >>>>@@ -181,23 +188,27 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
> > >>>>  	if (delta < value)
> > >>>>  		min_heartbeat = ticks_to_hz_roundup(value - delta);
> > >>>>-	wdt->heartbeat = ticks_to_hz_rounddown(value);
> > >>>>-	if (!wdt->heartbeat) {
> > >>>>+	max_heartbeat = ticks_to_hz_rounddown(value);
> > >>>>+	if (!max_heartbeat) {
> > >>>>  		dev_err(dev,
> > >>>>  			"heartbeat is too small for the system to handle it correctly\n");
> > >>>>  		return -EINVAL;
> > >>>>  	}
> > >>>>-	if (wdt->heartbeat < min_heartbeat + 4) {
> > >>>>+	for (shift = WDT_HEARTBEAT_SHIFT; shift > 0; shift--) {
> > >>>>+		if ((max_heartbeat >> shift) < min_heartbeat)
> > >>>>+			continue;
> > >>>>+
> > >>>>+		wdt->heartbeat = max_heartbeat >> shift;
> > >>>>+		break;
> > >>>>+	}
> > >>>>+
> > >>>>+	if (!shift)
> > >>>>  		wdt->heartbeat = min_heartbeat;
> > >>>Correct me if I am wrong, but it seems to me that
> > >>>
> > >>>	if ((max_heartbeat >> 2) >= min_heartbeat)
> > >>>		 wdt->heartbeat = max_heartbeat >> 2;
> > >>>	else if ((max_heartbeat >> 1) >= min_heartbeat)
> > >>>		wdt->heartbeat = max_heartbeat >> 1;
> > >>>	else
> > >>>		wdt->heartbeat = min_heartbeat;
> > >>>
> > >>>would accomplish the same and be easier to understand.
> > >>This is exactly what I'm trying to accomplish.
> > >>I used the for loop in case we ever want to change the
> > >>WDT_HEARTBEAT_SHIFT value
> > >>(which is unlikely to happen).
> > >>
> > >>I'll move to your proposition.
> > >>
> > >>>However, given that, I wonder if it is really necessary to bail out above if
> > >>>max_heartbeat is 0. After all, you set heartbeat to min_heartbeat anyway
> > >>>in this case.
> > >>Yes it is necessary. The max_heartbeat is a configuration that
> > >>cannot be changed once configured.
> > >>We have to inform the user that his max_heartbeat value is too small
> > >>to be handled correctly by the Linux kernel.
> > >>
> > >>If we simply use the min_heartbeat value as heartbeat and ignore the
> > >>wrong max_heartbeat value,
> > >>the watchdog will reset the SoC before we can ever reset the
> > >>watchdog counter.
> > >>
> > >>>>+
> > >>>>+	if (max_heartbeat < min_heartbeat + 4)
> > >>>>  		dev_warn(dev,
> > >>>>  			 "min heartbeat and max heartbeat might be too close for the system to handle it correctly\n");
> > >>>>-		if (wdt->heartbeat < 4)
> > >>>>-			dev_warn(dev,
> > >>>>-				 "heartbeat might be too small for the system to handle it correctly\n");
> > >>>>-	} else {
> > >>>>-		wdt->heartbeat -= 4;
> > >>>>-	}
> > >>>>  	if ((tmp & AT91_WDT_WDFIEN) && wdt->irq) {
> > >>>>  		err = request_irq(wdt->irq, wdt_interrupt,
> > >>>>@@ -213,7 +224,9 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
> > >>>>  			 tmp & wdt->mr_mask, wdt->mr & wdt->mr_mask);
> > >>>>  	setup_timer(&wdt->timer, at91_ping, (unsigned long)wdt);
> > >>>>-	mod_timer(&wdt->timer, jiffies + wdt->heartbeat);
> > >>>>+	/* Use min_heartbeat the first time because the watchdog timer might
> > >>>>+	 * be running for a long time when we reach this init function. */
> > >>>	/*
> > >>>	 * Multi-line comment style
> > >>>	 *
> > >>>	 * Not really sure I understand what this accomplishes. What problem
> > >>>	 * are you trying to solve here ?
> > >>>	 */
> > >>Sure, I'll change the comment style.
> > >>
> > >>What, I'm trying to explain, is that the watchdog might (or should)
> > >>have been resetted
> > >>before loading the linux kernel. But loading the kernel takes some
> > >>time (uncompressing,
> > >>low level init, ...), and if we take the heartbeat (or max_heartbeat
> > >>/ 4 in the common case) value as
> > >>the next trigger to reset the watchdog counter, the watchdog timer
> > >>might have already expired.
> > >>
> > >But increasing anything in the watchdog driver itself won't help you there.
> > >You can not execute any kernel code before that kernel code is running.
> > 
> > Of course, but you can at least try to minimize the time between the
> > watchdog driver init
> > and the first wathdog counter reset.
> > 
> Sure.
> 
> > >>Here is an example:
> > >>  - max_heartbeat configured to 8 seconds
> > >>  - min_heartbeat configured to 1 second
> > >>  => heartbeat = 2s
> > >>  - kernel boot time (before at91 watchdog is loaded) = 6 secs
> > >>
> > >Guess that is where I got lost. Do you mean the time from loading the driver
> > >to starting the watchdog application ? Because the init function is only
> > >executed after the driver is loaded, so nothing will help you if it takes
> > >too long for the driver to load.
> > 
> > I think there is another bug here: the driver should not be compiled
> > as a module.
> > 
> > Here is why:
> > 
> > At POR the at91 SoC configure its watchdog with these default values:
> >  - enabled
> >  - min heartbeat = 0 ticks
> >  - max heartbeat = 0xfff ticks <=> 16 secs
> >  - some reset options
> > After a POR the watchdog can only be reconfigured once (and only once).
> > This configuration oftenly takes place in the the bootstrap (or bootloader),
> > but can eventually be done by the Linux kernel.
> > 
> > If the watchdog is kept enabled by the bootstrap (or bootloader), this means
> > the linux kernel will have to reset the watchdog counter as soon as
> > possible to avoid
> > a possible watchdog reset.
> > 
> > => If we authorize the at91 sam9 watchdog to be compiled as a
> > module, we're not sure
> > the module will be loaded soon enough to be able to reset the
> > watchdog counter.
> > 
> Agreed, but that is only an issue _if_ the watchdog is enabled from ROMMON,
> which we don't know. This makes it a configuration issue: If the watchdog 
> is enabled by ROMMON, the driver should not be built as module. On the other
> side, unless it is known for sure (say, from the HW architecture) that it
> is always enabled, we should not force everyone to build it into the kernel.
> 
> Other drivers deal with that condition by only resetting and re-initializing
> the watchdog if it is already running. This driver is a bit of an exception,
> as it always enables the watchdog during initialization. Which is actually
> another reason to be able to build it as module: If the watchdog was not
> enabled by ROMMON, this ensures that it only starts running when the module
> is loaded.

this make no sense on at91 as the watchdog is always ON and can be disable
only once

so always enable as builtin is the right way to do

Best Regards
J.
