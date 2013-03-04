Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab3CDEUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:20:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60750 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755394Ab3CDDmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:36 -0500
Message-Id: <20130304033709.244001909@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:24 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 017/153] staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 754ab5c0e55dd118273ca2c217c4d95e9fbc8259 upstream.

Comedi has two sorts of minor devices:
(a) normal board minor devices in the range 0 to
COMEDI_NUM_BOARD_MINORS-1 inclusive; and
(b) special subdevice minor devices in the range COMEDI_NUM_BOARD_MINORS
upwards that are used to open the same underlying comedi device as the
normal board minor devices, but with non-default read and write
subdevices for asynchronous commands.

The special subdevice minor devices get created when a board supporting
asynchronous commands is attached to a normal board minor device, and
destroyed when the board is detached from the normal board minor device.
One way to attach or detach a board is by using the COMEDI_DEVCONFIG
ioctl.  This should only be used on normal board minors as the special
subdevice minors are too ephemeral.  In particular, the change
introduced in commit 7d3135af399e92cf4c9bbc5f86b6c140aab3b88c ("staging:
comedi: prevent auto-unconfig of manually configured devices") breaks
horribly for special subdevice minor devices.

Since there's no legitimate use for the COMEDI_DEVCONFIG ioctl on a
special subdevice minor device node, disallow it and return -ENOTTY.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/comedi_fops.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -136,6 +136,11 @@ static long comedi_unlocked_ioctl(struct
 	/* Device config is special, because it must work on
 	 * an unconfigured device. */
 	if (cmd == COMEDI_DEVCONFIG) {
+		if (minor >= COMEDI_NUM_BOARD_MINORS) {
+			/* Device config not appropriate on non-board minors. */
+			rc = -ENOTTY;
+			goto done;
+		}
 		rc = do_devconfig_ioctl(dev,
 					(struct comedi_devconfig __user *)arg);
 		goto done;


