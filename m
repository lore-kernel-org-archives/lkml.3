Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab3CDESF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:18:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60801 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755350Ab3CDDmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:40 -0500
Message-Id: <20130304033720.971379045@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:23 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Douglas Bagnall <douglas@paradise.net.nz>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 136/153] [media] Avoid sysfs oops when an rc_devs raw device is absent
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Bagnall <douglas@paradise.net.nz>

commit 720bb6436ff30fccad05cf5bdf961ea5b1f5686d upstream.

For some reason, when the lirc daemon learns that a usb remote control
has been unplugged, it wants to read the sysfs attributes of the
disappearing device. This is useful for uncovering transient
inconsistencies, but less so for keeping the system running when such
inconsistencies exist.

Under some circumstances (like every time I unplug my dvb stick from
my laptop), lirc catches an rc_dev whose raw event handler has been
removed (presumably by ir_raw_event_unregister), and proceeds to
interrogate the raw protocols supported by the NULL pointer.

This patch avoids the NULL dereference, and ignores the issue of how
this state of affairs came about in the first place.

Version 2 incorporates changes recommended by Mauro Carvalho Chehab
(-ENODEV instead of -EINVAL, and a signed-off-by).

Signed-off-by: Douglas Bagnall <douglas@paradise.net.nz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/rc/rc-main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -774,10 +774,11 @@ static ssize_t show_protocols(struct dev
 	if (dev->driver_type == RC_DRIVER_SCANCODE) {
 		enabled = dev->rc_map.rc_type;
 		allowed = dev->allowed_protos;
-	} else {
+	} else if (dev->raw) {
 		enabled = dev->raw->enabled_protocols;
 		allowed = ir_raw_get_allowed_protocols();
-	}
+	} else
+		return -ENODEV;
 
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
 		   (long long)allowed,


