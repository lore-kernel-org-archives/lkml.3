Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808Ab3DBGqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:46:53 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759353Ab3DBGqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:46:51 -0400
From: Richard Weinberger <richard@nod.at>
To: greg@kroah.com
Cc: arnd@arndb.de, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH v2] cs5535-mfgpt: Add another reset method
Date: Tue,  2 Apr 2013 08:46:37 +0200
Message-Id: <1364885197-17212-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <20130402172950.1fd8d6653a4c79b319945212@canb.auug.org.au>
References: <20130402172950.1fd8d6653a4c79b319945212@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CS5535/CS5536 MFGPT has no support to reset the device.
The current method uses an undocumented bit but does not work on all
devices. At least on my ALIX board it completely freezes the board.

This new method tries to soft reset all timers by unconfiguring them.
But this does not clear the RO setup register and therefore it has to
be ignored while probing.

Resetting the timers is not only needed on broken BIOSes also when
kexec is used. Otherwise the new kernel will find preconfigured timers
and odd things will happen.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/misc/cs5535-mfgpt.c | 41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index 9858f36..effd8c6 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -24,8 +24,11 @@
 
 static int mfgpt_reset_timers;
 module_param_named(mfgptfix, mfgpt_reset_timers, int, 0644);
-MODULE_PARM_DESC(mfgptfix, "Reset the MFGPT timers during init; "
-		"required by some broken BIOSes (ie, TinyBIOS < 0.99).");
+MODULE_PARM_DESC(mfgptfix, "Try to reset the MFGPT timers during init; "
+		"required by some broken BIOSes (ie, TinyBIOS < 0.99) or kexec "
+		"(1 = reset the MFGPT using an undocumented bit, "
+		"2 = perform a soft reset by unconfiguring all timers); "
+		"use what works best for you.");
 
 struct cs5535_mfgpt_timer {
 	struct cs5535_mfgpt_chip *chip;
@@ -256,6 +259,28 @@ static void reset_all_timers(void)
 }
 
 /*
+ * This is another sledgehammer to reset all MFGPT timers.
+ * Instead of using the undocumented bit method it clears
+ * IRQ, NMI and RESET settings.
+ */
+static void soft_reset(void)
+{
+	int i;
+	struct cs5535_mfgpt_timer t;
+
+	for (i = 0; i < MFGPT_MAX_TIMERS; i++) {
+		t.nr = i;
+
+		cs5535_mfgpt_toggle_event(&t, MFGPT_CMP1, MFGPT_EVENT_RESET, 0);
+		cs5535_mfgpt_toggle_event(&t, MFGPT_CMP2, MFGPT_EVENT_RESET, 0);
+		cs5535_mfgpt_toggle_event(&t, MFGPT_CMP1, MFGPT_EVENT_NMI, 0);
+		cs5535_mfgpt_toggle_event(&t, MFGPT_CMP2, MFGPT_EVENT_NMI, 0);
+		cs5535_mfgpt_toggle_event(&t, MFGPT_CMP1, MFGPT_EVENT_IRQ, 0);
+		cs5535_mfgpt_toggle_event(&t, MFGPT_CMP2, MFGPT_EVENT_IRQ, 0);
+	}
+}
+
+/*
  * Check whether any MFGPTs are available for the kernel to use.  In most
  * cases, firmware that uses AMD's VSA code will claim all timers during
  * bootup; we certainly don't want to take them if they're already in use.
@@ -271,15 +296,17 @@ static int scan_timers(struct cs5535_mfgpt_chip *mfgpt)
 	int i;
 
 	/* bios workaround */
-	if (mfgpt_reset_timers)
+	if (mfgpt_reset_timers == 1)
 		reset_all_timers();
+	else if (mfgpt_reset_timers == 2)
+		soft_reset();
 
 	/* just to be safe, protect this section w/ lock */
 	spin_lock_irqsave(&mfgpt->lock, flags);
 	for (i = 0; i < MFGPT_MAX_TIMERS; i++) {
 		timer.nr = i;
 		val = cs5535_mfgpt_read(&timer, MFGPT_REG_SETUP);
-		if (!(val & MFGPT_SETUP_SETUP)) {
+		if (!(val & MFGPT_SETUP_SETUP) || mfgpt_reset_timers == 2) {
 			__set_bit(i, mfgpt->avail);
 			timers++;
 		}
@@ -294,6 +321,12 @@ static int cs5535_mfgpt_probe(struct platform_device *pdev)
 	struct resource *res;
 	int err = -EIO, t;
 
+	if (mfgpt_reset_timers < 0 || mfgpt_reset_timers > 2) {
+		dev_err(&pdev->dev, "Bad mfgpt_reset_timers value: %i\n",
+			mfgpt_reset_timers);
+		goto done;
+	}
+
 	/* There are two ways to get the MFGPT base address; one is by
 	 * fetching it from MSR_LBAR_MFGPT, the other is by reading the
 	 * PCI BAR info.  The latter method is easier (especially across
-- 
1.8.1.4

