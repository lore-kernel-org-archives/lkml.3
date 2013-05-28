Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352Ab3E1D4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52571 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758830Ab3E1DyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ian Abbott" <abbotti@mev.co.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.442086201@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [93/94] staging: comedi: prevent auto-unconfig of manually
 configured devices
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/comedi_fops.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -143,6 +143,9 @@ static long comedi_unlocked_ioctl(struct
 		}
 		rc = do_devconfig_ioctl(dev,
 					(struct comedi_devconfig __user *)arg);
+		if (rc == 0)
+			/* Evade comedi_auto_unconfig(). */
+			dev_file_info->hardware_device = NULL;
 		goto done;
 	}
 

