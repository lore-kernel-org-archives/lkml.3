Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab3EGN4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:56:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42505 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab3EGNmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 090/118] usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the ctrl ep
Date: Tue,  7 May 2013 14:38:56 +0100
Message-Id: <1367933964-1564-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/devio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 62679bc..f70b887 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -681,6 +681,8 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
 	index &= 0xff;
 	switch (requesttype & USB_RECIP_MASK) {
 	case USB_RECIP_ENDPOINT:
+		if ((index & ~USB_DIR_IN) == 0)
+			return 0;
 		ret = findintfep(ps->dev, index);
 		if (ret >= 0)
 			ret = checkintf(ps, ret);
-- 
1.8.1.2

