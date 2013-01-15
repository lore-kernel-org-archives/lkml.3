Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab3AOWcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:32:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:42921 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410Ab3AOWcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 140/221] staging: comedi: prevent auto-unconfig of manually configured devices
Date: Tue, 15 Jan 2013 10:51:07 -0800
Message-Id: <20130115185008.171477146@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 7d3135af399e92cf4c9bbc5f86b6c140aab3b88c upstream.

When a low-level comedi driver auto-configures a device, a `struct
comedi_dev_file_info` is allocated (as well as a `struct
comedi_device`) by `comedi_alloc_board_minor()`.  A pointer to the
hardware `struct device` is stored as a cookie in the `struct
comedi_dev_file_info`.  When the low-level comedi driver
auto-unconfigures the device, `comedi_auto_unconfig()` uses the cookie
to find the `struct comedi_dev_file_info` so it can detach the comedi
device from the driver, clean it up and free it.

A problem arises if the user manually unconfigures and reconfigures the
comedi device using the `COMEDI_DEVCONFIG` ioctl so that is no longer
associated with the original hardware device.  The problem is that the
cookie is not cleared, so that a call to `comedi_auto_unconfig()` from
the low-level driver will still find it, detach it, clean it up and free
it.

Stop this problem occurring by always clearing the `hardware_device`
cookie in the `struct comedi_dev_file_info` whenever the
`COMEDI_DEVCONFIG` ioctl call is successful.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/comedi_fops.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1546,6 +1546,9 @@ static long comedi_unlocked_ioctl(struct
 	if (cmd == COMEDI_DEVCONFIG) {
 		rc = do_devconfig_ioctl(dev,
 					(struct comedi_devconfig __user *)arg);
+		if (rc == 0)
+			/* Evade comedi_auto_unconfig(). */
+			dev_file_info->hardware_device = NULL;
 		goto done;
 	}
 


