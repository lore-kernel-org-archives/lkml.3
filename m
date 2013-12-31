Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3LaWMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 17:12:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55271 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab3LaWMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 17:12:05 -0500
Date: Tue, 31 Dec 2013 23:12:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>, Sebastian Reichel <sre@ring0.de>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Message-ID: <20131231221202.GB25336@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +static struct task_struct *h4p_thread;
> 
> Can’t this be done using a work queue. You are looking at a 3.14
> kernel the earliest. We have way better primitives these days.

I tried to convert it to work queue, but was not too
succesfull. Workqueue is not really good match for what this is trying
to do... Nokia code relies on sleeping, than timing those sleeps for
signaling. I'm still trying to wrap my head around it.

Ok, I guess I could convert it to one big workqueue task, and leave
the logic alone. Was that what you wanted?

In the meantime, while trying to untangle it:

commit b02dc19d9269f22baa705d16d1019b86acf15758
Author: Pavel <pavel@ucw.cz>
Date:   Tue Dec 31 23:01:23 2013 +0100

    De-obfuscate power management code. Someone please carefully review
    this.
    
    Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/bluetooth/nokia_core.c b/drivers/bluetooth/nokia_core.c
index 85dd106..07761a3 100644
--- a/drivers/bluetooth/nokia_core.c
+++ b/drivers/bluetooth/nokia_core.c
@@ -705,28 +705,22 @@ static irqreturn_t hci_h4p_wakeup_interrupt(int irq, void *dev_inst)
 static inline void hci_h4p_set_pm_limits(struct hci_h4p_info *info, bool set)
 {
 	struct hci_h4p_platform_data *bt_plat_data = info->dev->platform_data;
+	char *sset = set ? "set" : "clear";
 
 	if (unlikely(!bt_plat_data || !bt_plat_data->set_pm_limits))
 		return;
 
-	if (set && !test_bit(H4P_ACTIVE_MODE, &info->pm_flags)) {
+	if (set != !!test_bit(H4P_ACTIVE_MODE, &info->pm_flags)) {
 		bt_plat_data->set_pm_limits(info->dev, set);
-		set_bit(H4P_ACTIVE_MODE, &info->pm_flags);
-		BT_DBG("Change pm constraints to: %s", set ?
-				"set" : "clear");
+		if (set)
+			set_bit(H4P_ACTIVE_MODE, &info->pm_flags);
+		else
+			clear_bit(H4P_ACTIVE_MODE, &info->pm_flags);
+		BT_DBG("Change pm constraints to: %s", sset);
 		return;
 	}
 
-	if (!set && test_bit(H4P_ACTIVE_MODE, &info->pm_flags)) {
-		bt_plat_data->set_pm_limits(info->dev, set);
-		clear_bit(H4P_ACTIVE_MODE, &info->pm_flags);
-		BT_DBG("Change pm constraints to: %s",
-				set ? "set" : "clear");
-		return;
-	}
-
-	BT_DBG("pm constraints remains: %s",
-			set ? "set" : "clear");
+	BT_DBG("pm constraints remains: %s", sset);
 }
 
 static int h4p_run(void *data)
@@ -762,16 +756,17 @@ static int h4p_run(void *data)
 		BT_DBG("Timeout before calculation = %u",
 				jiffies_to_msecs(timeout));
 
-		/* Empiric analyzer  :-) */
 		if (elapsed < TIMEOUT_MIN) {
 			timeout <<= 1;
-			timeout = (timeout > TIMEOUT_MAX) ?
-				TIMEOUT_MAX : timeout;
 		} else {
-			timeout = (elapsed > timeout - TIMEOUT_MIN) ?
-				TIMEOUT_MIN : timeout - elapsed;
+			timeout -= elapsed;
 		}
 
+		if (timeout > TIMEOUT_MAX)
+			timeout = TIMEOUT_MAX;
+		if (timeout < TIMEOUT_MIN)
+			timeout = TIMEOUT_MIN;
+
 		BT_DBG("Timeout after calculation = %u",
 				jiffies_to_msecs(timeout));
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
