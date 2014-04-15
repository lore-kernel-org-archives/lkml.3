Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaDOIzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:55:17 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:34038 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaDOIzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:55:14 -0400
Date: Tue, 15 Apr 2014 10:54:43 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Xiao Jin <jin.xiao@intel.com>
Cc: Johan Hovold <jhovold@gmail.com>, Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        david.a.cohen@linux.intel.com, yanmin.zhang@intel.com
Subject: Re: [PATCH] USB: cdc-acm: fix broken runtime suspend
Message-ID: <20140415085443.GA24422@localhost>
References: <20140411093715.GA17522@localhost>
 <1397505492-10018-1-git-send-email-jhovold@gmail.com>
 <534CECAA.7070900@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534CECAA.7070900@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 04:24:10PM +0800, Xiao Jin wrote:
> On 04/15/2014 03:58 AM, Johan Hovold wrote:

> > Jin, did you check what closing_wait setting your application is using?
> 
> I check the closing_wait is 30s by default. Below is the trace we get 
> when reproduced problem.
> 
>             <...>-1360  [003] d.s5  1843.061418: acm_tty_write: 
> acm_tty_write - write 65
>             <...>-1360  [003] d.s5  1843.061425: acm_write_start: 
> acm_write_start - susp_count 2
>             <...>-2535  [002] ....  1843.180687: acm_tty_close: 
> acm_tty_close
>             <...>-2535  [002] ....  1843.181217: acm_wb_is_avail: avail n=15
>             <...>-2535  [002] ....  1843.181238: acm_port_shutdown: 
> acm_port_shutdown
>             <...>-438   [003] ....  1843.182803: acm_wb_is_avail: avail n=16
>             <...>-438   [003] d..1  1843.182817: acm_tty_write: 
> acm_tty_write - write 11
>             <...>-438   [003] d..1  1843.182826: acm_write_start: 
> acm_write_start - susp_count 2
>             <...>-37    [003] ....  1843.202884: acm_resume: wgq[acm_resume]
>             <...>-37    [003] ....  1843.202892: acm_resume: wgq[acm_resume]
>             <...>-37    [003] d..1  1843.203195: acm_resume: send 
> d_wb-1046297992
>             <...>-37    [003] ....  1843.203199: acm_start_wb: 
> acm_start_wb, acm->transmitting=0
>            <idle>-0     [000] d.h2  1843.203343: acm_write_done.isra.11: 
> acm_write_done, acm->transmitting=1
>             <...>-1989  [001] ....  1843.207197: acm_tty_cleanup: 
> acm_tty_cleanup
> 
> There are two acms in the case, acm0 and acm3. acm0 have delayed 65 
> bytes before close. When acm0 close, ASYNCB_INITIALIZED flag is cleared, 
> that lead to acm0 have no chance to start delayed wb during acm resume.

The ASYNCB_INITIALIZED flag is not cleared until chars_in_buffer returns
0 (or closing_wait times out), so this should not be a problem.

What kernel are you using here?

Can you try to reproduce this using a single ACM device with the
diagnostic patch below applied (on top of v3.14 and my autosuspend fix)?

> acm3 delayed 11 bytes send out because it still is opened.
> It looks closing_wait didn't take effect at that time. I am not sure the 
> reason why because we have no more debug log. Now We are checking the 
> issue again.
> 
> > Could you give this patch a try as well?
> 
> I try the write and resume part of this patch, anchor urb works well.

Thanks for testing.

Johan


>From 3c622243c33a815f66e606531edd3a7ff4e579bf Mon Sep 17 00:00:00 2001
From: Johan Hovold <jhovold@gmail.com>
Date: Tue, 15 Apr 2014 10:44:59 +0200
Subject: [PATCH] USB: cdc-acm: add and enable some extra debugging

---
 drivers/usb/class/cdc-acm.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index ebbcc7a6a7c8..44aa8a620f89 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -28,8 +28,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
-#undef DEBUG
-#undef VERBOSE_DEBUG
+#define DEBUG
+#define VERBOSE_DEBUG
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -175,6 +175,7 @@ static int acm_wb_is_avail(struct acm *acm)
 	spin_lock_irqsave(&acm->write_lock, flags);
 	for (i = 0; i < ACM_NW; i++)
 		n -= acm->wb[i].use;
+	dev_dbg(&acm->data->dev, "%s - %d\n", __func__, n);
 	spin_unlock_irqrestore(&acm->write_lock, flags);
 	return n;
 }
@@ -433,6 +434,8 @@ static void acm_write_bulk(struct urb *urb)
 	struct acm *acm = wb->instance;
 	unsigned long flags;
 
+	dev_dbg(&acm->data->dev, "%s\n", __func__);
+
 	if (urb->status	|| (urb->actual_length != urb->transfer_buffer_length))
 		dev_vdbg(&acm->data->dev, "%s - len %d/%d, status %d\n",
 			__func__,
@@ -632,11 +635,11 @@ static int acm_tty_write(struct tty_struct *tty,
 	int wbn;
 	struct acm_wb *wb;
 
+	dev_vdbg(&acm->data->dev, "%s - count %d, data = %*ph\n", __func__,
+					count, count, buf);
 	if (!count)
 		return 0;
 
-	dev_vdbg(&acm->data->dev, "%s - count %d\n", __func__, count);
-
 	spin_lock_irqsave(&acm->write_lock, flags);
 	wbn = acm_wb_alloc(acm);
 	if (wbn < 0) {
@@ -658,6 +661,8 @@ static int acm_tty_write(struct tty_struct *tty,
 
 	usb_autopm_get_interface_async(acm->control);
 	if (acm->susp_count) {
+		dev_dbg(&acm->data->dev, "%s - suspended", __func__);
+
 		usb_anchor_urb(wb->urb, &acm->delayed);
 		spin_unlock_irqrestore(&acm->write_lock, flags);
 		return count;
@@ -675,26 +680,38 @@ static int acm_tty_write(struct tty_struct *tty,
 static int acm_tty_write_room(struct tty_struct *tty)
 {
 	struct acm *acm = tty->driver_data;
+	int room;
+
 	/*
 	 * Do not let the line discipline to know that we have a reserve,
 	 * or it might get too enthusiastic.
 	 */
-	return acm_wb_is_avail(acm) ? acm->writesize : 0;
+	room = acm_wb_is_avail(acm) ? acm->writesize : 0;
+
+	dev_dbg(&acm->data->dev, "%s - %d\n", __func__, room);
+
+	return room;
 }
 
 static int acm_tty_chars_in_buffer(struct tty_struct *tty)
 {
 	struct acm *acm = tty->driver_data;
+	int chars = 0;
+
 	/*
 	 * if the device was unplugged then any remaining characters fell out
 	 * of the connector ;)
 	 */
 	if (acm->disconnected)
-		return 0;
+		goto out;
 	/*
 	 * This is inaccurate (overcounts), but it works.
 	 */
-	return (ACM_NW - acm_wb_is_avail(acm)) * acm->writesize;
+	chars = (ACM_NW - acm_wb_is_avail(acm)) * acm->writesize;
+out:
+	dev_dbg(&acm->data->dev, "%s - %d\n", __func__, chars);
+
+	return chars;
 }
 
 static void acm_tty_throttle(struct tty_struct *tty)
@@ -1522,6 +1539,8 @@ static int acm_suspend(struct usb_interface *intf, pm_message_t message)
 	struct acm *acm = usb_get_intfdata(intf);
 	int cnt;
 
+	dev_dbg(&intf->dev, "%s\n", __func__);
+
 	if (PMSG_IS_AUTO(message)) {
 		int b;
 
@@ -1554,6 +1573,8 @@ static int acm_resume(struct usb_interface *intf)
 	int rv = 0;
 	int cnt;
 
+	dev_dbg(&intf->dev, "%s\n", __func__);
+
 	spin_lock_irq(&acm->read_lock);
 	acm->susp_count -= 1;
 	cnt = acm->susp_count;
-- 
1.8.3.2

