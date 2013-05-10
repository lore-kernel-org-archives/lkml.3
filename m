Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab3EJO2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:28:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57271 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289Ab3EJOV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Hans de Goede" <hdegoede@redhat.com>,
        "Dave Stikkolorum" <d.r.stikkolorum@hhs.nl>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.971858759@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [039/118] usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT
 on the ctrl ep
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 1361bf4b9f9ef45e628a5b89e0fd9bedfdcb7104 upstream.

When usbfs receives a ctrl-request from userspace it calls check_ctrlrecip,
which for a request with USB_RECIP_ENDPOINT tries to map this to an interface
to see if this interface is claimed, except for ctrl-requests with a type of
USB_TYPE_VENDOR.

When trying to use this device: http://www.akaipro.com/eiepro
redirected to a Windows vm running on qemu on top of Linux.

The windows driver makes a ctrl-req with USB_TYPE_CLASS and
USB_RECIP_ENDPOINT with index 0, and the mapping of the endpoint (0) to
the interface fails since ep 0 is the ctrl endpoint and thus never is
part of an interface.

This patch fixes this ctrl-req failing by skipping the checkintf call for
USB_RECIP_ENDPOINT ctrl-reqs on the ctrl endpoint.

Reported-by: Dave Stikkolorum <d.r.stikkolorum@hhs.nl>
Tested-by: Dave Stikkolorum <d.r.stikkolorum@hhs.nl>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/devio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -643,6 +643,8 @@ static int check_ctrlrecip(struct dev_st
 	index &= 0xff;
 	switch (requesttype & USB_RECIP_MASK) {
 	case USB_RECIP_ENDPOINT:
+		if ((index & ~USB_DIR_IN) == 0)
+			return 0;
 		ret = findintfep(ps->dev, index);
 		if (ret >= 0)
 			ret = checkintf(ps, ret);

