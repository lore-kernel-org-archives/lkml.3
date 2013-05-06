Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab3EFW7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:59:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab3EFW7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:59:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Stikkolorum <d.r.stikkolorum@hhs.nl>,
        Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 08/46] usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the ctrl ep
Date: Mon,  6 May 2013 15:58:14 -0700
Message-Id: <20130506225821.566570483@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225820.628893970@linuxfoundation.org>
References: <20130506225820.628893970@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/core/devio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -642,6 +642,8 @@ static int check_ctrlrecip(struct dev_st
 	index &= 0xff;
 	switch (requesttype & USB_RECIP_MASK) {
 	case USB_RECIP_ENDPOINT:
+		if ((index & ~USB_DIR_IN) == 0)
+			return 0;
 		ret = findintfep(ps->dev, index);
 		if (ret >= 0)
 			ret = checkintf(ps, ret);


